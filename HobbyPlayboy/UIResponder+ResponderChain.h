//
//  UIResponder+ResponderChain.h
//  HobbyPlayboy
//
//  Created by Kunliang Wu on 18/7/18.
//  Copyright © 2018 Kunliang Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (ResponderChain)
- (BOOL)performSelectorViaResponderChain:(SEL)aSelector withObject:(id)anObject;
@end
