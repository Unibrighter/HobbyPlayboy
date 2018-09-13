//
//  Gallery.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface Gallery : RLMObject

@property (assign, nonatomic) NSInteger galleryId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *referenceURLStr;
@property (strong, nonatomic) NSString *thumbnailURLStr;

@property (strong, nonatomic) RLMArray <RLMString> *pages;
@property (strong, nonatomic) NSString *rawTitle;
@property (assign, nonatomic) NSInteger pageCount;

@end
