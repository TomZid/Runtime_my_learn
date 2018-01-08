//
//  Utility.m
//  Runtime_my_learn
//
//  Created by tom on 08/01/2018.
//  Copyright © 2018 NWD. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>

@implementation Utility
+ (void)load {
    [super load];

    // setTitle:forState:
    SEL originalSel = NSSelectorFromString(@"setTitle:forState:");
    SEL swizzleSel = [[self class] swizzledSelectorForSelector:originalSel];

    void(^setTitleHandleBlock)(UIButton*,NSString*,int) = ^(UIButton *button ,NSString* title, int state) {
        [button performSelector:swizzleSel withObject:title afterDelay:0];
        NSLog(@"%s title is \"%@\" state is \"%d\"", __PRETTY_FUNCTION__, title, state);
    };

    [[self class] replaceImplementationOfKnownSelector:originalSel onClass:UIButton.class withBlock:setTitleHandleBlock swizzeleSelector:swizzleSel];

    // titleForState:
    originalSel = NSSelectorFromString(@"titleForState:");
    swizzleSel = [[self class] swizzledSelectorForSelector:originalSel];

    NSString* (^titleForStateHandleBlock)(UIButton*) = ^(UIButton *button) {
        return @"this is my text";
    };

    [[self class] replaceImplementationOfKnownSelector:originalSel onClass:UIButton.class withBlock:titleForStateHandleBlock swizzeleSelector:swizzleSel];
}


/**
 生成一个新的SEL，并确保新name是唯一的，以保证能成功调用class_addMethod。

 @param selector 将要替换的SEL。
 @return 生成的唯一的SEL。
 */
+ (SEL)swizzledSelectorForSelector:(SEL)selector {
    return NSSelectorFromString([NSString stringWithFormat:@"_demo_swizzle_%x_%@", arc4random(), NSStringFromSelector(selector)]);
}


/**
 将block添加到Cls的实例中， 对应新的SEL。orignSEL将被替换为swizzleSel。

 @param originSel
 @param cls
 @param block
 @param swizzeleSel
 */
+ (void)replaceImplementationOfKnownSelector:(SEL)originSel onClass:(Class)cls withBlock:(id)block swizzeleSelector:(SEL)swizzeleSel {
    Method originalMethod = class_getInstanceMethod(cls, originSel);
    if (!originalMethod) {
        return;
    }

    IMP implemetation = imp_implementationWithBlock(block);
    class_addMethod(cls, swizzeleSel, implemetation, method_getTypeEncoding(originalMethod));

    Method swizzleMethod = class_getInstanceMethod(cls, swizzeleSel);
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

@end
