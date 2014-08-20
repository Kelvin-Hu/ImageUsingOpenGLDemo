//
//  KHAppDelegate.h
//  ImageUsingOpenGLDemo
//
//  Created by admin on 14-8-19.
//  Copyright (c) 2014年 ___HUSHUHUI___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHOpenGLView.h"

@interface KHAppDelegate : UIResponder <UIApplicationDelegate>
{
    KHOpenGLView* _glView;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet KHOpenGLView *glView;

@end
