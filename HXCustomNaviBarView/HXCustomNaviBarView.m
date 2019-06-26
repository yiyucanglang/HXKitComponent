//
//  HXCustomNaviBarView.m
//  ParentDemo
//
//  Created by James on 2019/6/5.
//  Copyright © 2019 DaHuanXiong. All rights reserved.
//

#if 0

#define HXLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
#else
#define HXLog(...)

#endif


#import "HXCustomNaviBarView.h"
#import <Masonry/Masonry.h>
#import "HXImgTextCombineView.h"
#import <KVOController/KVOController.h>

@interface HXCustomNaviBarView()
@property (nonatomic, strong)   UIView    *translucentView;
@property (nonatomic, strong) UIVisualEffectView  *effectView;

@property (nonatomic, strong)   UIView    *contentView;
@property (nonatomic, strong)   UIView    *lineView;


@property (nonatomic, strong)   MASConstraint  *leftItemMarginConstraint;
@property (nonatomic, strong)   MASConstraint  *rightItemMarginConstraint;

@property (nonatomic, strong)   MASConstraint  *heightConstraint;
@property (nonatomic, strong)   MASConstraint  *contentHeightConstraint;
@property (nonatomic, strong)   MASConstraint  *leftItemMaxWidthConstraint;
@property (nonatomic, strong)   MASConstraint  *rightItemMaxWidthConstraint;
@property (nonatomic, strong)   MASConstraint  *titleLeftConstraint;

@property (nonatomic, assign) CGFloat   currentNaviBarHeight;

@property (nonatomic, weak) UIScrollView   *autoAssociatedVCScrollView;

@property (nonatomic, weak) UIScrollView   *unionScrollView;

@end

@implementation HXCustomNaviBarView
{
    BOOL _registNotiFlag;
    BOOL _customLayoutFlag;
}
@synthesize leftItem   = _leftItem;
@synthesize rightItem  = _rightItem;
@synthesize middleView = _middleView;

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.itemMaxLength     = 100;
        self.leftItemMargin    = 15;
        self.rightItemMargin   = -15;
        _translucent           = NO;
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
                [self updateNaviBarHeight:88];
            }
            else {
                self.heightConstraint = make.height.equalTo(@(64));
                [self updateNaviBarHeight:64];
            }
        }];
        HXLog(@"%s  _orientationChanged", _cmd);
        [self _orientationChanged];
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.translucentView.backgroundColor = backgroundColor;
}

- (void)setAlpha:(CGFloat)alpha {
    self.effectView.alpha = alpha;
    self.lineView.alpha = alpha;
}



#pragma mark - Public Method

- (void)addTargetForLeftItem:(id)target action:(SEL)action {
    
    if (self.leftItem && [self.leftItem isKindOfClass:[HXImgTextCombineView class]]) {
        HXImgTextCombineView *temp = (HXImgTextCombineView *)self.leftItem;
        [temp addTargetForClickEvent:target action:action];
    }
    
}

- (void)addTargetForRightItem:(id)target action:(SEL)action {
    if (self.rightItem && [self.rightItem isKindOfClass:[HXImgTextCombineView class]]) {
        HXImgTextCombineView *temp = (HXImgTextCombineView *)self.rightItem;
        [temp addTargetForClickEvent:target action:action];
    }
}

- (void)customLayout:(void (^)(UIView * _Nonnull))layoutBlock {
    _customLayoutFlag = YES;
    for (UIView *item in self.contentView.subviews) {
        [item removeFromSuperview];
    }
    layoutBlock(self.contentView);
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)bindingUnionScrollView:(UIScrollView *)scrollView scrollHandler:(void (^)(UIScrollView * _Nonnull))swipeHandler {
    if ([scrollView isEqual:self.autoAssociatedVCScrollView]) {
        self.autoAssociatedVCScrollView = nil;
    }
    
    self.unionScrollView = scrollView;
    
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self _statusBarHeightChanged];
    [self.KVOControllerNonRetaining observe:scrollView keyPath:FBKVOClassKeyPath(UIScrollView, contentOffset) options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        swipeHandler(scrollView);
    }];
    
}

#pragma mark - Override

#pragma mark - Private Method

