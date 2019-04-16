//
//  HXImgTextCombineView.h
//  ParentDemo
//
//  Created by 周义进 on 2019/4/12.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ImgTextStyle)
{
    ImgTextStyleImgLeft,
    ImgTextStyleImgRight,
    ImgTextStyleImgTop
};

@interface HXImgTextCombineView : UIView

@property (nonatomic, strong, readonly)UILabel *titleLB;
@property (nonatomic, strong, readonly)UIImageView *imageView;

@property (nonatomic, assign) ImgTextStyle style;


//图文间距,默认5.f;
@property (nonatomic, assign)CGFloat distance;

//default cgsizezero
@property (nonatomic, assign) CGSize customImgSize;

//default 0
@property (nonatomic, assign) CGFloat textMaxLength;

//default 0
@property (nonatomic, assign) CGFloat centerYImgOffsetTextValue;

//must call this when config option above changed
- (void)reloadUI;

- (void)updateWithText:(NSString *)text
                   img:(UIImage *)img;


- (void)addTargetForClickEvent:(id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
