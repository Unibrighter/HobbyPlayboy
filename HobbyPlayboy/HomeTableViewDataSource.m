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
#import <SDWebImage/UIView+WebCache.h>
#import "UIResponder+ResponderChain.h"

@implementation HomeTableViewDataSource

- (instancetype)init{
    self = [super init];
    if (self){
        self.galleries = Gallery.allObjects;
        self.detailViewExpandedIndexes = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)registerNibForTableView:(UITableView *)tableView{
    [tableView registerNib:[UINib nibWithNibName:[HomeTableViewCell className] bundle:nil] forCellReuseIdentifier:[HomeTableViewCell className]];
}

#pragma mark - Collection View Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredGalleries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[HomeTableViewCell className]];

    Gallery *gallery = self.filteredGalleries[indexPath.row];
    cell.titleLabel.text = gallery.title;
    cell.galleryId = @(gallery.galleryId);
    cell.pageCountLabel.text = [NSString stringWithFormat:@"%@p", [@(gallery.pageCount) stringValue]];
    cell.favorite = gallery.favorite;
    
    [cell.thumbnailImageView sd_setShowActivityIndicatorView:YES];
    [cell.thumbnailImageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Gallery *gallery = self.filteredGalleries[indexPath.row];
    [tableView performSelectorViaResponderChain:@selector(selectGallery:) withObject:gallery];
}

- (NSArray<Gallery *> *)filteredGalleries{
    if (self.predicate){
        _filteredGalleries = [self.galleries objectsWithPredicate:self.predicate];
    }else{
        _filteredGalleries = self.galleries;
    }
    return _filteredGalleries;
}

@end
