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

@interface BrowserViewController ()
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
    self.popoverIndicatorView.hidden = YES;
    self.popoverIndicatorView.alpha = 0.6;
    self.popoverIndicatorView.layer.cornerRadius = 4.0;
    
    self.slider.maximumValue = self.gallery.pageCount;
    self.slider.minimumValue = 1;
    self.slider.value = self.slider.minimumValue;
    
    //page index
    [self setHeaderViewAndFooterViewHidden:YES animated:NO completion:nil];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"sliderThumb"] forState:UIControlStateNormal];
    
    //gestures
    [self.collectionView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewTapped:)]];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - IBAction
- (IBAction)backButtonTapped:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self setHeaderViewAndFooterViewHidden:YES animated:YES completion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)autoScrollSwitchValueChanged:(id)sender {
    if (self.autoScrollSwitch.on){
        [self setupAutoScrollTimer];
    }else{
        [self.autoScrollTimer invalidate];
    }
}
    
- (IBAction)onSliderTouchedDown:(id)sender {
    self.popoverIndicatorView.hidden = NO;
}
    
- (IBAction)onSliderTouchUpInside:(id)sender {
    self.popoverIndicatorView.hidden = YES;
    
    UISlider *slider = (UISlider *)sender;
    NSInteger currentPageIndex = (NSInteger)slider.value-1;
    
    [self scrollToPageAtIndex:currentPageIndex withAnimation:NO];
}

- (IBAction)onSliderTouchUpOutside:(id)sender {
    [self onSliderTouchUpInside:sender];
}
    
    
#pragma mark - Responder Chain
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.collectionView.indexPathsForVisibleItems || 0 == self.collectionView.indexPathsForVisibleItems.count){
        return;
    }
    [self updateLabelTextAndSliderValue];
}

#pragma mark - Helper Functions
    
- (void)setupAutoScrollTimer{
    if (!self.autoScrollTimer || !self.autoScrollTimer.valid){
        //TODO: use NSUserPreference to store the time interval option
        self.autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    }
}

- (void)scrollToNextPage{
    [self scrollToPageAtIndex:self.currentPageIndex+1 withAnimation:YES];
}
    
- (void)updateLabelTextAndSliderValue{
    //update UI
    dispatch_async(dispatch_get_main_queue(), ^{
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.currentPageIndex+1, self.gallery.pageCount];
        self.slider.value = self.currentPageIndex+1;
    });
}
    
- (NSInteger)currentPageIndex{
    NSIndexPath *lastVisibleCellIndex = [self.collectionView.indexPathsForVisibleItems lastObject];
    NSInteger offset = MAX((NSInteger)[self.collectionView.indexPathsForVisibleItems indexOfObject:lastVisibleCellIndex]-1,0);
    NSIndexPath *secondlastVisibleCellIndex = self.collectionView.indexPathsForVisibleItems[offset];
    if (0 == secondlastVisibleCellIndex.row && 0 == self.collectionView.contentOffset.y){
        return 0;
    }else{
        return lastVisibleCellIndex.row;
    }
}
    
- (void)scrollToPageAtIndex:(NSInteger)index withAnimation:(BOOL)animated{
    NSIndexPath *targetIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:targetIndexPath atScrollPosition:UICollectionViewScrollPositionTop animated:animated];
}

- (void)setHeaderViewAndFooterViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completionBlock{
    if (self.headerViewAndFooterViewHidden == hidden){
        //if not setting this, it seems that the animation will carried out anyway. Causing UI inconsistance issues
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

- (void)collectionViewTapped:(id)sender{
    __weak typeof (self) weakSelf = self;
    
    [weakSelf setHeaderViewAndFooterViewHidden:!weakSelf.headerViewAndFooterViewHidden animated:YES completion:nil];
}

@end