#pragma mark Layout
- (void)_UIConfig {
    
    [self addTargetForLeftItem:self action:@selector(_leftBtnAction)];
    
    self.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect *blurEffect =[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [self.effectView.contentView addSubview:self.translucentView];
    [self.translucentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.translucentView.superview);
    }];
    
    [self addSubview:self.effectView];
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    [self _leftItemUIConfig];
    [self _middleViewUIConfig];
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
    
    if (_customLayoutFlag) {
        return;
    }
    
    [self.leftItem removeFromSuperview];

    [self.contentView addSubview:self.leftItem];
    [self.leftItem mas_makeConstraints:^(MASConstraintMaker *make) {
        self.leftItemMarginConstraint = make.left.equalTo(self.contentView).with.offset(self.leftItemMargin);
        make.centerY.equalTo(self.contentView);
        self.leftItemMaxWidthConstraint =  make.width.lessThanOrEqualTo(@(self.itemMaxLength));
    }];
}

- (void)_middleViewUIConfig {
    
    if (_customLayoutFlag) {
        return;
    }
    
    [self.middleView removeFromSuperview];

    [self.contentView addSubview:self.middleView];
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        self.titleLeftConstraint = make.left.greaterThanOrEqualTo(self.contentView).with.offset(self.itemMaxLength + 10);
    }];
}

- (void)_rightItemUIConfig {
    
    if (_customLayoutFlag) {
        return;
    }
    
    [self.contentView addSubview:self.rightItem];
    [self.rightItem mas_makeConstraints:^(MASConstraintMaker *make) {
        self.rightItemMarginConstraint = make.right.equalTo(self.contentView).with.offset(self.rightItemMargin);
        make.centerY.equalTo(self.contentView);
        self.rightItemMaxWidthConstraint =  make.width.lessThanOrEqualTo(@(self.itemMaxLength));
    }];
}

- (void)_createDefaultRightItem {
    
    HXImgTextCombineView *temp = [[HXImgTextCombineView alloc] init];
    temp.titleLB.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    temp.titleLB.font = [UIFont systemFontOfSize:18];
    self.rightItem = temp;
}

#pragma mark
- (void)_registNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_orientationChanged) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_statusBarHeightChanged) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    _registNotiFlag = YES;
}

- (void)_removeNoti {
    if (_registNotiFlag) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)_orientationChanged {
    UIDevice *device = [UIDevice currentDevice];
    
    if (device.orientation == UIDeviceOrientationFaceUp || device.orientation == UIDeviceOrientationFaceUp) {
        return;
    }
    
    if (device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight) {
        
        [self.contentHeightConstraint setOffset:32];
        [self updateNaviBarHeight:52];
        
    }
    else {
        
        if ([self isX]) {
            [self updateNaviBarHeight:88];
        }
        else {
            [self updateNaviBarHeight:64];
        }
        
        [self.contentHeightConstraint setOffset:44];
        
    }
}

- (void)_statusBarHeightChanged {
    UIEdgeInsets edge = self.unionScrollView.contentInset;
    if (![self isX]) {//非X
        if ([UIApplication sharedApplication].statusBarFrame.size.height == 20) {
            edge.top = 0;
            HXLog(@"%s top:%@", _cmd, @(0));
        }
        else {
            edge.top = 20;
            HXLog(@"%s top:%@", _cmd, @(20));
        }
        self.unionScrollView.contentInset = edge;
    }
}

- (void)_leftBtnAction {
    [self.hx_ViewController.navigationController popViewControllerAnimated:YES];
}

- (void)updateNaviBarHeight:(CGFloat)newHeight {
    self.currentNaviBarHeight = newHeight;
    
    [self.heightConstraint setOffset:newHeight];
    
    UIEdgeInsets insets = self.autoAssociatedVCScrollView.contentInset;
    
    HXLog(@"%s top:%@", _cmd, @(newHeight));
    
    insets.top = newHeight;
    self.autoAssociatedVCScrollView.contentInset = insets;
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
        _contentView.backgroundColor = [UIColor clearColor];
    }
    return _contentView;
}


- (UIView *)leftItem {
    if (!_leftItem) {
        HXImgTextCombineView *temp = [[HXImgTextCombineView alloc] init];
        temp.titleLB.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        temp.titleLB.font = [UIFont systemFontOfSize:18];
        
        _leftItem = temp;
    }
    return _leftItem;
}

