//
//  HXMethodSwitch.m
//  ParentDemo
//
//  Created by 周义进 on 2019/5/10.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXMethodSwitch.h"
#import <objc/runtime.h>

@implementation HXMethodSwitch

+ (void)exchangeClassMethodForClass:(Class)target sourceMethod:(SEL)sourceMethod destinationMethod:(SEL)destinationMethod {
    
    Method originalMethod = class_getClassMethod(target, sourceMethod);
    
    Method swizzledMethod = class_getClassMethod(target, destinationMethod);
    
    BOOL didAddMethod =
    class_addMethod(target,
                    sourceMethod, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(target,
                            destinationMethod, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    
}

+ (void)exchangeInstanceMethodForClass:(Class)target sourceMethod:(SEL)sourceMethod destinationMethod:(SEL)destinationMethod {
    
    Method originalMethod = class_getInstanceMethod(target, sourceMethod);
    
    Method swizzledMethod = class_getInstanceMethod(target, destinationMethod);
    
    BOOL didAddMethod =
    class_addMethod(target,
                    sourceMethod, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(target,
                            destinationMethod, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}
@end
