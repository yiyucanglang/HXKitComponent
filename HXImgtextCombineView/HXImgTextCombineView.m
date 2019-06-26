//
//  HXImgTextCombineView.m
//  ParentDemo
//
//  Created by 周义进 on 2019/4/12.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXImgTextCombineView.h"
#import <Masonry/Masonry.h>

@interface HXImgTextCombineView()

@property (nonatomic, copy) UIView *containerView;

@property (nonatomic, strong, readwrite)UILabel *titleLB;

@property (nonatomic, strong, readwrite)UIImageView *imageView;

@property (nonatomic, strong) MASConstraint *distanceConstraint;

@property (nonatomic, strong) MASConstraint *centerYImgOffsetTextConstraint;

@end

@implementation HXImgTextCombineView
{
    UITapGestureRecognizer     *_tap;
}
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.distance = 5;
        self.customImgSize = CGSizeZero;
        _tap = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:_tap];
        [self UIConfig];
    }
    return self;
}

#pragma mark - System Method
//这个问题在WWDC 2012 Session 216视频中提到了一种解决方式。它重写了按钮中的pointInside方法，使得按钮热区不够44×44大小的先自动缩放到44×44，再判断触摸点是否在新的热区内。
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}


#pragma mark - Public Method
- (void)reloadUI {
    [self UIConfig];
}

- (void)addTargetForClickEvent:(id)target action:(SEL)action {
    [_tap removeTarget:nil action:nil];
    [_tap addTarget:target action:action];
}

- (void)updateWithText:(NSString *)text img:(UIImage *)img {
    self.titleLB.text    = text;
    self.imageView.image = img;
}

#pragma mark - Private Method
- (void)UIConfig {
    
    if (!self.containerView.superview) {
        [self addSubview:self.containerView];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.width.lessThanOrEqualTo(self);
        }];
    }
    
    while (self.containerView.subviews.count) {
        [self.containerView.subviews.lastObject removeFromSuperview];
    }
    

    [self.containerView addSubview:self.titleLB];
    [self.containerView addSubview:self.imageView];
    
    switch (self.style)
    {
        case ImgTextStyleImgLeft:
            
            [self initLeftStyle];
            break;
            
        case ImgTextStyleImgRight:
            
            [self initRightStyle];
            break;
            
        case ImgTextStyleImgTop:
            [self initTopStyle];
            break;
            
        default :
            [self initLeftStyle];
            break;
    }
}

- (void)initLeftStyle {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.centerY.equalTo(self.containerView);
        make.height.lessThanOrEqualTo(self.containerView);
        if (!CGSizeEqualToSize(self.customImgSize, CGSizeZero)) {
            make.size.mas_equalTo(self.customImgSize);
        }
    }];
    
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageView.mas_right).with.offset(self.distance); make.centerY.equalTo(self.imageView).with.offset(-self.centerYImgOffsetTextValue);
        make.height.lessThanOrEqualTo(self.containerView);
        make.right.equalTo(self.containerView);
        if (self.textMaxLength > 0) {
            make.width.lessThanOrEqualTo(@(self.textMaxLength));
        }
    }];
    
}

- (void)initRightStyle {
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.centerY.equalTo(self.containerView);
        make.height.lessThanOrEqualTo(self.containerView);
        if (self.textMaxLength > 0) {
            make.width.lessThanOrEqualTo(@(self.textMaxLength));
        }
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.titleLB.mas_right).with.offset(self.distance);
       make.centerY.equalTo(self.titleLB).with.offset(self.centerYImgOffsetTextValue);
        make.height.lessThanOrEqualTo(self.containerView);
        make.right.equalTo(self.containerView);
        if (!CGSizeEqualToSize(self.customImgSize, CGSizeZero)) {
            make.size.mas_equalTo(self.customImgSize);
        }
    }];
}

- (void)initTopStyle {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
       make.centerX.equalTo(self.containerView);
       make.width.lessThanOrEqualTo(self);
        if (!CGSizeEqualToSize(self.customImgSize, CGSizeZero)) {
            make.size.mas_equalTo(self.customImgSize);
        }
    }];
    
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).with.offset(self.distance);
        make.centerX.equalTo(self.containerView);
        make.width.lessThanOrEqualTo(self.containerView);
        make.bottom.equalTo(self.containerView);
        if (self.textMaxLength > 0) {
            make.width.lessThanOrEqualTo(@(self.textMaxLength));
        }
    }];
}



#pragma mark - Delegate

#pragma mark - Setter And Getter
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UILabel *)titleLB
{
    if (!_titleLB)
    {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:14];
        _titleLB.textColor = [UIColor blackColor];
        [_titleLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_titleLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _titleLB;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        [_imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _imageView;
}

#pragma mark - Dealloc

@end
