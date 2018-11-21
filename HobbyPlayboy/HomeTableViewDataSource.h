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
@class RLMRealm;
@class RLMResults;

@interface HomeTableViewDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableSet *detailViewExpandedIndexes;

@property (strong, nonatomic) NSPredicate *predicate;

- (void)registerNibForTableView:(UITableView *)tableView;
@end
