//
//  AppDelegate.h
//  CitySDKApiMap
//
//  Created by Giovanni on 6/29/13.
//  Copyright (c) 2013 Giovanni Maggini. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class ViewController;

@class MenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) MenuViewController *viewController;

@end
