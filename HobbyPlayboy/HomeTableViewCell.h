//
//  HomeTableViewCell.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (strong, nonatomic) NSNumber *galleryId;

//caption
@property (weak, nonatomic) IBOutlet UIView *captionContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageCountLabel;
@property (assign, nonatomic) BOOL favorite;

@property (weak, nonatomic) IBOutlet UIButton *detailViewToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;

//details
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

//detail view height control
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeightConstraint;

@end
