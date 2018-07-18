//
//  AppDelegate.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) MainTabBarController* mainTabBarController;
@property (strong, nonatomic) UIWindow *window;

@end

