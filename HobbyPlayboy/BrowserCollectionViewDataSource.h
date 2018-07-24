//
//  BrowserCollectionViewDataSource.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 24/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@class Gallery;

@interface BrowserCollectionViewDataSource : NSObject <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property RLMArray *imageURLStrings;
@property (strong, nonatomic) Gallery *gallery;

- (void)registerNibForCollectionView:(UICollectionView *)collectionView;
@end
