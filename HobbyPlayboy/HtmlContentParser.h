//
//  HtmlContentParser.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Gallery;

@interface HtmlContentParser : NSObject

+ (instancetype)sharedInstance;
- (void)getGalleriesCount:(NSInteger)count pageNumOffset:(NSInteger)pageNumoffset completion:(void(^) (NSArray<Gallery *>*, NSError *))completionBlock;

@end
