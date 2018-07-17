//
//  HomeTableViewDataSource.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "HomeTableViewDataSource.h"
#import <UIKit/UIKit.h>
#import "HomeTableViewCell.h"
#import "Gallery.h"

@implementation HomeTableViewDataSource

- (void)registerNibForTableView:(UITableView *)tableView{
    [tableView registerNib:[UINib nibWithNibName:[HomeTableViewCell className] bundle:nil] forCellReuseIdentifier:[HomeTableViewCell className]];
}




#pragma mark - Table View Delegate






@end
