//
//  KHMainViewController.h
//  ImageUsingOpenGLDemo
//
//  Created by admin on 14-8-21.
//  Copyright (c) 2014年 ___HUSHUHUI___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KHOpenGLView.h"

@interface KHMainViewController : UIViewController
                        <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>
{
    KHOpenGLView  *_glview;
    IBOutlet UIView *plain;
    IBOutlet UIScrollView *scrollPlain;
}

@end
