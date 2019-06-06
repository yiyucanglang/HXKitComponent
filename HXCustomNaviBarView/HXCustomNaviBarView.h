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

NS_ASSUME_NONNULL_BEGIN

@interface HXCustomNaviBarView : UIView

@property (nonatomic, copy)     NSString  *title;

/**
 @{HXNaviTitle : xxxx,
 HXNaviImage : xxxx,
 HXNaviFont  : xxxx,
 HXNaviColor : xxxx,
 }
 */
@property (nonatomic, strong)   NSDictionary  *titleDic;

/**
 as above
 */
@property (nonatomic, strong)   NSDictionary  *leftBtnConfigDic;


/**
 as above
 */
@property (nonatomic, strong)   NSDictionary  *rightBtnConfigDic;

@property (nonatomic, assign)   BOOL   hiddenSeperatorLine;

@property (nonatomic, copy)     UIView    *customTitleView;
@property (nonatomic, copy)     UIView    *customLeftBtn;
@property (nonatomic, copy)     UIView    *customRightBtn;

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

- (void)bindingAssociatedScrollView:(UIScrollView *)scrollView;

- (void)addTargetForLeftBtn:(nullable id)target
                     action:(SEL)action;

- (void)addTargetForRightBtn:(nullable id)target
                      action:(SEL)action;

- (void)customLayout:(void(^)(UIView *containerView))layoutBlock;


@end

NS_ASSUME_NONNULL_END
