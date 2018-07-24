//
//  BrowserViewController.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BrowserCollectionViewDataSource;
@class Gallery;

@interface BrowserViewController : UIViewController

@property (assign, nonatomic) NSInteger currentPageIndex;
@property (assign, nonatomic) BOOL headerViewAndFooterViewHidden;

@property (strong, nonatomic) Gallery *gallery;
@property (strong, nonatomic) BrowserCollectionViewDataSource *dataSource;

//content
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//title
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *autoScrollSwitch;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

//page select
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIView *currentPageIndexView;
@property (weak, nonatomic) IBOutlet UIView *currentPageIndexBackgroundOverlayView;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (weak, nonatomic) IBOutlet UIButton *pagePickerCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *pagePickerDoneButton;
@property (assign, nonatomic) BOOL pagePickerViewHidden;
@property (weak, nonatomic) IBOutlet UIPickerView *pagePickerView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
@end
