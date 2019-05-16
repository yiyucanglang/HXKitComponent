//
//  HXSafeTimer.m
//  ParentDemo
//
//  Created by James on 2019/5/15.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXSafeTimer.h"
#import <objc/runtime.h>

@interface NSTimer (HXSafeTimer)
@property (nonatomic, strong) HXSafeTimer *hxSafeTimer;
@end

@implementation NSTimer (HXSafeTimer)

- (void)setHxSafeTimer:(HXSafeTimer *)hxSafeTimer {
    objc_setAssociatedObject(self, @selector(hxSafeTimer), hxSafeTimer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HXSafeTimer *)hxSafeTimer {
    return objc_getAssociatedObject(self, @selector(hxSafeTimer));
}

@end


@interface HXSafeTimer()
@property (nonatomic, weak)     id        aTarget;
@property (nonatomic, weak)     NSTimer  *aTimer;
@property (nonatomic)           SEL       aSelector;
@property (nonatomic, copy)     NSString *targerClassName;
@end


@implementation HXSafeTimer
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
    
    HXSafeTimer *interceptor = [HXSafeTimer new];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:interceptor selector:@selector(timerTriggered:) userInfo:userInfo repeats:yesOrNo];
    timer.hxSafeTimer = interceptor;
    interceptor.targerClassName = NSStringFromClass([aTarget class]);
    interceptor.aTimer = timer;
    interceptor.aTarget = aTarget;
    interceptor.aSelector = aSelector;
    
    return timer;
}

- (void)timerTriggered:(id)timer {
    id strongTarget = self.aTarget;
    if (strongTarget && ([strongTarget respondsToSelector:self.aSelector])) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [strongTarget performSelector:self.aSelector withObject:[timer userInfo]];
#pragma clang diagnostic pop
    } else {
        NSTimer *sourceTimer = self.aTimer;
        if (sourceTimer) {
            [sourceTimer invalidate];
        }
    }
}
@end
