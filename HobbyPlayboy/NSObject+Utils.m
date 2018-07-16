//
//  NSObject+Utils.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 16/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (Utils)

- (NSString *)className{
    return NSStringFromClass([self class]);
}

@end
