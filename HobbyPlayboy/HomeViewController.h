//
//  HomeViewController.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeTableViewDataSource;
@class Gallery;

@interface HomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) HomeTableViewDataSource *dataSource;

- (void)selectGallery:(Gallery *)gallery;
@end
