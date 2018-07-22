//
//  HomeTableViewCell.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *galleryId;

@property (weak, nonatomic) IBOutlet UIView *captionContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageCountLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailViewToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

//details
@property (weak, nonatomic) IBOutlet UIView *detailContainerView;
@property (weak, nonatomic) IBOutlet UILabel *airTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;

@property (weak, nonatomic) IBOutlet UILabel *airTimeContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageContentLabel;

//detail view height control
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewBottomPaddingHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeightConstraint;

@end
