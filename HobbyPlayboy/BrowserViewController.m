//
//  BrowserViewController.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "BrowserViewController.h"
#import <UIImageView+WebCache.h>

@interface BrowserViewController () <UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:BACKGROUND_COLOR_ALPHA];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.footerView.backgroundColor = [UIColor clearColor];
    self.currentPageIndexBackgroundOverlayView.backgroundColor = [UIColor grayColor];
    self.currentPageIndexBackgroundOverlayView.alpha = BACKGROUND_COLOR_ALPHA;
    [self setPagePickerViewHidden:YES animated:NO completion:nil];
    
    self.scrollView.delegate = self;
    [self setHeaderViewAndFooterViewHidden:YES animated:NO completion:nil];
    self.currentPageIndex = 0;
    self.pageCount = 0;
    self.pageLabel.text = @"0/0";
    self.pageLabel.userInteractionEnabled = YES;
    self.pagePickerView.delegate = self;
    
    [self.stackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stackViewTapped:)]];
    [self.pageLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageLabelTapped:)]];
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)loadImagesIntoStackViewFromURLStrings:(NSArray *)URLStrings{
    self.imageURLStrings = URLStrings;
    
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
    [self setPagePickerViewHidden:YES animated:YES completion:nil];
}

- (IBAction)pagePickerDoneButtonTapped:(id)sender {
    [self setPagePickerViewHidden:YES animated:YES completion:nil];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setHeaderViewAndFooterViewHidden:YES animated:YES completion:nil];
}

#pragma mark - Picker View Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.imageURLStrings.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [@(row) stringValue];
}

#pragma mark - Helper Functions
- (void)setPagePickerViewHidden:(BOOL)pagePickerViewHidden animated:(BOOL)animated completion:(void (^)(void))completionBlock{
    self.pagePickerViewHidden = pagePickerViewHidden;
    
    void (^ viewUpdateBlock)(void) = ^ (void){
        //when not picking a page num, we need to set the background color of the pageLabel half transparent
        self.currentPageIndexBackgroundOverlayView.alpha = self.pagePickerViewHidden?BACKGROUND_COLOR_ALPHA:1.0;
        [self.currentPageIndexView bringSubviewToFront:self.pagePickerCancelButton];
        [self.currentPageIndexView bringSubviewToFront:self.pagePickerDoneButton];
        CGFloat alpha = self.pagePickerViewHidden?0.0:1.0;
        
        self.pagePickerCancelButton.alpha = alpha;
        self.pagePickerDoneButton.alpha = alpha;
        self.pagePickerView.alpha = alpha;
        
        self.pagePickerView.hidden = self.pagePickerViewHidden;
        [self.footerView setNeedsLayout];
        [self.footerView layoutIfNeeded];
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

- (void)stackViewTapped:(id)sender{
    __weak typeof (self) weakSelf = self;
    [weakSelf setPagePickerViewHidden:YES animated:YES completion:^{
        [self setHeaderViewAndFooterViewHidden:!self.headerViewAndFooterViewHidden animated:YES completion:nil];
    }];
}



@end
