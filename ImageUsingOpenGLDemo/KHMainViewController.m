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
            _glview = [[KHOpenGLView alloc] initWithFrame:plain.frame withImage:img];
            [plain addSubview:_glview];
        }
        else {
            [_glview displayNewPhoto:img];
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)clean:(id)sender {
    if (_glview) {
        [_glview clean];
    }
}

@end
