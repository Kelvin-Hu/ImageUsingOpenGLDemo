//
//  KHMainViewController.m
//  ImageUsingOpenGLDemo
//
//  Created by admin on 14-8-21.
//  Copyright (c) 2014年 ___HUSHUHUI___. All rights reserved.
//

#import "KHMainViewController.h"

@interface KHMainViewController ()

@end

@implementation KHMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//--------------------action-------------------------

- (IBAction)pickUpPhoto:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (img) {
        if (!_glview) {
            _glview = [[KHOpenGLView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) withImage:img];
            [scrollPlain addSubview:_glview];
            [scrollPlain setDelegate:self];
            [scrollPlain setContentSize:img.size];
            [scrollPlain setMinimumZoomScale:0.3];
            [scrollPlain setMaximumZoomScale:2.0];
            
        }
        else {
            NSLog(@"width=%f height=%f",img.size.width,img.size.height);
            [_glview displayNewPhoto:img];
            [scrollPlain setContentSize:img.size];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _glview;
}


- (IBAction)clean:(id)sender {
    if (_glview) {
        [_glview clean];
    }
}

@end
