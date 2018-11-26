//
//  MainTabBarController.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "MainTabBarController.h"
#import "FavViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init tabs
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    HomeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:[HomeViewController className]];
    self.homeNavController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    self.homeNavController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:HOME_NAV_CONTROLLER_TAG];
    [self.homeNavController.tabBarItem setValue:@"Home" forKey:@"internalTitle"];
    
    FavViewController *favViewController = [storyboard instantiateViewControllerWithIdentifier:[FavViewController className]];
    self.favNavController = [[UINavigationController alloc] initWithRootViewController:favViewController];
    self.favNavController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:FAV_NAV_CONTROLLER_TAG];
    [self.favNavController.tabBarItem setValue:@"Favorite" forKey:@"internalTitle"];
    
    SettingViewController *settingViewController = [storyboard instantiateViewControllerWithIdentifier:[SettingViewController className]];
    self.settingNavController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    self.settingNavController.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:SETTING_NAV_CONTROLLER_TAG];
    [self.settingNavController.tabBarItem setValue:@"Setting" forKey:@"internalTitle"];
    
    self.viewControllers = @[self.homeNavController,
                             self.favNavController,
                             self.settingNavController];
}



#pragma mark - View Controllers Access

- (HomeViewController *)homeViewController{
    return self.homeNavController.viewControllers.firstObject;
}

- (FavViewController *)favViewController{
    return self.favNavController.viewControllers.firstObject;
}

- (SettingViewController *)settingViewController{
    return self.settingNavController.viewControllers.firstObject;
}


@end
