//
//  HomeTableViewDataSource.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class Gallery;

@interface HomeTableViewDataSource : NSObject <UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property NSMutableArray <Gallery *>* galleries;

- (void)registerNibForTableView:(UITableView *)tableView;
@end
