//
//  HXMethodSwitch.h
//  ParentDemo
//
//  Created by 周义进 on 2019/5/10.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXMethodSwitch : NSObject
+ (void)exchangeClassMethodForClass:(Class)target
             sourceMethod:(SEL)sourceMethod
        destinationMethod:(SEL)destinationMethod;

+ (void)exchangeInstanceMethodForClass:(Class)target
                       sourceMethod:(SEL)sourceMethod
                  destinationMethod:(SEL)destinationMethod;

@end

NS_ASSUME_NONNULL_END
