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

void *HXCustomNaviBarViewKey              = &HXCustomNaviBarViewKey;
void *HXStartCustomNaviBarFlagKey              = &HXStartCustomNaviBarFlagKey;

@implementation UIViewController (HXCustomNaviBarView)
@dynamic hx_customNaviBarView;
#pragma mark - Life Cycle

#pragma mark - System Method

#pragma mark - Public Method

#pragma mark - Override

#pragma mark - Private Method

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

- (BOOL)startCustomNaviBarFlag {
    NSNumber *flag = objc_getAssociatedObject(self, HXStartCustomNaviBarFlagKey);
    return [flag boolValue];
}

- (void)setStartCustomNaviBarFlag:(BOOL)startCustomNaviBarFlag {
    objc_setAssociatedObject(self, HXStartCustomNaviBarFlagKey, @(startCustomNaviBarFlag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (startCustomNaviBarFlag && !self.hx_customNaviBarView.superview) {
        [self.view addSubview:self.hx_customNaviBarView];
    }
}

#pragma mark - Dealloc
@end
