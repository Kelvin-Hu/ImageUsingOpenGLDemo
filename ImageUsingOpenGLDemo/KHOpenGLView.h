//
//  KHOpenGLView.h
//  ImageUsingOpenGLDemo
//
//  Created by admin on 14-8-19.
//  Copyright (c) 2014年 ___HUSHUHUI___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>

@interface KHOpenGLView : UIView
{
    CAEAGLLayer *_eagllayer;
    EAGLContext *_context;
    GLuint _colorRenderbuffer;
    
    GLuint _positionSlot;
    GLuint _colorSlot;
    
    GLuint _vertexBuffer;
    GLuint _indexBuffer;
    
    GLuint _texture;
    GLuint _textureSlot;
    GLuint _textureUniform;
    
    size_t fixedWidth;
    size_t fixedHeight;
    
}

-(id) initWithFrame:(CGRect)frame withImage:(UIImage *)image;
-(void) displayNewPhoto:(UIImage *)image;
-(void) clean;

@end
