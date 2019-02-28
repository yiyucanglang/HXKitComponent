//
//  UIViewController+HXEmpty.m
//  HXKitComponent
//
//  Created by 周义进 on 2019/2/28.
//

#import "UIViewController+HXEmpty.h"
#import <objc/runtime.h>
#import <Masonry/Masonry.h>

void *kHXHudView              = &kHXHudView;
void *kHXFailView             = &kHXFailView;
void *kHXEmptyView            = &kHXEmptyView;

@implementation UIViewController (HXEmpty)

#pragma mark - Life Cycle

#pragma mark - System Method

#pragma mark - Public Method

#pragma mark Hud
- (void)hx_showHudInView:(UIView *)targetView {
    [self addView:self.hxHudView targetView:targetView];
}

- (void)hx_showHud {
    [self addView:self.hxHudView targetView:self.view];
}

- (void)hx_HideHud {
    [self.hxHudView removeFromSuperview];
}


#pragma mark Fail
- (void)hx_showFailViewInTargetView:(UIView *)targetView image:(UIImage *)image des:(NSString *)des {
    [self addView:self.hxFailView targetView:targetView];
    [self.hxFailView updateImage:image des:des];
}

- (void)hx_showFailViewWithImage:(UIImage *)image des:(NSString *)des {
    [self hx_showFailViewInTargetView:self.view image:image des:des];
}

- (void)hx_showFailView {
    [self hx_showFailViewInTargetView:self.view image:nil des:nil];
}

- (void)hx_hideFailView {
    [self.hxFailView removeFromSuperview];
}


#pragma mark Empty
- (void)hx_showEmptyViewInTargetView:(UIView *)targetView image:(UIImage *)image des:(NSString *)des {
    [self addView:self.hxEmptyView targetView:targetView];
    [self.hxEmptyView updateImage:image des:des];
}

- (void)hx_showEmptyViewWithImage:(UIImage *)image des:(NSString *)des {
    [self hx_showEmptyViewInTargetView:self.view image:image des:des];
}

- (void)hx_showEmptyView {
    [self hx_showEmptyViewInTargetView:self.view image:nil des:nil];
}

- (void)hx_hideEmptyView {
    [self.hxEmptyView removeFromSuperview];
}

#pragma mark - Private Method
- (void)addView:(UIView *)sourceView targetView:(UIView *)targetView {
    [targetView addSubview:sourceView];
    [sourceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(targetView);
        make.size.equalTo(targetView);
    }];
    
}

#pragma mark - Delegate

#pragma mark - Setter And Getter

#pragma mark - Dealloc

@end

