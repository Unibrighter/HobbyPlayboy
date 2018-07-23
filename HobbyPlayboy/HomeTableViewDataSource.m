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
#import "BrowserViewController.h"
#import "Gallery.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIResponder+ResponderChain.h"

@implementation HomeTableViewDataSource

- (instancetype)init{
    self = [super init];
    if (self){
        self.galleries = [[NSMutableArray alloc] init];
        self.detailViewExpandedIndexes = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)registerNibForTableView:(UITableView *)tableView{
    [tableView registerNib:[UINib nibWithNibName:[HomeTableViewCell className] bundle:nil] forCellReuseIdentifier:[HomeTableViewCell className]];
}

#pragma mark - Table View Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.galleries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeTableViewCell className]];
    
    Gallery *gallery = self.galleries[indexPath.row];
    cell.titleLabel.text = gallery.title;
    cell.pageCountLabel.text = [NSString stringWithFormat:@"%@p", [gallery.pageCount stringValue]];
    [cell.thumbnailImageView sd_setImageWithURL:[NSURL URLWithString:gallery.thumbnailURLStr]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    //once the content the detail view(e.g. labels) are set, the constraint needs update
    [cell updateDetailViewHeightConstraint];
    
    //check if need to persist the expansion status of some cells if needed
    if ([self.detailViewExpandedIndexes containsObject:indexPath]){
        cell.detailContainerView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Gallery *gallery = self.galleries[indexPath.row];
    [tableView performSelectorViaResponderChain:@selector(selectGallery:) withObject:gallery];
}


@end
