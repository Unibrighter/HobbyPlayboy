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

@property NSInteger galleryId;
@property NSString *title;
@property NSString *referenceURLStr;
@property NSString *thumbnailURLStr;

//TODO: this needs to be expanded into two separate arraies
@property RLMArray <RLMString> *pages;
@property NSString *rawTitle;
@property NSInteger pageCount;

@end
