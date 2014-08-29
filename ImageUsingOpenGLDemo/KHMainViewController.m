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
            [self setAutoscale];
        }
        else {
            [_glview removeFromSuperview];
            _glview = [[KHOpenGLView alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height) withImage:img];
            [self setAutoscale];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _glview;
}

-(void)setAutoscale
{
    [scrollPlain setDelegate:self];
    [scrollPlain setBouncesZoom:YES];
    [scrollPlain.panGestureRecognizer setMinimumNumberOfTouches:2];
    [scrollPlain addSubview:_glview];
    [scrollPlain setContentSize:_glview.frame.size];
    
    float x_scale = scrollPlain.frame.size.width / _glview.frame.size.width;
    float y_scale = scrollPlain.frame.size.height / _glview.frame.size.height;
    float currentScale = x_scale < y_scale ? x_scale : y_scale;
    
    [scrollPlain setMinimumZoomScale:currentScale];
    [scrollPlain setMaximumZoomScale:1.0];
    [scrollPlain setZoomScale:currentScale];
}

- (IBAction)clean:(id)sender {
    if (_glview) {
        [_glview removeFromSuperview];
        _glview = nil;
    }
}





@end
