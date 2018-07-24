//
//  BrowserViewController.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "BrowserViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCache.h>
#import "BrowserCollectionViewDataSource.h"
#import "Gallery.h"

@interface BrowserViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSTimer *autoScrollTimer;
@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //data source and collection view
    self.dataSource = [[BrowserCollectionViewDataSource alloc] init];
    self.dataSource.gallery = self.gallery;
    self.collectionView.delegate = self.dataSource;
    self.collectionView.dataSource = self.dataSource;
    [self.dataSource registerNibForCollectionView:self.collectionView];
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;
    
    //title label
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.text = self.gallery.rawTitle;
    
    //TODO: use NSUserPreference to store the time interval option
    self.autoScrollSwitch.on = self.autoScrollTimer.valid;
    self.headerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:BACKGROUND_COLOR_ALPHA];

    //footer view
    self.footerView.backgroundColor = [UIColor clearColor];
    self.currentPageIndexBackgroundOverlayView.backgroundColor = [UIColor grayColor];
    self.currentPageIndexBackgroundOverlayView.alpha = BACKGROUND_COLOR_ALPHA;
    [self setPagePickerViewHidden:YES animated:NO completion:nil];
    
    //page index
    [self setHeaderViewAndFooterViewHidden:YES animated:NO completion:nil];
    self.currentPageIndex = 0;
    
    self.pageLabel.userInteractionEnabled = YES;
    self.pagePickerView.delegate = self;
    
    //TODO: change this into the saved offset from last time
    [self.pagePickerView selectRow:self.currentPageIndex inComponent:0 animated:YES];
    
    //gestures
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewTapped:)]];
    [self.pageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageLabelTapped:)]];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - IBAction

- (IBAction)autoScrollSwitchValueChanged:(id)sender {
    if (self.autoScrollSwitch.on){
        [self setupAutoScrollTimer];
    }else{
        [self.autoScrollTimer invalidate];
    }
}

- (IBAction)backButtonTapped:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self setHeaderViewAndFooterViewHidden:YES animated:YES completion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)pagePickerCancelButtonTapped:(id)sender {
    [self setPagePickerViewHidden:YES animated:YES completion:nil];
}

- (IBAction)pagePickerDoneButtonTapped:(id)sender {
    NSInteger selectedIndex = [self.pagePickerView selectedRowInComponent:0];
    if (-1 != selectedIndex){
        self.currentPageIndex = selectedIndex;
        NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:self.currentPageIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    }
    [self setPagePickerViewHidden:YES animated:YES completion:nil];
}

#pragma mark - Responder Chain
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setHeaderViewAndFooterViewHidden:YES animated:YES completion:nil];
    
    if (!self.collectionView.indexPathsForVisibleItems || 0 == self.collectionView.indexPathsForVisibleItems.count){
        return;
    }
    
    //update the index
    NSIndexPath *lastVisibleCellIndex = [self.collectionView.indexPathsForVisibleItems lastObject];
    NSInteger offset = MAX((NSInteger)[self.collectionView.indexPathsForVisibleItems indexOfObject:lastVisibleCellIndex]-1,0);
    NSIndexPath *secondlastVisibleCellIndex = self.collectionView.indexPathsForVisibleItems[offset];
    if (0 == secondlastVisibleCellIndex.row && 0 == self.collectionView.contentOffset.y){
        self.currentPageIndex = 0;
    }else{
        self.currentPageIndex = lastVisibleCellIndex.row;
    }
    
}

#pragma mark - Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.imageURLStrings.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [@(row+1) stringValue];
}

#pragma mark - Helper Functions

- (void)setupAutoScrollTimer{
    if (!self.autoScrollTimer || !self.autoScrollTimer.valid){
        //TODO: use NSUserPreference to store the time interval option
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    }
}

- (void)scrollToNextPage{
    self.currentPageIndex++;
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:self.currentPageIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex{
    if (currentPageIndex < 0 || currentPageIndex >= self.gallery.pageCount){
        NSLog(@"Invalid value for currentPageIndex.");
        if (self.autoScrollTimer.valid){
            [self autoScrollSwitchValueChanged:nil];
        }
        return;
    }else{
        _currentPageIndex = currentPageIndex;
        
        //update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.currentPageIndex+1, self.gallery.pageCount];
        });
    }
}

- (void)setPagePickerViewHidden:(BOOL)pagePickerViewHidden animated:(BOOL)animated completion:(void (^)(void))completionBlock{
    void (^ viewUpdateBlock)(void) = ^ (void){
        //when not picking a page num, we need to set the background color of the pageLabel half transparent
        self.currentPageIndexBackgroundOverlayView.alpha = pagePickerViewHidden?BACKGROUND_COLOR_ALPHA:1.0;
        [self.currentPageIndexView bringSubviewToFront:self.pagePickerCancelButton];
        [self.currentPageIndexView bringSubviewToFront:self.pagePickerDoneButton];
        CGFloat alpha = pagePickerViewHidden?0.0:1.0;
        
        self.pagePickerCancelButton.alpha = alpha;
        self.pagePickerDoneButton.alpha = alpha;
        self.pagePickerView.alpha = alpha;
        
        self.pagePickerView.hidden = pagePickerViewHidden;
        if (!self.pagePickerView.hidden){
            [self.pagePickerView selectRow:self.currentPageIndex inComponent:0 animated:NO];
        }
        [self.footerView setNeedsLayout];
        [self.footerView layoutIfNeeded];
    };
    
    if (animated){
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            viewUpdateBlock();
        } completion:^(BOOL finished) {
            if (completionBlock){
                self.pagePickerViewHidden = pagePickerViewHidden;
                completionBlock();
            }
        }];
    }else{
        viewUpdateBlock();
        if (completionBlock){
            self.pagePickerViewHidden = pagePickerViewHidden;
            completionBlock();
        }
    }
}

- (void)setHeaderViewAndFooterViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completionBlock{
    if (!(self.headerViewAndFooterViewHidden ^ hidden)){
        //TODO: if not setting this, it seems that the animation will carried out anyway. Causing UI inconsistance issues
        //already the same, no action needed
        return;
    }
    self.headerViewAndFooterViewHidden = hidden;
    void (^ viewUpdateBlock) (void) = ^ (void){
        if (hidden){
            self.headerView.transform = CGAffineTransformMakeTranslation(0, -CGRectGetHeight(self.headerView.frame));
            self.footerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.footerView.frame));
            
            //make it completely invisible to avoid showing during animation
            self.headerView.alpha = 0.0;
            self.footerView.alpha = 0.0;
        }else{
            self.headerView.transform = CGAffineTransformIdentity;
            self.footerView.transform = CGAffineTransformIdentity;
            
            self.headerView.alpha = 1.0;
            self.footerView.alpha = 1.0;
        }
    };
    
    if (animated){
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            viewUpdateBlock();
        } completion:^(BOOL finished) {
            if (completionBlock){
                completionBlock();
            }
        }];
    }else{
        viewUpdateBlock();
        if (completionBlock){
            completionBlock();
        }
    }
}

#pragma mark - EventHandler

- (void)pageLabelTapped:(id)sender{
    [self setPagePickerViewHidden:NO animated:YES completion:nil];
}

- (void)collectionViewTapped:(id)sender{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf setPagePickerViewHidden:YES animated:YES completion:^{
        [self setHeaderViewAndFooterViewHidden:!self.headerViewAndFooterViewHidden animated:YES completion:nil];
    }];
}



@end
