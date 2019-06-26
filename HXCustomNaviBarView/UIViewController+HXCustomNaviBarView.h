//
//  UIViewController+HXCustomNaviBarView.h
//  ParentDemo
//
//  Created by James on 2019/6/6.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HXCustomNaviBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (HXCustomNaviBarView)
@property (nonatomic, strong, readonly)   HXCustomNaviBarView  *hx_customNaviBarView;

@property (nonatomic, assign)   BOOL   hx_startCustomNaviBarFlag;
@property (nonatomic, assign)   BOOL   hx_forbiddenCustomNaviBarAutoToTopFlag;

//defult YES
@property (nonatomic, assign)   BOOL   hx_UIScrollViewContentInsetAdjustmentAutomaticFlag;

@end

NS_ASSUME_NONNULL_END
