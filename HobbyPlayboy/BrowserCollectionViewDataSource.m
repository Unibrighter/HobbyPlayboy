//
//  BrowserCollectionViewDataSource.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 24/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "BrowserCollectionViewDataSource.h"
#import <Realm/Realm.h>
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Gallery.h"
#import "BrowserCollectionViewCell.h"
#import "UIResponder+ResponderChain.h"

@implementation BrowserCollectionViewDataSource


#pragma mark - Collection View Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [scrollView performSelectorViaResponderChain:@selector(scrollViewDidScroll:) withObject:scrollView];
}

- (void)registerNibForCollectionView:(UICollectionView *)collectionView{
    [collectionView registerNib:[UINib nibWithNibName:[BrowserCollectionViewCell className] bundle:nil] forCellWithReuseIdentifier:[BrowserCollectionViewCell className]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageURLStrings.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *URLStr = self.imageURLStrings[indexPath.row];
    
    BrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[BrowserCollectionViewCell className] forIndexPath:indexPath];
    [cell.imageView sd_setShowActivityIndicatorView:YES];
    [cell.imageView sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:URLStr] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        CGFloat imageRatio = image.size.width/image.size.height;
        cell.imageViewWidthConstraint.constant = CGRectGetWidth(collectionView.frame);
        cell.imageViewHeightConstraint.constant = cell.imageViewWidthConstraint.constant/imageRatio;
    }];
    return cell;
}

#pragma mark - Helper Functions
- (void)setGallery:(Gallery *)gallery{
    _gallery = gallery;
    self.imageURLStrings = self.gallery.pages;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}

@end
