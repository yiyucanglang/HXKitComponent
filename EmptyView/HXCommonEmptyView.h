//
//  HXCommonEmptyView.h
//  JenkinsTest
//
//  Created by 周义进 on 2019/1/4.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXEmptyHead.h"
/*
 HXCommonEmptyView layout introduce:
       imageview
       des
       btn
*/

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HXCommonEmptyViewLayoutStyle) {
    HXCommonEmptyViewLayoutStyleCenter,
    HXCommonEmptyViewLayoutStyleTop,
};

@interface HXCommonEmptyView : UIView
<
    HXEmptyViewDelegate
>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *desLB;
@property (nonatomic, strong) UIButton *actionBtn;//default nil

@property (nonatomic, strong, readonly) UIView *containerView;

@property (nonatomic, assign) HXCommonEmptyViewLayoutStyle layoutStyle;

@property (nonatomic, assign) CGFloat topMargin;//default 85

@property (nonatomic, assign) CGSize imageSize;//default cgsizezero

@property (nonatomic, assign) CGFloat imageTextDistance;//default 15
@property (nonatomic, assign) CGFloat textBtnDistance;//default 15

@property (nonatomic, assign) CGFloat actionBtnWidth;
@property (nonatomic, assign) CGFloat actionBtnHeight;

//when change layout or reset subview(desLB、imageView、actionBtn) must call this method in the end
- (void)reloadData;

- (void)addGesture:(UIGestureRecognizer *)gesture toView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
