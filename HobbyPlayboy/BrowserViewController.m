//
//  BrowserViewController.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 17/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "BrowserViewController.h"
#import <UIImageView+WebCache.h>

@interface BrowserViewController ()

@end

@implementation BrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    });
}

@end
