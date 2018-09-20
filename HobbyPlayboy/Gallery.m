//
//  Gallery.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "Gallery.h"
#import <Realm/Realm.h>

@implementation Gallery

#pragma mark - Realm
+ (NSString *)primaryKey{
    return @"galleryId";
}

+ (NSArray<NSString *> *)requiredProperties{
    return @[@"galleryId", @"referenceURLStr", @"rawTitle"];
}

#pragma mark - Helper Functions
- (void)addOrUpdateGalleryWithBlock:(void (^)(Gallery *weakSelf))block{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    __weak typeof (self) weakSelf  = self;
    if (block) {
        block(weakSelf);
    }
    
    [realm addOrUpdateObject:self];
    [realm commitWriteTransaction];
}

- (void)setRawTitle:(NSString *)rawTitle{
    _rawTitle = rawTitle;
    if (_rawTitle && _rawTitle.length != 0){
        //refer the name and page count from the rawTitle if possible
        NSAssert((self.rawTitle && self.rawTitle.length != 0), @"Can't generate properties from invalid rawTitle.");
        
        NSString *matchingPattern = @"(\\[)(\\d+)(p])(.*)";
        
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:matchingPattern options:0 error:nil];
        NSTextCheckingResult *match = [regularExpression firstMatchInString:self.rawTitle options:0 range:NSMakeRange(0, self.rawTitle.length)];
        if (match != nil) {
            NSString *pageCountStr = [self.rawTitle substringWithRange:[match rangeAtIndex:2]];
            NSInteger pageCount = [pageCountStr integerValue];
            self.pageCount = pageCount;
            
            NSString *titleStr = [self.rawTitle substringWithRange:[match rangeAtIndex:4]];
            self.title = titleStr;
        }
    }
}

- (void)setReferenceURLStr:(NSString *)referenceURLStr{
    _referenceURLStr = referenceURLStr;
    if (_referenceURLStr && _referenceURLStr.length != 0){
        //refer the galleryId, thumbnailURL and page array if possible
        NSInteger IdIndexStart = [self.referenceURLStr rangeOfString:@"_"].location+1;
        NSInteger IdIndexEnd = [self.referenceURLStr rangeOfString:@".html"].location-1;
        NSInteger galleryId = [[self.referenceURLStr substringWithRange:NSMakeRange(IdIndexStart, IdIndexEnd-IdIndexStart+1)] integerValue];
        self.galleryId = galleryId;
        
        NSInteger galleryIdAdjusted = 10000+galleryId;
        NSString *thumbnailURLStr = [NSString stringWithFormat:@"http://fchost1.imgscloud.com/s/hcshort/hc%ld.jpg", galleryIdAdjusted];
        self.thumbnailURLStr = thumbnailURLStr;
        
        self.pages = [self getPagesWithGalleryId:self.galleryId pageCount:self.pageCount];
    }
}

- (NSArray<RLMString> *)getPagesWithGalleryId:(NSInteger)galleryId pageCount:(NSInteger)pageCount{
    
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:galleryId];
    
    NSInteger galleryIdAdjusted = 10000+galleryId;
    NSString *imageURL;
    for (int i = 1; i <= pageCount; i++) {
        NSString *pageOffset = [NSString stringWithFormat:@"%03d", i];
        imageURL = [NSString stringWithFormat:@"http://hahost2.imgscloud.com/fileshort/%ld/%ld_%@.jpg", galleryIdAdjusted, galleryIdAdjusted, pageOffset];
        [pages addObject:imageURL];
    }
    return [pages copy];
}


@end
