//
//  Gallery.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "Gallery.h"

@implementation Gallery

-(void)setRawTitle:(NSString *)rawTitle{
    _rawTitle = rawTitle;
    if (_rawTitle && _rawTitle.length != 0){
        self.pageCount = @([Gallery getPageCountFromRawTitle:_rawTitle]);
        
        //TODO: auto generate thumbnail and content images array
    }
}

#pragma mark - Helper Fuctions
+ (NSInteger)getPageCountFromRawTitle:(NSString *)rawTitleStr{
    NSString *matchingPattern = @"(\\[)(\\d+)(p])(.*)";

    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:matchingPattern options:0 error:nil];
    NSTextCheckingResult *match = [regularExpression firstMatchInString:rawTitleStr options:0 range:NSMakeRange(0, rawTitleStr.length)];
    if (match != nil) {
        NSString *pageCountStr = [rawTitleStr substringWithRange:[match rangeAtIndex:2]];
        return [pageCountStr integerValue];
    }
    return -1;
}



@end
