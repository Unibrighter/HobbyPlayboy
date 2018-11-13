//
//  UIResponder+ResponderChain.m
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 18/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//  See -https://groups.google.com/forum/#!msg/cocoa-unbound/azBfIy3ga3U/6ge1QAtSptYJ
//

#import "UIResponder+ResponderChain.h"

@implementation UIResponder (ResponderChain)

//
// ONLY USE THIS METHOD IF THE SELECTOR RETURNS VOID
//

- (BOOL)performSelectorViaResponderChain:(SEL)aSelector withObject:(id)anObject{
    UIResponder *responder = self.nextResponder;
    while (responder != nil){
        if ([responder respondsToSelector:aSelector]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [responder performSelector:aSelector withObject:anObject];
#pragma clang diagnostic pop
            return YES;
        }
        responder = responder.nextResponder;
    }
    return NO;
}

@end
