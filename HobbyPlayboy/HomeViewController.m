//
//  HomeViewController.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "HomeViewController.h"
#import "HtmlContentParser.h"
#import "HomeTableViewDataSource.h"
#import "BrowserViewController.h"
#import "Gallery.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[HomeTableViewDataSource alloc] init];
    [self.dataSource registerNibForTableView:self.tableView];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    
    if (0 == self.dataSource.galleries.count){
        [self loadGalleriesFromPageNum:0];
    }
    
}

#pragma mark - Synchronization

- (void)loadGalleriesFromPageNum:(NSInteger)pageNum{
    //TODO: start loading animation
    [[HtmlContentParser sharedInstance] getGalleriesCount:0 pageNumOffset:pageNum completion:^(NSArray<Gallery *> *galleries, NSError * error) {
        if (!error){
            [self.dataSource.galleries addObjectsFromArray:galleries];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - ResponderChain

- (void)selectGallery:(id)object{
    BrowserViewController *browserViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:[BrowserViewController className]];
    browserViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    browserViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).mainTabBarController presentViewController:browserViewController animated:YES completion:nil];
    
    Gallery *gallery = (Gallery *)object;
    browserViewController.titleLabel.text = gallery.title;
    [browserViewController loadImagesIntoStackViewFromURLStrings:gallery.pages];
}

#pragma mark - Helper Functions





@end
