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
    
    //check if need to persist the expansion status of some cells if needed
    if ([self.detailViewExpandedIndexes containsObject:indexPath]){
        cell.detailTextView.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Gallery *gallery = self.filteredGalleries[indexPath.row];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [tableView performSelectorViaResponderChain:@selector(selectGallery:) withObject:gallery];
#pragma clang diagnostic pop
}

- (RLMResults *)filteredGalleries{
    if (self.predicate){
        return [[Gallery allObjects] objectsWithPredicate:self.predicate];
    }else{
        return [Gallery allObjects];
    }
}

@end
