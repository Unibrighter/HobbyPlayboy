//
//  MainTabBarController.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

#define HOME_NAV_CONTROLLER_TAG 0
#define FAV_NAV_CONTROLLER_TAG 1
#define SETTING_NAV_CONTROLLER_TAG 2

@class HomeViewController;
@class FavViewController;
@class SettingViewController;

@interface MainTabBarController : UITabBarController

@property (strong, nonatomic) UINavigationController *homeNavController;
@property (strong, nonatomic) UINavigationController *favNavController;
@property (strong, nonatomic) UINavigationController *settingNavController;

- (HomeViewController *)homeViewController;
- (FavViewController *)favViewController;
- (SettingViewController *)settingViewController;

@end
