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

#define CELL_MARGIN_OFFSET 16
#define THUMBNAIL_IMAGE_VIEW_WEIDTH 88

#define FAVORITE_ICON_STRING_FILLED @"★"
#define FAVORITE_ICON_STRING_UNFILLED @"☆"

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
    
    //initialize the favorite button looking
    self.favorite = NO;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.captionContainerView.autoresizingMask = UIViewAutoresizingNone;
    self.detailContainerView.hidden = YES;
}

- (void)updateDetailViewHeightConstraint{
    self.detailViewHeightConstraint.constant = [self getDetailViewHeight];
//    self.detailViewHeightConstraint.constant = 280;
}

#pragma mark - IBAction
- (IBAction)favoriteButtonTapped:(id)sender {
    self.favorite = !self.favorite;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelectorViaResponderChain:@selector(toggleFavoriteGalleryWithGalleryId:) withObject:self.galleryId];
#pragma clang diagnostic pop
}

- (IBAction)downloadButtonTapped:(id)sender {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelectorViaResponderChain:@selector(downloadGalleryWithGalleryId:) withObject:self.galleryId];
#pragma clang diagnostic pop
}

- (IBAction)toggleDetailViewButtonTapped:(id)sender {
    UITableView *tableView = self.tableView;
    
    [tableView performBatchUpdates:^{
        self.detailContainerView.hidden = !self.detailContainerView.hidden;
    } completion:^(BOOL finished) {
    }];
    
    [self.detailViewToggleButton setTitle:self.detailContainerView.hidden?@"More":@"Collapse" forState:UIControlStateNormal];
    
    //inform the data source that this detail view has been expanded
    //save it to the list for future reuse
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
    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH-CELL_MARGIN_OFFSET*2-THUMBNAIL_IMAGE_VIEW_WEIDTH,FLT_MAX);
    UIFont *font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    
    CGFloat detailViewHeight =self.detailViewBottomPaddingHeightConstraint.constant+
    CGRectGetHeight([self getDesirableFrameForText:self.tagsContentLabel.text font:font boundingBox:maximumLabelSize])+
    CGRectGetHeight([self getDesirableFrameForText:self.airTimeContentLabel.text font:font boundingBox:maximumLabelSize])+
    CGRectGetHeight([self getDesirableFrameForText:self.languageContentLabel.text font:font boundingBox:maximumLabelSize])+
    CGRectGetHeight([self getDesirableFrameForText:self.categoryContentLabel.text font:font boundingBox:maximumLabelSize]);
    
    return detailViewHeight;
}

- (CGRect)getDesirableFrameForText:(NSString *)text font:(UIFont *)font boundingBox:(CGSize)maximumSize{
    CGRect frame = [text boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return frame;
}

- (void)setFavorite:(BOOL)favorite{
    NSString *presentString;
    UIColor *color;
    if (favorite){
        presentString = FAVORITE_ICON_STRING_FILLED;
        color = UIColor.yellowColor;
    }else{
        presentString = FAVORITE_ICON_STRING_UNFILLED;
        color = UIColor.whiteColor;
    }
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:presentString attributes:@{NSStrokeColorAttributeName:color, NSForegroundColorAttributeName:color}];
    [self.favoriteButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}

- (BOOL)favorite{
    BOOL favorite = [self.favoriteButton.titleLabel.text isEqualToString:FAVORITE_ICON_STRING_FILLED];
    return favorite;
}

@end
