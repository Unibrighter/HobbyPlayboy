//
//  HomeTableViewCell.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIResponder+ResponderChain.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tagsContentLabel.textAlignment = NSTextAlignmentLeft;
    self.airTimeContentLabel.textAlignment = NSTextAlignmentLeft;
    self.languageContentLabel.textAlignment = NSTextAlignmentLeft;
    self.categoryContentLabel.textAlignment = NSTextAlignmentLeft;
    
    self.tagsContentLabel.numberOfLines = 0;
    self.airTimeContentLabel.numberOfLines = 0;
    self.languageContentLabel.numberOfLines = 0;
    self.categoryContentLabel.numberOfLines = 0;
}

- (IBAction)toggleDetailViewButtonTapped:(id)sender {
    UITableView *tableView = self.tableView;
    [tableView beginUpdates];
    self.detailViewHidden = !self.detailViewHidden;
    [tableView endUpdates];
}

- (IBAction)downloadButtonTapped:(id)sender {
    [self performSelectorViaResponderChain:@selector(downloadGalleryWithCell:) withObject:self];
}

- (void)setDetailViewHidden:(BOOL)detailViewHidden{
    if (!(_detailViewHidden ^ detailViewHidden)){
        return;
    }

    CGFloat detailViewHeight = 0.0;
    
    if (!detailViewHidden){
        //calculate the constraint dynamically
        [self.tagsContentLabel sizeToFit];
        [self.airTimeContentLabel sizeToFit];
        [self.languageContentLabel sizeToFit];
        [self.categoryContentLabel sizeToFit];
        
        detailViewHeight =
        self.bottomPaddingViewHeightConstraint.constant+
        CGRectGetHeight(self.tagsContentLabel.frame)+CGRectGetHeight(self.airTimeContentLabel.frame)+
        CGRectGetHeight(self.languageContentLabel.frame)+CGRectGetHeight(self.categoryContentLabel.frame);
    }
    
    self.detailViewHeightConstraint.constant = detailViewHeight;
    self.detailContainerView.alpha = detailViewHidden?0.0:1.0;
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    _detailViewHidden = detailViewHidden;
}

- (UITableView *)tableView{
    //see https://stackoverflow.com/questions/15711645/how-to-get-uitableview-from-uitableviewcell
    id view = [self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    return view;
}

@end
