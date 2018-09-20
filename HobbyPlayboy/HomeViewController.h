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

@interface HomeViewController : UIViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) HomeTableViewDataSource *dataSource;
@property (strong, nonatomic) UISearchController *searchViewController;

@property (strong, nonatomic) UISearchBar* searchBar;
@property (strong, nonatomic) UIView *searchOverlayView;

//responder chain method
- (void)selectGallery:(Gallery *)gallery;
- (void)downloadGalleryWithGalleryId:(NSString *)galleryId;

@end
