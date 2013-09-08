//
//  SSAppDelegate.h
//  ShapeScroll
//
//  Created by Satoru Takahashi on 2013/09/08.
//  Copyright (c) 2013年 Satoru Takahashi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSViewController;

@interface SSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SSViewController *viewController;

@end
