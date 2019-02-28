//
//  UIViewController+HXEmpty.h
//  HXKitComponent
//
//  Created by 周义进 on 2019/2/28.
//

#import <UIKit/UIKit.h>
#import "HXEmptyHead.h"
#import "HXCommonEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HXEmpty)

//default nil you must set firstly
@property (nonatomic, strong) UIView<HXEmptyViewDelegate> *hxFailView;

//as above
@property (nonatomic, strong, readonly) UIView<HXEmptyViewDelegate> *hxEmptyView;

//as above
@property (nonatomic, strong) UIView *hxHudView;

- (void)hx_showHudInView:(UIView *)targetView;

- (void)hx_showHud;

- (void)hx_HideHud;

//targetView = self.view、image=nil、des=nil
- (void)hx_showEmptyView;

// targetView = self.view
- (void)hx_showEmptyViewWithImage:(UIImage *)image des:(NSString *)des;

- (void)hx_showEmptyViewInTargetView:(UIView *)targetView
                               image:(UIImage *)image
                                 des:(NSString *)des;

- (void)hx_hideEmptyView;


- (void)hx_showFailView;

- (void)hx_showFailViewWithImage:(UIImage *)image des:(NSString *)des;

- (void)hx_showFailViewInTargetView:(UIView *)targetView image:(UIImage *)image des:(NSString *)des;

- (void)hx_hideFailView;


- (void)hx_hideAllTipView;
@end

NS_ASSUME_NONNULL_END
