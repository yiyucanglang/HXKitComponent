//
//  HXCustomNaviBarView.h
//  ParentDemo
//
//  Created by James on 2019/6/5.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString const * _Nonnull HXNaviTitle  = @"TITLE";
static NSString const * _Nonnull HXNaviImage  = @"IMAGE";
static NSString const * _Nonnull HXNaviFont   = @"FONT";
static NSString const * _Nonnull HXNaviColor  = @"COLOR";
static NSString const * _Nonnull HXNaviItemImgTextDistance  = @"ImgTextDistance";

NS_ASSUME_NONNULL_BEGIN

@interface HXCustomNaviBarView : UIView

@property (nonatomic, copy)     NSString  *title;

/**
 @{HXNaviTitle : xxxx,
 HXNaviImage : xxxx,
 HXNaviFont  : xxxx,
 HXNaviColor : xxxx,
 HXNaviItemImgTextDistance: @(5)
 }
 */
@property (nonatomic, strong)   NSDictionary  *middleViewConfigDic;

/**
 as above
 */
@property (nonatomic, strong)   NSDictionary  *leftItemConfigDic;


/**
 as above if you set this, default rightItem will be created
 */
@property (nonatomic, strong)   NSDictionary  *rightItemConfigDic;

@property (nonatomic, assign)   BOOL   hiddenSeperatorLine;

//default uilabel
@property (nonatomic, strong)     UIView    *middleView;

//default: HXImgTextCombineView
@property (nonatomic, strong)     UIView    *leftItem;

//default nil (HXImgTextCombineView)
@property (nonatomic, strong)     UIView    *rightItem;


//noti: all this prepared for default provided
/**
 default 15
 */
@property (nonatomic, assign)   CGFloat   leftItemMargin;

/**
 default -15
 */
@property (nonatomic, assign)   CGFloat   rightItemMargin;

/**
 default 100
 */
@property (nonatomic, assign)   CGFloat   itemMaxLength;

//default NO
@property (nonatomic, assign) BOOL   translucent;


@property (nonatomic, weak, readonly) UIScrollView   *unionScrollView;

//only set for default items
//left default action :pop
- (void)addTargetForLeftItem:(nullable id)target
                     action:(SEL)action;

- (void)addTargetForRightItem:(nullable id)target
                      action:(SEL)action;


// you can invoke this method to custom
- (void)customLayout:(void(^)(UIView *containerView))layoutBlock;

//noti: circular retain
- (void)bindingUnionScrollView:(UIScrollView *)scrollView scrollHandler:(nullable void(^)(UIScrollView *scrollView))swipeHandler;

@end


@interface HXCustomNaviBarView (ViewControllerPrivate)

@property (nonatomic, weak, readonly) UIScrollView   *autoAssociatedVCScrollView;

//auto adjustment contentinset of scrollvie in viewcontroller
- (void)bindingAutoAssociatedVCScrollView:(nullable UIScrollView *)scrollView;
@end

NS_ASSUME_NONNULL_END
