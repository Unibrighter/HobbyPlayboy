//
//  BrowserViewController.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "BrowserViewController.h"
#import <UIImageView+WebCache.h>

@interface BrowserViewController () <UIScrollViewDelegate>

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.footerView.backgroundColor = [UIColor clearColor];
    self.currentPageIndexView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:BACKGROUND_COLOR_ALPHA];
    self.headerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:BACKGROUND_COLOR_ALPHA];

    self.pagePickerViewHidden = YES;
    [self setHeaderViewAndFooterViewHidden:YES animated:NO completion:nil];
    [self.stackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stackViewTapped:)]];
    
    self.currentPageIndex = 0;
    self.pageCount = 0;
    self.pageLabel.text = @"0/0";
    [self.pageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageLabelTapped:)]];
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)loadImagesIntoStackViewFromURLStrings:(NSArray *)URLStrings{
    [self.activityIndicatorView startAnimating];
    dispatch_async(dispatch_get_main_queue(), ^{
        for (NSString *URLStr in URLStrings) {
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView sd_setImageWithURL:[NSURL URLWithString:URLStr] placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                imageView.translatesAutoresizingMaskIntoConstraints = NO;
                
                CGFloat imageRatio = image.size.width/image.size.height;
                NSLayoutConstraint *ratioConstraint = [NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:imageRatio constant:0];
                
                [imageView addConstraint:ratioConstraint];
            }];
            [self.stackView addArrangedSubview:imageView];
        }
        [self.activityIndicatorView stopAnimating];
        self.pageCount = URLStrings.count;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",self.currentPageIndex, self.pageCount];
    });
}

#pragma mark - IBAction

- (IBAction)backButtonTapped:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self setHeaderViewAndFooterViewHidden:YES animated:YES completion:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (IBAction)pagePickerCancelButtonTapped:(id)sender {
    self.pagePickerViewHidden = YES;
}

- (IBAction)pagePickerDoneButtonTapped:(id)sender {
    self.pagePickerViewHidden = YES;
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setHeaderViewAndFooterViewHidden:YES animated:YES completion:nil];
}

#pragma mark - Helper Functions
- (void)setPagePickerViewHidden:(BOOL)pagePickerViewHidden{
    //when not picking a page num, we need to set the background color of the pageLabel half transparent
    UIColor *currentPageIndexViewBackgroundColor = [UIColor grayColor];
    if (pagePickerViewHidden){
        currentPageIndexViewBackgroundColor = [currentPageIndexViewBackgroundColor colorWithAlphaComponent:BACKGROUND_COLOR_ALPHA];
    }
    self.currentPageIndexView.backgroundColor = currentPageIndexViewBackgroundColor;
    
    _pagePickerViewHidden = pagePickerViewHidden;
    self.pagePickerCancelButton.hidden = _pagePickerViewHidden;
    self.pagePickerDoneButton.hidden = _pagePickerViewHidden;
    self.pagePickerView.hidden = _pagePickerViewHidden;
    
    [self.pagePickerView setNeedsLayout];
    [self.footerView layoutIfNeeded];
}

- (void)setHeaderViewAndFooterViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completionBlock{
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

- (void)pageLabelTapped:(id)sender{
    self.pagePickerViewHidden = NO;
}

- (void)stackViewTapped:(id)sender{
    [self setHeaderViewAndFooterViewHidden:!self.headerViewAndFooterViewHidden animated:YES completion:nil];
}

@end
