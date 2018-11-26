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

#define FAVORITE_STRING_ADD_TO_FAV @"Add to Fav"
#define FAVORITE_STRING_REMOVE_FROM_FAV @"Remove from Fav"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.detailTextView.hidden = YES;
    
    //initialize the favorite button looking
    self.favorite = NO;
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.captionContainerView.autoresizingMask = UIViewAutoresizingNone;
    self.detailTextView.hidden = YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.detailViewHeightConstraint.constant = self.detailTextView.contentSize.height;
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
    [tableView beginUpdates];
    self.detailTextView.hidden = !self.detailTextView.hidden;
    [tableView endUpdates];
    
    [self.detailViewToggleButton setTitle:self.detailTextView.hidden?@"More":@"Collapse" forState:UIControlStateNormal];
    
    //inform the data source that this detail view has been expanded
    //save it to the list for future reuse
    if (!self.detailTextView.hidden){
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
//
//- (CGFloat)getDetailViewHeight{
//    //calculate the constraint dynamically
//    CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH-CELL_MARGIN_OFFSET*2-THUMBNAIL_IMAGE_VIEW_WEIDTH,FLT_MAX);
//    UIFont *font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
//
//    CGFloat detailViewHeight =self.detailViewBottomPaddingHeightConstraint.constant+
//    CGRectGetHeight([self getDesirableFrameForText:self.tagsContentLabel.text font:font boundingBox:maximumLabelSize])+
//    CGRectGetHeight([self getDesirableFrameForText:self.airTimeContentLabel.text font:font boundingBox:maximumLabelSize])+
//    CGRectGetHeight([self getDesirableFrameForText:self.languageContentLabel.text font:font boundingBox:maximumLabelSize])+
//    CGRectGetHeight([self getDesirableFrameForText:self.categoryContentLabel.text font:font boundingBox:maximumLabelSize]);
//
//    return detailViewHeight;
//}

- (CGRect)getDesirableFrameForText:(NSString *)text font:(UIFont *)font boundingBox:(CGSize)maximumSize{
    CGRect frame = [text boundingRectWithSize:maximumSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    return frame;
}

//- (void)setFavorite:(BOOL)favorite{
//    NSString *presentString;
//    UIColor *color;
//    if (favorite){
//        presentString = FAVORITE_ICON_STRING_FILLED;
//        color = UIColor.yellowColor;
//    }else{
//        presentString = FAVORITE_ICON_STRING_UNFILLED;
//        color = UIColor.whiteColor;
//    }
//    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:presentString attributes:@{NSStrokeColorAttributeName:color, NSForegroundColorAttributeName:color}];
//    [self.favoriteButton setAttributedTitle:attributedString forState:UIControlStateNormal];
//}

//- (BOOL)favorite{
//    BOOL favorite = [self.favoriteButton.titleLabel.text isEqualToString:FAVORITE_ICON_STRING_FILLED];
//    return favorite;
//}

@end
