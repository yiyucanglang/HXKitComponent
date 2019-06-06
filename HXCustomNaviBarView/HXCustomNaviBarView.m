//
//  HXCustomNaviBarView.m
//  ParentDemo
//
//  Created by James on 2019/6/5.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#import "HXCustomNaviBarView.h"
#import <Masonry/Masonry.h>
#import "HXImgTextCombineView.h"

@interface HXCustomNaviBarView()
@property (nonatomic, strong)   UIView    *translucentView;
@property (nonatomic, strong)   UIView    *contentView;

@property (nonatomic, strong)   UILabel   *innerTitleLB;
@property (nonatomic, strong)   HXImgTextCombineView  *innerLeftBtn;
@property (nonatomic, strong)   HXImgTextCombineView  *innerRightBtn;

@property (nonatomic, strong)   UIView  *lineView;


@property (nonatomic, strong)   MASConstraint  *leftBtnLeftMarginConstraint;

@property (nonatomic, strong)   MASConstraint  *leftItemMarginConstraint;

@property (nonatomic, strong)   MASConstraint  *rightItemMarginConstraint;

@property (nonatomic, strong)   MASConstraint  *heightConstraint;
@property (nonatomic, strong)   MASConstraint  *contentHeightConstraint;
@property (nonatomic, strong)   MASConstraint  *leftItemMaxWidthConstraint;
@property (nonatomic, strong)   MASConstraint  *rightItemMaxWidthConstraint;
@property (nonatomic, strong)   MASConstraint  *titleLeftConstraint;

@end

@implementation HXCustomNaviBarView
{
    BOOL _registNotiFlag;
}
#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        self.itemMaxLength     = 100;
        self.leftItemMargin    = 15;
        self.rightItemMargin   = -15;
        [self _registNoti];
        [self _UIConfig];
    }
    return self;
}

#pragma mark - System Method
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (self.superview) {
        [self _contentUIConfig];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.superview);
            if ([self isX]) {
                self.heightConstraint = make.height.equalTo(@(88));
            }
            else {
                self.heightConstraint = make.height.equalTo(@(64));
            }
        }];
    }
}


#pragma mark - Public Method
- (void)addTargetForLeftBtn:(id)target action:(SEL)action {
    [self.innerLeftBtn addTargetForClickEvent:target action:action];
}

- (void)addTargetForRightBtn:(id)target action:(SEL)action {
    [self.innerRightBtn addTargetForClickEvent:target action:action];
}

- (void)customLayout:(void (^)(UIView * _Nonnull))layoutBlock {
    for (UIView *item in self.contentView.subviews) {
        [item removeFromSuperview];
    }
    layoutBlock(self.contentView);
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Override
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.translucentView.backgroundColor = backgroundColor;
}

- (void)setAlpha:(CGFloat)alpha {
    self.translucentView.alpha = alpha;
}

#pragma mark - Private Method

#pragma mark Layout
- (void)_UIConfig {
    
    [self addTargetForLeftBtn:self action:@selector(_leftBtnAction)];
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.translucentView];
    [self.translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.translucentView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
      self.contentHeightConstraint = make.height.equalTo(@(44));
    }];
}

- (void)_contentUIConfig {
    
    for (UIView *item in self.contentView.subviews) {
        [item removeFromSuperview];
    }
    
    [self _leftItemUIConfig];
    [self _titleUIConfig];
    [self _rightItemUIConfig];
    
    
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(.5);
        make.height.equalTo(@(.5));
    }];
    
    self.itemMaxLength   = self.itemMaxLength;
    self.leftItemMargin  = self.leftItemMargin;
    self.rightItemMargin = self.rightItemMargin;
}

- (void)_leftItemUIConfig {
    [self.innerLeftBtn removeFromSuperview];
    
    [self.contentView addSubview:self.leftView];
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.leftItemMarginConstraint = make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
        self.leftItemMaxWidthConstraint =  make.width.lessThanOrEqualTo(@(100));
    }];
}

- (void)_titleUIConfig {
    [self.innerTitleLB removeFromSuperview];
    
    [self.contentView addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        self.titleLeftConstraint = make.left.greaterThanOrEqualTo(self.contentView).with.offset(110);
    }];
}

- (void)_rightItemUIConfig {
    [self.innerRightBtn removeFromSuperview];
    
    [self.contentView addSubview:self.rightView];
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        self.rightItemMarginConstraint = make.right.equalTo(self.contentView).with.offset(-15);
        make.centerY.equalTo(self.contentView);
        self.rightItemMaxWidthConstraint =  make.width.lessThanOrEqualTo(@(100));
    }];
}

#pragma mark
- (void)_registNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    _registNotiFlag = YES;
}

- (void)_removeNoti {
    if (_registNotiFlag) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)_leftBtnAction {
    [self.hx_ViewController.navigationController popViewControllerAnimated:YES];
}

- (void)_orientationChanged:(NSNotification *)noti {
    UIDevice *device = noti.object;
    
    if (device.orientation == UIDeviceOrientationFaceUp || device.orientation == UIDeviceOrientationFaceUp) {
        return;
    }
    
    if (device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight) {
        
        [self.contentHeightConstraint setOffset:32];
        [self.heightConstraint setOffset:32];
        
    }
    else {
        
        if ([self isX]) {
            [self.heightConstraint setOffset:88];
        }
        else {
            [self.heightConstraint setOffset:64];
        }
        
        [self.contentHeightConstraint setOffset:44];
        
    }
}

- (void)_createDefaultRightBtn {
    self.innerRightBtn = [[HXImgTextCombineView alloc] init];
    self.innerRightBtn.titleLB.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    self.innerRightBtn.titleLB.font = [UIFont systemFontOfSize:18];
}

