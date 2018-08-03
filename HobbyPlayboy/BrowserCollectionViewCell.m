//
//  BrowserCollectionViewCell.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 24/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "BrowserCollectionViewCell.h"


@implementation BrowserCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.imageViewWidthConstraint.constant = SCREEN_WIDTH;
//    self.imageViewHeightConstraint.constant = SCREEN_HEIGHT;
}

@end
