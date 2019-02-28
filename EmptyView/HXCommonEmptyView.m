//
//  HXCommonEmptyView.m
//  JenkinsTest
//
//  Created by 周义进 on 2019/1/4.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXCommonEmptyView.h"
#import <Masonry/Masonry.h>
@interface HXCommonEmptyView()
@property (nonatomic, strong) UIView *containerView;
@end


@implementation HXCommonEmptyView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topMargin = 85;
        self.imageTextDistance = 15;
        self.textBtnDistance = 15;
        [self UIConfig];
    }
    return self;
}

#pragma mark - System Method

#pragma mark - Public Method
- (void)reloadData {
    [self UIConfig];
}

- (void)updateImage:(UIImage *)image des:(NSString *)des {
    if (image) {
        self.imageView.image = image;
    }
    if (des.length) {
        self.desLB.text      = des;
    }
}

- (void)addGesture:(UIGestureRecognizer *)gesture toView:(UIView *)view {
    [view removeGestureRecognizer:gesture];
    [view addGestureRecognizer:gesture];
}

#pragma mark - Private Method
- (void)UIConfig {
    [self.containerView removeFromSuperview];
    for (UIView *sub in self.containerView.subviews) {
        [sub removeFromSuperview];
    }
    self.clipsToBounds = YES;
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.lessThanOrEqualTo(self);
        if (self.layoutStyle == HXCommonEmptyViewLayoutStyleTop) {
            make.top.equalTo(self).with.offset(self.topMargin);
        }
        else {
            make.centerY.equalTo(self);
        }
        make.width.lessThanOrEqualTo(self);
    make.left.greaterThanOrEqualTo(self).with.offset(15);
    }];
    
    [self.containerView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView);
        make.centerX.equalTo(self.containerView);
        make.width.lessThanOrEqualTo(self.containerView);
        if (!CGSizeEqualToSize(self.imageSize, CGSizeZero)) {
            make.size.mas_equalTo(self.imageSize);
        }
    }];
    
    [self.containerView addSubview:self.desLB];
    [self.desLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).with.offset(self.imageTextDistance);
        make.left.right.equalTo(self.containerView);
        make.width.greaterThanOrEqualTo(self.imageView);
        if (!self.actionBtn) {
            make.bottom.equalTo(self.containerView).with.offset(0);
        }
    }];
    
    if (self.actionBtn) {
        [self.containerView addSubview:self.actionBtn];
        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.desLB.mas_bottom).with.offset(self.textBtnDistance);
            make.centerX.equalTo(self.containerView);
            make.width.lessThanOrEqualTo(self.containerView);
            make.width.greaterThanOrEqualTo(@(self.actionBtnWidth));
            make.height.greaterThanOrEqualTo(@(self.actionBtnHeight));
            make.bottom.equalTo(self.containerView).with.offset(0);
        }];
        
    }
}

#pragma mark - Delegate

#pragma mark - Setter And Getter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)desLB {
    if (!_desLB) {
        _desLB = [[UILabel alloc] init];
        _desLB.font = [UIFont systemFontOfSize:16];
        _desLB.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _desLB.textAlignment = NSTextAlignmentCenter;
        _desLB.numberOfLines = 0;
    }
    return _desLB;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

#pragma mark - Dealloc

@end