#pragma mark Tool

- (BOOL)isX {
    
    return [UIApplication sharedApplication].statusBarFrame.size.height == 44;
}

- (UIViewController *)hx_ViewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



- (UIView *)titleView {
    if (self.customTitleView) {
        return self.customTitleView;
    }
    return self.innerTitleLB;
}

- (UIView *)leftView {
    if (self.customLeftBtn) {
        return self.customLeftBtn;
    }
    return self.innerLeftBtn;
}

- (UIView *)rightView {
    if (self.customRightBtn) {
        return self.customRightBtn;
    }
    return self.innerRightBtn;
}

#pragma mark - Delegate

#pragma mark - Setter And Getter
- (UIView *)translucentView {
    if (!_translucentView) {
        _translucentView = [[UIView alloc] init];
        _translucentView.backgroundColor = [UIColor whiteColor];
    }
    return _translucentView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}


- (HXImgTextCombineView *)innerLeftBtn {
    if (!_innerLeftBtn) {
        _innerLeftBtn = [[HXImgTextCombineView alloc] init];
        _innerLeftBtn.titleLB.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _innerLeftBtn.titleLB.font = [UIFont systemFontOfSize:18];
    }
    return _innerLeftBtn;
}

- (UILabel *)innerTitleLB {
    if (!_innerTitleLB) {
        _innerTitleLB      = [[UILabel alloc] init];
        _innerTitleLB.font = [UIFont systemFontOfSize:18];
        _innerTitleLB.textAlignment = NSTextAlignmentCenter;
        _innerTitleLB.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [_innerTitleLB setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_innerTitleLB setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _innerTitleLB;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:168/255.0 green:167/255.0 blue:171/255.0 alpha:YES];
    }
    return _lineView;
}


#pragma mark Config
- (void)setTitle:(NSString *)title {
    self.innerTitleLB.text = title;
}

- (void)setLeftBtnConfigDic:(NSDictionary *)leftBtnConfigDic {
    if (leftBtnConfigDic) {
        if (leftBtnConfigDic[HXNaviTitle]) {
            self.innerLeftBtn.titleLB.text = leftBtnConfigDic[HXNaviTitle];
        }
        if (leftBtnConfigDic[HXNaviFont]) {
            self.innerLeftBtn.titleLB.font = leftBtnConfigDic[HXNaviFont];
        }
        if (leftBtnConfigDic[HXNaviColor]) {
            self.innerLeftBtn.titleLB.textColor = leftBtnConfigDic[HXNaviColor];
        }
        if (leftBtnConfigDic[HXNaviImage]) {
            self.innerLeftBtn.imageView.image = leftBtnConfigDic[HXNaviImage];
        }
        
    }
}

- (void)setRightBtnConfigDic:(NSDictionary *)rightBtnConfigDic {
    if (rightBtnConfigDic) {
        [self _createDefaultRightBtn];
        [self _rightItemUIConfig];
        
        if (rightBtnConfigDic[HXNaviTitle]) {
            self.innerRightBtn.titleLB.text = rightBtnConfigDic[HXNaviTitle];
        }
        if (rightBtnConfigDic[HXNaviFont]) {
            self.innerRightBtn.titleLB.font = rightBtnConfigDic[HXNaviFont];
        }
        if (rightBtnConfigDic[HXNaviColor]) {
            self.innerRightBtn.titleLB.textColor = rightBtnConfigDic[HXNaviColor];
        }
        if (rightBtnConfigDic[HXNaviImage]) {
            self.innerRightBtn.imageView.image = rightBtnConfigDic[HXNaviImage];
        }
        
    }
}

- (void)setCustomLeftBtn:(UIView *)customLeftBtn {
    _customLeftBtn = customLeftBtn;
    [self _leftItemUIConfig];
}

- (void)setCustomTitleView:(UIView *)customTitleView {
    _customTitleView = customTitleView;
    [self _titleUIConfig];
}

- (void)setCustomRightBtn:(UIView *)customRightBtn {
    _customRightBtn = customRightBtn;
    [self _rightItemUIConfig];
}


- (void)setTitleDic:(NSDictionary *)titleDic {
    if (titleDic) {
        if (titleDic[HXNaviTitle]) {
            self.innerTitleLB.text = titleDic[HXNaviTitle];
        }
        if (titleDic[HXNaviFont]) {
            self.innerTitleLB.font = titleDic[HXNaviFont];
        }
        if (titleDic[HXNaviColor]) {
            self.innerTitleLB.textColor = titleDic[HXNaviColor];
        }
    }
}

- (void)setLeftItemMargin:(CGFloat)leftItemMargin {
    _leftItemMargin = leftItemMargin;
    [self.leftItemMarginConstraint setOffset:leftItemMargin];
}

- (void)setRightItemMargin:(CGFloat)rightItemMargin {
    _rightItemMargin = rightItemMargin;
    [self.rightItemMarginConstraint setOffset:rightItemMargin];
}

- (void)setItemMaxLength:(CGFloat)itemMaxLength {
    _itemMaxLength = MAX(itemMaxLength, 0);
    [self.leftItemMaxWidthConstraint setOffset:_itemMaxLength];
    [self.rightItemMaxWidthConstraint setOffset:_itemMaxLength];
    [self.titleLeftConstraint setOffset:(_itemMaxLength + 10)];
}

- (void)setHiddenSeperatorLine:(BOOL)hiddenSeperatorLine {
    self.lineView.hidden = hiddenSeperatorLine;
}

#pragma mark - Dealloc
- (void)dealloc {
    [self _removeNoti];
}

@end
