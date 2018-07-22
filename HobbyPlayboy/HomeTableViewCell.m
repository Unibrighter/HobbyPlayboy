//
//  HomeTableViewCell.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "UIResponder+ResponderChain.h"
#import "HomeTableViewDataSource.h"

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
    
    self.detailContainerView.hidden = YES;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.detailContainerView.hidden = YES;
}

#pragma mark - IBAction
- (IBAction)downloadButtonTapped:(id)sender {
    [self performSelectorViaResponderChain:@selector(downloadGalleryWithGalleryId:) withObject:self.galleryId];
}

- (IBAction)toggleDetailViewButtonTapped:(id)sender {
    UITableView *tableView = self.tableView;
    
    self.detailViewHeightConstraint.constant = [self getDetailViewHeight];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    
    [tableView performBatchUpdates:^{
        self.detailContainerView.hidden = !self.detailContainerView.hidden;
    } completion:^(BOOL finished) {
    }];
    
    [self.detailViewToggleButton setTitle:self.detailContainerView.hidden?@"More":@"Collapse" forState:UIControlStateNormal];
    
    //inform the data source that this detail view has been expanded
    if (!self.detailContainerView.hidden){
        HomeTableViewDataSource *dataSource = (HomeTableViewDataSource *)tableView.dataSource;
        NSIndexPath *expandedIndex = [tableView indexPathForCell:self];
        [dataSource.detailViewExpandedIndexes addObject:expandedIndex];
    }
}

#pragma mark - Helper Functions
- (UITableView *)tableView{
    //see https://stackoverflow.com/questions/15711645/how-to-get-uitableview-from-uitableviewcell
    id view = [self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    return view;
}

- (CGFloat)getDetailViewHeight{
    //calculate the constraint dynamically
    [self.tagsContentLabel sizeToFit];
    [self.airTimeContentLabel sizeToFit];
    [self.languageContentLabel sizeToFit];
    [self.categoryContentLabel sizeToFit];

    CGFloat detailViewHeight =
    self.paddingViewHeightConstraint.constant+
    CGRectGetHeight(self.tagsContentLabel.frame)+
    CGRectGetHeight(self.airTimeContentLabel.frame)+
    CGRectGetHeight(self.languageContentLabel.frame)+
    CGRectGetHeight(self.categoryContentLabel.frame);
    
    return detailViewHeight;
}

@end
