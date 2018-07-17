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

#pragma mark - Helper Functions





@end
