//
//  Gallery.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Gallery : NSObject

@property (strong, nonatomic) NSNumber *galleryId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *referenceURLStr;
@property (strong, nonatomic) NSString *thumbnailURLStr;
@property (strong, nonatomic) NSArray *pages;
@property (strong, nonatomic) NSString *rawTitle;
@property (strong, nonatomic) NSNumber *pageCount;

@end
