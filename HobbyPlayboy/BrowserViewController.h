//
//  BrowserViewController.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController

@property (assign, nonatomic) NSInteger pageCount;
@property (assign, nonatomic) NSInteger currentPageIndex;
@property (assign, nonatomic) BOOL headerViewAndFooterViewHidden;
@property (strong, nonatomic) id<NSFastEnumeration> imageURLStrings;

//content
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

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

- (void)loadImagesIntoStackViewFromURLStrings:(id <NSFastEnumeration>)URLStrings;

@end
