//
//  UIViewController+HXCustomNaviBarView.m
//  ParentDemo
//
//  Created by James on 2019/6/6.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "UIViewController+HXCustomNaviBarView.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import <HXKitComponent/HXMethodSwitch.h>

void *HXCustomNaviBarViewKey              = &HXCustomNaviBarViewKey;
void *HXStartCustomNaviBarFlagKey              = &HXStartCustomNaviBarFlagKey;
void *HXForbiddenCustomNaviBarAutoToTopFlagKey              = &HXForbiddenCustomNaviBarAutoToTopFlagKey;
void *HXUIScrollViewContentInsetAdjustmentAutomaticFlagKey              = &HXUIScrollViewContentInsetAdjustmentAutomaticFlagKey;

@implementation UIViewController (HXCustomNaviBarView)
@dynamic hx_customNaviBarView;

#pragma mark - Life Cycle
+ (void)load {
    [HXMethodSwitch exchangeInstanceMethodForClass:self sourceMethod:@selector(viewDidLayoutSubviews) destinationMethod:@selector(hx_viewDidLayoutSubviews)];
}

#pragma mark - System Method

#pragma mark - Public Method

#pragma mark - Override

#pragma mark - Private Method
- (void)hx_viewDidLayoutSubviews {
    [self hx_viewDidLayoutSubviews];
    if (self.hx_startCustomNaviBarFlag) {
        if (!self.hx_forbiddenCustomNaviBarAutoToTopFlag && ![self.view.subviews.lastObject isEqual:self.hx_customNaviBarView]) {
            [self.view bringSubviewToFront:self.hx_customNaviBarView];
        }
        if (self.hx_UIScrollViewContentInsetAdjustmentAutomaticFlag && !self.hx_customNaviBarView.autoAssociatedVCScrollView) {
            
            UIScrollView *targetView = nil;
            
            for (UIView *item in [[self.view.subviews reverseObjectEnumerator] allObjects]) {
                if ([item isKindOfClass:[UIScrollView class]]) {
                    targetView = (UIScrollView *)item;
                    break;
                }
            }
            
            if (@available(iOS 11.0, *)) {
                targetView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            
            if (targetView.frame.origin.x == 0 && targetView.frame.origin.y == 0) {
                [self.hx_customNaviBarView bindingAutoAssociatedVCScrollView:targetView];
            }
        }
        
        
    }
}

#pragma mark - Delegate

#pragma mark - Setter And Getter

- (HXCustomNaviBarView *)hx_customNaviBarView {
    
    HXCustomNaviBarView *naviBarView = objc_getAssociatedObject(self, HXCustomNaviBarViewKey);
    
    if (!naviBarView) {
        naviBarView = [HXCustomNaviBarView new];
        
        objc_setAssociatedObject(self, HXCustomNaviBarViewKey, naviBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return naviBarView;
}

- (BOOL)hx_startCustomNaviBarFlag {
    NSNumber *flag = objc_getAssociatedObject(self, HXStartCustomNaviBarFlagKey);
    if (flag) {
        return [flag boolValue];
    }
    return NO;
}

- (BOOL)hx_forbiddenCustomNaviBarAutoToTopFlag {
    NSNumber *flag = objc_getAssociatedObject(self, HXForbiddenCustomNaviBarAutoToTopFlagKey);
    if (flag) {
        return [flag boolValue];
    }
    return NO;
}

- (BOOL)hx_UIScrollViewContentInsetAdjustmentAutomaticFlag {
    NSNumber *flag = objc_getAssociatedObject(self, HXUIScrollViewContentInsetAdjustmentAutomaticFlagKey);
    if (flag) {
        return [flag boolValue];
    }
    return YES;
}

- (void)setHx_startCustomNaviBarFlag:(BOOL)hx_startCustomNaviBarFlag {
    objc_setAssociatedObject(self, HXStartCustomNaviBarFlagKey, @(hx_startCustomNaviBarFlag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (hx_startCustomNaviBarFlag && !self.hx_customNaviBarView.superview) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.view addSubview:self.hx_customNaviBarView];
    }
}

- (void)setHx_forbiddenCustomNaviBarAutoToTopFlag:(BOOL)hx_forbiddenCustomNaviBarAutoToTopFlag {
    objc_setAssociatedObject(self, HXForbiddenCustomNaviBarAutoToTopFlagKey, @(hx_forbiddenCustomNaviBarAutoToTopFlag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setHx_UIScrollViewContentInsetAdjustmentAutomaticFlag:(BOOL)hx_UIScrollViewContentInsetAdjustmentAutomaticFlag {
    objc_setAssociatedObject(self, HXUIScrollViewContentInsetAdjustmentAutomaticFlagKey, @(hx_UIScrollViewContentInsetAdjustmentAutomaticFlag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Dealloc
@end