- (UIView *)middleView {
    if (!_middleView) {
        UILabel *temp = [[UILabel alloc] init];
        temp.font = [UIFont systemFontOfSize:18];
        temp.textAlignment = NSTextAlignmentCenter;
        temp.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        [temp setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [temp setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _middleView = temp;
    }
    return _middleView;
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
    if(self.middleView && [self.middleView isKindOfClass:[UILabel class]]) {
        UILabel *temp = (UILabel *)self.middleView;
        temp.text = title;
    }
    
}

- (void)setLeftItemConfigDic:(NSDictionary *)leftItemConfigDic {
    
    HXImgTextCombineView *leftItem = (HXImgTextCombineView *)self.leftItem;
    
    if (leftItemConfigDic && [leftItem isKindOfClass:[HXImgTextCombineView class]]) {
        if (leftItemConfigDic[HXNaviTitle]) {
            leftItem.titleLB.text = leftItemConfigDic[HXNaviTitle];
        }
        if (leftItemConfigDic[HXNaviFont]) {
            leftItem.titleLB.font = leftItemConfigDic[HXNaviFont];
        }
        if (leftItemConfigDic[HXNaviColor]) {
            leftItem.titleLB.textColor = leftItemConfigDic[HXNaviColor];
        }
        if (leftItemConfigDic[HXNaviImage]) {
            leftItem.imageView.image = leftItemConfigDic[HXNaviImage];
        }
        if (leftItemConfigDic[HXNaviItemImgTextDistance]) {
            leftItem.distance = [leftItemConfigDic[HXNaviItemImgTextDistance] floatValue];
        }
        
    }
}

- (void)setRightItemConfigDic:(NSDictionary *)rightItemConfigDic {
    if (rightItemConfigDic) {
        [self _createDefaultRightItem];
        [self _rightItemUIConfig];

        HXImgTextCombineView *rightItem = (HXImgTextCombineView *)self.rightItem;
        if (rightItemConfigDic[HXNaviTitle]) {
            rightItem.titleLB.text = rightItemConfigDic[HXNaviTitle];
        }
        if (rightItemConfigDic[HXNaviFont]) {
            rightItem.titleLB.font = rightItemConfigDic[HXNaviFont];
        }
        if (rightItemConfigDic[HXNaviColor]) {
            rightItem.titleLB.textColor = rightItemConfigDic[HXNaviColor];
        }
        if (rightItemConfigDic[HXNaviImage]) {
            rightItem.imageView.image = rightItemConfigDic[HXNaviImage];
        }
        if (rightItemConfigDic[HXNaviItemImgTextDistance]) {
            rightItem.distance = [rightItemConfigDic[HXNaviItemImgTextDistance] floatValue];
        }

    }
}

- (void)setLeftItem:(UIView *)leftItem {
    _leftItem = leftItem;
    [self _leftItemUIConfig];
}

- (void)setMiddleView:(UIView *)middleView {
    _middleView = middleView;
    [self _middleViewUIConfig];
}

- (void)setRightItem:(UIView *)rightItem {
    _rightItem = rightItem;
    [self _rightItemUIConfig];
}


- (void)setMiddleViewConfigDic:(NSDictionary *)middleViewConfigDic {
    UILabel *defaultTitleLB = (UILabel *)self.middleView;
    if (middleViewConfigDic && [defaultTitleLB isKindOfClass:[UILabel class]]) {
        if (middleViewConfigDic[HXNaviTitle]) {
            defaultTitleLB.text = middleViewConfigDic[HXNaviTitle];
        }
        if (middleViewConfigDic[HXNaviFont]) {
            defaultTitleLB.font = middleViewConfigDic[HXNaviFont];
        }
        if (middleViewConfigDic[HXNaviColor]) {
            defaultTitleLB.textColor = middleViewConfigDic[HXNaviColor];
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

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    if (_translucent) {
        self.translucentView.alpha = 0.85;
    }
    else {
        self.translucentView.alpha = 1;
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    [self _removeNoti];
}

@end

@implementation HXCustomNaviBarView (ViewControllerPrivate)

- (void)bindingAutoAssociatedVCScrollView:(UIScrollView *)scrollView {
    
    if ([self.unionScrollView isEqual:scrollView]) {
        return;
    }
    
    self.autoAssociatedVCScrollView = scrollView;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self updateNaviBarHeight:self.currentNaviBarHeight];
}

@end
