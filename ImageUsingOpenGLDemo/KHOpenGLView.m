//
//  KHOpenGLView.m
//  ImageUsingOpenGLDemo
//
//  Created by admin on 14-8-19.
//  Copyright (c) 2014年 ___HUSHUHUI___. All rights reserved.
//

#import "KHOpenGLView.h"

typedef struct {
    float Position[3];
    float Color[4];
    float TexCoord[2];
}Vertex;

const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 1, 1, 1}, {1, 0}},
    {{1, 1, 0}, {1, 1, 1, 1}, {1, 1}},
    {{-1, 1, 0}, {1, 1, 1, 1}, {0, 1}},
    {{-1, -1, 0}, {1, 1, 1, 1}, {0, 0}}
};

const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};

@implementation KHOpenGLView


+(Class) layerClass
{
    return [CAEAGLLayer class];
}


-(void) setupLayer
{
    _eagllayer = (CAEAGLLayer *)self.layer;
    _eagllayer.opaque = YES;
}

-(void) setupContext
{
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGl context");
        exit(1);
    }
}


-(void) setupRenderbuffer
{
    glGenRenderbuffers(1, &_colorRenderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderbuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eagllayer];
}


-(void) setupFramebuffer
{
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderbuffer);
}

-(GLuint) compileShader:(NSString *)shaderName withType:(GLenum)shaderType {
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    GLuint shaderHandle = glCreateShader(shaderType);
    
    const char *shaderStringUTF8 = [shaderString UTF8String];
    int ShaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &ShaderStringLength);
    
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar message[256];
        glGetShaderInfoLog(shaderHandle, sizeof(message), 0, &message[0]);
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
    
}


-(void) compileShaders
{
    GLuint vertexShader = [self compileShader:@"VertexShader" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"FragmentShader" withType:GL_FRAGMENT_SHADER];
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar message[256];
        glGetProgramInfoLog(programHandle, sizeof(message), 0, &message[0]);
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSLog(@"%@", messageString);
        exit(1);
    }

    glUseProgram(programHandle);
    
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    
    _textureSlot = glGetAttribLocation(programHandle, "TexCoordIn");
    glEnableVertexAttribArray(_textureSlot);
    _textureUniform = glGetUniformLocation(programHandle, "Texture");
}


-(void) setupVBOs
{
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
}


-(void) render
{
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), 0);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid *)(sizeof(float)*3));
    glVertexAttribPointer(_textureSlot, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*) (sizeof(float) * 7));
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    glUniform1i(_textureUniform, 0);
    
    glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]), GL_UNSIGNED_BYTE, 0);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}


-(void)setupFixedSizeOfTextureWithWidth:(size_t)originalWidth height:(size_t)originalHeight
{
    fixedWidth = 1;
    if ((originalWidth!=1) && (originalWidth & (originalWidth -1))) {
        while (fixedWidth < originalWidth) {
            fixedWidth *= 2;
        }
    }
    else {
        fixedWidth = originalWidth;
    }
    
    fixedHeight = 1;
    if ((originalHeight !=1) && (originalHeight & (originalHeight - 1))) {
        while (fixedHeight < originalHeight) {
            fixedHeight *= 2;
        }
    }
    else {
        fixedHeight = originalHeight;
    }
}


-(GLuint) setupTexture:(NSString *)fileName
{
    CGImageRef image = [UIImage imageNamed:fileName].CGImage;

    if (!image) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    [self setupFixedSizeOfTextureWithWidth:width height:height];
    
    
    GLubyte *imageData = (GLubyte *)calloc(fixedWidth * fixedHeight * 4, sizeof(GLubyte));
    
    
    
    CGContextRef imageContext = CGBitmapContextCreate(imageData, fixedWidth, fixedHeight, 8, fixedWidth * 4,
                                                      CGImageGetColorSpace(image), (CGBitmapInfo)(kCGImageAlphaPremultipliedLast));

    //CGContextTranslateCTM(imageContext, 0, self.frame.size.height);
    //CGContextScaleCTM(imageContext, 1.0, -1.0);
    
    CGContextClearRect(imageContext, CGRectMake(0, 0, fixedWidth, fixedHeight));
    CGContextDrawImage(imageContext, CGRectMake((fixedWidth-width)/2.0, 0, width, height), image);
    
    CGContextRelease(imageContext);
    
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fixedWidth, fixedHeight, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    free(imageData);
    return texName;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderbuffer];
        [self setupFramebuffer];
        [self compileShaders];
        [self setupVBOs];
        _texture = [self setupTexture:@"baby.jpg"];
        [self render];
    }
    return self;
}

-(void)dealloc{
    _context = nil;
}

@end
