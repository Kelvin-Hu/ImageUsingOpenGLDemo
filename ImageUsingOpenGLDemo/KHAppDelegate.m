//
//  KHAppDelegate.m
//  ImageUsingOpenGLDemo
//
//  Created by admin on 14-8-19.
//  Copyright (c) 2014年 ___HUSHUHUI___. All rights reserved.
//

#import "KHAppDelegate.h"
#import "KHMainViewController.h"

@implementation KHAppDelegate

@synthesize glView=_glView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    /*
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    self.glView = [[KHOpenGLView alloc] initWithFrame:screenBounds];
    [self.window addSubview:_glView];
    */
    
    KHMainViewController *kvc = [[KHMainViewController alloc] init];
    [self.window setRootViewController:kvc];
    
     
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
