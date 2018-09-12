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
    //TODO: use macro to controll the universal setting here
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
    [self updateLabelTextAndSliderValueIfNeeded];
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
    
- (void)updateLabelTextAndSliderValueIfNeeded{
    //only update slider value when auto-scroll is enabled
    //or the collection view is scrolling
    BOOL isScrolling = (self.collectionView.isDragging || self.collectionView.isDecelerating);
    if (self.autoScrollTimer.isValid || isScrolling ){
        self.slider.value = self.currentPageIndex+1;
    }else{
        //the user is dragging the slider, no need to update the value.
        NSLog(@"Slider Value: %f", self.slider.value);
    }
    
    //update UI
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld", (NSInteger)self.slider.value, self.gallery.pageCount];
}
    
- (NSInteger)currentPageIndex{
    //check if the collection view is at most top - first page
    if (0 == (NSInteger)self.collectionView.contentOffset.y){
        return 0;
    }
    
    //check if the collection view is at most bottom - last page
    if ((self.collectionView.contentOffset.y + CGRectGetHeight(self.collectionView.frame)) >= self.collectionView.contentSize.height){
        return MAX(self.dataSource.gallery.pages.count-1, 0);
    }
    
    //because of dequeuing for reuse,
    //self.collectionView.indexPathsForVisibleItems is
    //not always listed in order of row ascending.
    //so we need to sort it by ourselves.
    NSArray *indexPathsForVisibleItemsSorted = [self.collectionView.indexPathsForVisibleItems sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"row" ascending:YES]]];
    
    //normal situation: the second visible one
    NSIndexPath *firstVisibleCellIndex = indexPathsForVisibleItemsSorted.firstObject;
    
    if (1 == self.collectionView.indexPathsForVisibleItems.count){
        return firstVisibleCellIndex.row;
    }else{
        return firstVisibleCellIndex.row+1;
    }
}
    
- (void)scrollToPageAtIndex:(NSInteger)index withAnimation:(BOOL)animated{
    if (index >= self.dataSource.gallery.pages.count){
        //out of boundary
        [self.autoScrollTimer invalidate];
        self.autoScrollSwitch.on = NO;
        index = MAX(0,self.dataSource.gallery.pages.count-1);
    }
    
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
