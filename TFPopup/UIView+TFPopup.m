//
//  UIView+TFPopup.m
//  TFPopupDemo
//
//  Created by ztf on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "UIView+TFPopup.h"
#import <objc/runtime.h>

#ifndef x_weakSelf
#define x_weakSelf __weak typeof(self) weakself = self
#endif

#ifdef DEBUG
#define PopupLog(fmt, ...) NSLog((@"\nfunc:%s,line:%d\n" fmt @"\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PopupLog(...)
#endif

@interface TFPopupPrivateExtension : NSObject
@property(nonatomic,assign)BOOL currentIsShowState;
@property(nonatomic,assign)NSInteger showAnimationCount;
@property(nonatomic,assign)NSInteger hideAnimationCount;
@end
@implementation TFPopupPrivateExtension
@end

@implementation UIView (TFPopup)
@dynamic inView,extension,popupDataSource,popupDelegate,backgroundDelegate,popupParam,style,direction;

#pragma mark -- 基本
-(void)tf_showNormal:(UIView *)inView animated:(BOOL)animated{
    [self tf_showNormal:inView offset:CGPointZero animated:animated];
}

-(void)tf_showNormal:(UIView *)inView offset:(CGPoint)offset animated:(BOOL)animated{
    TFPopupParam *param = [TFPopupParam new];
    
    param.offset = offset;
    param.disuseShowPopupAlphaAnimation = !animated;
    param.disuseHidePopupAlphaAnimation = !animated;
    param.disuseShowBackgroundAlphaAnimation = !animated;
    param.disuseHideBackgroundAlphaAnimation = !animated;
    
    [self tf_showNormal:inView popupParam:param];
}

-(void)tf_showNormal:(UIView *)inView popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    
    [self setDefault];
    
    [self tf_showCustem:inView popupParam:self.popupParam];
}

#pragma mark -- 缩放
-(void)tf_showScale:(UIView *)inView{
    [self tf_showScale:inView offset:CGPointZero];
}

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset{
    [self tf_showScale:inView offset:offset popupParam:[TFPopupParam new]];
}

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    
    [self setDefault];
    
    self.popupParam.offset = CGPointEqualToPoint(offset, CGPointZero)?self.popupParam.offset:offset;
    self.popupParam.showKeyPath = @"transform.scale";
    self.popupParam.showFromValue = @(0.0);
    self.popupParam.showToValue = @(1.0);
    self.popupParam.hideKeyPath = @"transform.scale";
    self.popupParam.hideFromValue = @(1.0);
    self.popupParam.hideToValue = @(0.0);
    
    [self tf_showCustem:inView popupParam:self.popupParam];
}

#pragma mark -- 滑动
-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction{
    [self tf_showSlide:inView direction:direction popupParam:[TFPopupParam new]];
}

-(void)tf_showSlide:(UIView *)inView
          direction:(PopupDirection)direction
         popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    
    [self setDefault];
    
    if (direction == PopupDirectionTop ||
        direction == PopupDirectionRight ||
        direction == PopupDirectionBottom ||
        direction == PopupDirectionLeft){
        
        if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero))
            self.popupParam.popOriginFrame = slideOriginFrame(self.popupParam, direction);
        
        if (CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero))
            self.popupParam.popTargetFrame = slideTargetFrame(self.popupParam, direction);
        
    }else if(direction == PopupDirectionFrame){
        if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero)||
            CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero)) {
            return;
        }
    }
    
    [self tf_showCustem:inView popupParam:self.popupParam];
}


#pragma mark -- 泡泡
-(void)tf_showBubble:(UIView *)inView
           basePoint:(CGPoint)basePoint
     bubbleDirection:(PopupDirection)bubbleDirection
          popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    self.popupParam.basePoint = basePoint;
    self.popupParam.bubbleDirection = bubbleDirection;
    
    [self setDefault];
    
    if ((self.popupParam.bubbleDirection == PopupDirectionTop ||
         self.popupParam.bubbleDirection == PopupDirectionTopRight ||
         self.popupParam.bubbleDirection == PopupDirectionRight ||
         self.popupParam.bubbleDirection == PopupDirectionRightBottom ||
         self.popupParam.bubbleDirection == PopupDirectionBottom ||
         self.popupParam.bubbleDirection == PopupDirectionBottomLeft ||
         self.popupParam.bubbleDirection == PopupDirectionLeft ||
         self.popupParam.bubbleDirection == PopupDirectionLeftTop) == NO) {
        return;
    }else{
        if (CGPointEqualToPoint(self.popupParam.basePoint, CGPointZero)) {
            return;
        }
    }
    
    self.popupParam.popOriginFrame = bubbleOrigin(self.popupParam.basePoint,
                                                  self.popupParam.bubbleDirection,
                                                  self.popupParam.offset);
    self.popupParam.popTargetFrame = bubbleTarget(self.popupParam.basePoint,
                                                  self.popupParam.popupSize,
                                                  self.popupParam.bubbleDirection,
                                                  self.popupParam.offset);
    [self tf_showCustem:inView popupParam:self.popupParam];
}

#pragma mark -- 形变
-(void)tf_showFrame:(UIView *)inView
               from:(CGRect)from
                 to:(CGRect)to
         popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    
    [self setDefault];
    
    self.popupParam.popOriginFrame = CGRectEqualToRect(CGRectZero, from)?self.popupParam.popOriginFrame:from;
    self.popupParam.popTargetFrame = CGRectEqualToRect(CGRectZero, to)?self.popupParam.popOriginFrame:to;
    
    [self tf_showCustem:inView popupParam:self.popupParam];
}


#pragma mark -- 遮罩
-(void)tf_showMask:(UIView *)inView
        popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    
    [self setDefault];
    
    [self tf_showCustem:inView popupParam:self.popupParam];
}


-(void)tf_showCustem:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam{
    if (inView == nil) {NSLog(@"****** %@ %@ ******",[self class],@"inView 不能为空！");return;}
    
    self.inView = inView;
    self.popupParam = popupParam;
    
    [self setDefault];
    
    [self checkStyle];
    //代理
    self.popupDelegate = self.popupDelegate==nil?self:self.popupDelegate;
    self.popupDataSource = self.popupDataSource==nil?self:self.popupDataSource;
    self.backgroundDelegate = self.backgroundDelegate==nil?self:self.backgroundDelegate;
    
    [self performSelectorOnMainThread:@selector(tf_reload) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(tf_show) withObject:nil waitUntilDone:YES];
}

-(void)tf_reload{
    
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewWillGetConfiguration:)]) {
        [self.popupDelegate tf_popupViewWillGetConfiguration:self];
    }
    
    self.extension.inView = nil;
    self.extension.popupArea = CGSizeZero;
    
    self.extension.backgroundViewCount = 0;
    [self.extension.backgroundViewArray removeAllObjects];
    [self.extension.backgroundViewFrameArray removeAllObjects];
    
    self.extension.disuseShowAlphaAnimation = NO;
    self.extension.showFromAlpha = -1;
    self.extension.showToAlpha = -1;
    
    self.extension.disuseShowFrameAnimation = NO;
    self.extension.showFromFrame = CGRectZero;
    self.extension.showToFrame = CGRectZero;
    
    self.extension.disuseHideAlphaAnimation = NO;
    self.extension.hideFromAlpha = -1;
    self.extension.hideToAlpha = -1;
    
    self.extension.disuseHideFrameAnimation = NO;
    self.extension.hideFromFrame = CGRectZero;
    self.extension.hideToFrame = CGRectZero;
    
    self.extension.showAnimationDuration = 0.3;
    self.extension.showAnimationDelay = 0.0;
    self.extension.showAnimationOptions = UIViewAnimationOptionCurveEaseOut;
    self.extension.hideAnimationDuration = 0.3;
    self.extension.hideAnimationDelay = 0.0;
    self.extension.hideAnimationOptions = UIViewAnimationOptionCurveEaseOut;
    
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupInView:)]) {
        self.extension.inView = [self.popupDataSource tf_popupInView:self];
    }
    
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupInArea:)]) {
        self.extension.popupArea = [self.popupDataSource tf_popupInArea:self];
    }
    
    /* background */
    if ([self.backgroundDelegate respondsToSelector:@selector(tf_popupBackgroundViewCount:)]) {
        self.extension.backgroundViewCount = [self.backgroundDelegate tf_popupBackgroundViewCount:self];
    }
    if (self.extension.backgroundViewCount > 0) {
        for (NSInteger i = 0; i < self.extension.backgroundViewCount; i++) {
            UIView *backgroundView = nil;
            CGRect  backgroundViewFrame = CGRectZero;
            if ([self.backgroundDelegate respondsToSelector:@selector(tf_popupView:backgroundViewAtIndex:)]) {
                backgroundView = [self.backgroundDelegate tf_popupView:self backgroundViewAtIndex:i];
            }
            if ([self.backgroundDelegate respondsToSelector:@selector(tf_popupView:backgroundViewFrameAtIndex:)]) {
                backgroundViewFrame = [self.backgroundDelegate tf_popupView:self backgroundViewFrameAtIndex:i];
            }
            NSAssert(backgroundView != nil, @"backgroundView can't be a nil");
            NSAssert([backgroundView isKindOfClass:[UIView class]], @"backgroundView must be a view");
            if (backgroundView != nil && [backgroundView isKindOfClass:[UIView class]]) {
                [self.extension.backgroundViewArray addObject:backgroundView];
                [self.extension.backgroundViewFrameArray addObject:NSStringFromCGRect(backgroundViewFrame)];
                backgroundView.frame = backgroundViewFrame;
            }
        }
    }
    
    /* show-alpha */
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationWithAlphaForState:)]) {
        BOOL animation = [self.popupDataSource tf_popupView:self animationWithAlphaForState:TFPopupStateShow];
        self.extension.disuseShowAlphaAnimation = !animation;
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:fromAlphaForState:)]) {
        self.extension.showFromAlpha = [self.popupDataSource tf_popupView:self fromAlphaForState:TFPopupStateShow];
        self.alpha = self.extension.showFromAlpha;
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:toAlphaForState:)]) {
        self.extension.showToAlpha = [self.popupDataSource tf_popupView:self toAlphaForState:TFPopupStateShow];
    }
    
    /* show-frame */
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationWithFrameForState:)]) {
        BOOL animation = [self.popupDataSource tf_popupView:self animationWithFrameForState:TFPopupStateShow];
        self.extension.disuseShowFrameAnimation = !animation;
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:fromFrameForState:)]) {
        self.extension.showFromFrame = [self.popupDataSource tf_popupView:self fromFrameForState:TFPopupStateShow];
        self.frame = self.extension.showFromFrame;
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:toFrameForState:)]) {
        self.extension.showToFrame = [self.popupDataSource tf_popupView:self toFrameForState:TFPopupStateShow];
    }
    
    /* hide-alpha */
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationWithAlphaForState:)]) {
        BOOL animation = [self.popupDataSource tf_popupView:self animationWithAlphaForState:TFPopupStateHide];
        self.extension.disuseHideAlphaAnimation = !animation;
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:fromAlphaForState:)]) {
        self.extension.hideFromAlpha = [self.popupDataSource tf_popupView:self fromAlphaForState:TFPopupStateHide];
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:toAlphaForState:)]) {
        self.extension.hideToAlpha = [self.popupDataSource tf_popupView:self toAlphaForState:TFPopupStateHide];
    }
    
    /* hide-frame */
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationWithFrameForState:)]) {
        BOOL animation = [self.popupDataSource tf_popupView:self animationWithFrameForState:TFPopupStateHide];
        self.extension.disuseHideFrameAnimation = !animation;
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:fromFrameForState:)]) {
        self.extension.hideFromFrame = [self.popupDataSource tf_popupView:self fromFrameForState:TFPopupStateHide];
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:toFrameForState:)]) {
        self.extension.hideToFrame = [self.popupDataSource tf_popupView:self toFrameForState:TFPopupStateHide];
    }
    
    /* animation-configue */
    /* show */
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationDurationForState:)]) {
        self.extension.showAnimationDuration = [self.popupDataSource tf_popupView:self animationDurationForState:TFPopupStateShow];
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationDelayForState:)]) {
        self.extension.showAnimationDelay = [self.popupDataSource tf_popupView:self animationDelayForState:TFPopupStateShow];
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationOptionsForState:)]) {
        self.extension.showAnimationOptions = [self.popupDataSource tf_popupView:self animationOptionsForState:TFPopupStateShow];
    }
    /* hide */
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationDurationForState:)]) {
        self.extension.hideAnimationDuration = [self.popupDataSource tf_popupView:self animationDurationForState:TFPopupStateHide];
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationDelayForState:)]) {
        self.extension.hideAnimationDelay = [self.popupDataSource tf_popupView:self animationDelayForState:TFPopupStateHide];
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationOptionsForState:)]) {
        self.extension.hideAnimationOptions = [self.popupDataSource tf_popupView:self animationOptionsForState:TFPopupStateHide];
    }
    
    
    /* 设置默认参数 */
    if (self.extension.inView == nil) {
        self.extension.inView = [UIApplication sharedApplication].keyWindow;
    }
    
    if (CGSizeEqualToSize(self.extension.popupArea, CGSizeZero)) {
        self.extension.popupArea = self.extension.inView.frame.size;
    }
    
    if (self.extension.showFromAlpha == -1) {
        self.extension.showFromAlpha = 0;
    }
    if (self.extension.showToAlpha == -1) {
        self.extension.showToAlpha = 1;
    }
    if (CGRectEqualToRect(self.extension.showFromFrame, CGRectZero)) {
        self.extension.showFromFrame = self.frame;
    }
    if (CGRectEqualToRect(self.extension.showToFrame, CGRectZero)) {
        self.extension.showToFrame = self.frame;
    }
    
    
    if (self.extension.hideFromAlpha == -1) {
        self.extension.hideFromAlpha = self.extension.showToAlpha;
    }
    if (self.extension.hideToAlpha == -1) {
        self.extension.hideToAlpha = self.extension.showFromAlpha;
    }
    if (CGRectEqualToRect(self.extension.hideFromFrame, CGRectZero)) {
        self.extension.hideFromFrame = self.extension.showToFrame;
    }
    if (CGRectEqualToRect(self.extension.hideToFrame, CGRectZero)) {
        self.extension.hideToFrame = self.extension.showFromFrame;
    }
    
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewDidGetConfiguration:)]) {
        [self.popupDelegate tf_popupViewDidGetConfiguration:self];
    }
}


static NSMutableDictionary *_tfPopupRunCache = nil;
static inline TFPopupPrivateExtension *getRunCache(NSObject *obj){
    if (obj == nil) {
        return nil;
    }
    if (_tfPopupRunCache == nil) {
        _tfPopupRunCache = [[NSMutableDictionary alloc]init];
    }
    NSString *addr = [NSString stringWithFormat:@"%p",obj];
    TFPopupPrivateExtension *ext = [_tfPopupRunCache objectForKey:addr];
    if (ext == nil) {
        ext = [[TFPopupPrivateExtension alloc]init];
        [_tfPopupRunCache setObject:ext forKey:addr];
    }
    return ext;
}
static inline void deleteRunCache(NSObject *obj){
    if (obj == nil) {
        return;
    }
    if (_tfPopupRunCache == nil) {
        _tfPopupRunCache = [[NSMutableDictionary alloc]init];
    }
    NSString *addr = [NSString stringWithFormat:@"%p",obj];
    [_tfPopupRunCache removeObjectForKey:addr];
}

#define kShowBaseAnimationKey @"kShowBaseAnimationKey"
#define kShowMaskAnimationKey @"kShowMaskAnimationKey"
#define kHideBaseAnimationKey @"kHideBaseAnimationKey"
#define kHideMaskAnimationKey @"kHideMaskAnimationKey"
-(void)tf_show{
    x_weakSelf;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewWillShow:)]) {
        BOOL breanAnimation = [self.popupDelegate tf_popupViewWillShow:self];
        if (breanAnimation) {
            return;
        }
    }
    //自动消失时间
    if (self.popupParam.autoDissmissDuration != 0) {
        [self performSelector:@selector(tf_hide)
                   withObject:nil
                   afterDelay:self.popupParam.autoDissmissDuration];
    }
    
    for (NSInteger i = 0; i < self.extension.backgroundViewCount; i++) {
        UIView *backgroundView = [self.extension.backgroundViewArray objectAtIndex:i];
        NSString *frameString = [self.extension.backgroundViewFrameArray objectAtIndex:i];
        backgroundView.frame = CGRectFromString(frameString);
        [self.inView addSubview:backgroundView];
    }
    self.alpha = self.extension.showFromAlpha;
    self.frame = self.extension.showFromFrame;
    [self.inView addSubview:self];
    
    TFPopupPrivateExtension *ext = getRunCache(self);
    ext.currentIsShowState = YES;
    ext.showAnimationCount = 0;
    
    if (self.extension.disuseShowAlphaAnimation == NO &&
        self.extension.showFromAlpha != self.extension.showToAlpha) {
        ext.showAnimationCount += 1;
        [UIView animateWithDuration:self.extension.showAnimationDuration
                              delay:self.extension.showAnimationDelay
                            options:self.extension.showAnimationOptions
                         animations:^{
                             weakself.alpha = weakself.extension.showToAlpha;
                         } completion:^(BOOL finished) {
                             [weakself showAnimationCompletion];
                         }];
    }else{
        self.alpha = weakself.extension.showToAlpha;
    }
    if (self.extension.disuseShowFrameAnimation == NO &&
        (CGRectEqualToRect(self.extension.showFromFrame, self.extension.showToFrame) == NO)) {
        ext.showAnimationCount += 1;
        [UIView animateWithDuration:self.extension.showAnimationDuration
                              delay:self.extension.showAnimationDelay
                            options:self.extension.showAnimationOptions
                         animations:^{
                             weakself.frame = weakself.extension.showToFrame;
                         } completion:^(BOOL finished) {
                             [weakself showAnimationCompletion];
                         }];
    }else{
        self.frame = weakself.extension.showToFrame;
    }
    
    
    //动画
    if (styleInclude(self.style, PopupStyleExtensionAniamtion)) {
        CAAnimation *animation = [self animation:self.popupParam.showKeyPath
                                            from:self.popupParam.showFromValue
                                              to:self.popupParam.showToValue
                                             dur:self.popupParam.duration];
        if (animation){
            ext.showAnimationCount += 1;
            animation.delegate = self;
            [self.layer addAnimation:animation forKey:kShowBaseAnimationKey];
        }
    }
    
    //遮罩
    if (styleInclude(self.style, PopupStyleExtensionMask)) {
        
        NSTimeInterval dur = self.popupParam.duration;
        NSString *keyPath = @"path";
        CAShapeLayer *mask = [[CAShapeLayer alloc]init];
        mask.frame = CGRectMake(0, 0, self.popupParam.popupSize.width, self.popupParam.popupSize.height);
        mask.path = self.popupParam.maskShowFromPath.CGPath;
        self.layer.mask = mask;
        
        id from = (__bridge id)self.popupParam.maskShowFromPath.CGPath;
        id to = (__bridge id)self.popupParam.maskShowToPath.CGPath;
        
        CAAnimation *animation = [self animation:keyPath from:from to:to dur:dur];
        if (animation){
            ext.showAnimationCount += 1;
            animation.delegate = self;
            [mask addAnimation:animation forKey:kShowMaskAnimationKey];
        }
    }
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewDidShow:)]) {
        [self.popupDelegate tf_popupViewDidShow:self];
    }
}

- (void)animationDidStart:(CAAnimation *)anim{
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    TFPopupPrivateExtension *ext = getRunCache(self);
    if (ext.currentIsShowState) {
        [self showAnimationCompletion];
    }else{
        [self hideAnimationCompletion];
    }
}


-(void)tf_hide{
    
    x_weakSelf;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewWillHide:)]) {
        BOOL breanAnimation = [self.popupDelegate tf_popupViewWillHide:self];
        if (breanAnimation) {
            return;
        }
    }
    
    TFPopupPrivateExtension *ext = getRunCache(self);
    ext.currentIsShowState = NO;
    ext.hideAnimationCount = 0;
    
    BOOL hasAlphaAniamtion = NO;
    BOOL hasFrameAniamtion = NO;
    BOOL hasBaseAniamtion = NO;
    BOOL hasMaskAniamtion = NO;
    
    if (self.extension.disuseHideAlphaAnimation == NO &&
        self.extension.hideFromAlpha != self.extension.hideToAlpha) {
        
        hasAlphaAniamtion = YES;
        ext.hideAnimationCount += 1;
        [UIView animateWithDuration:self.extension.hideAnimationDuration
                              delay:self.extension.hideAnimationDelay
                            options:self.extension.hideAnimationOptions
                         animations:^{
                             weakself.alpha = weakself.extension.hideToAlpha;
                         } completion:^(BOOL finished) {
                             [weakself hideAnimationCompletion];
                         }];
    }
    
    if (self.extension.disuseHideFrameAnimation == NO &&
        (CGRectEqualToRect(self.extension.hideFromFrame, self.extension.hideToFrame) == NO)) {
        
        hasFrameAniamtion = YES;
        ext.hideAnimationCount += 1;
        [UIView animateWithDuration:self.extension.hideAnimationDuration
                              delay:self.extension.hideAnimationDelay
                            options:self.extension.hideAnimationOptions
                         animations:^{
                             weakself.frame = weakself.extension.hideToFrame;
                         } completion:^(BOOL finished) {
                             [weakself hideAnimationCompletion];
                         }];
    }
    
    //动画
    if (styleInclude(self.style, PopupStyleExtensionAniamtion)) {
        CAAnimation *animation = [self animation:self.popupParam.hideKeyPath
                                            from:self.popupParam.hideFromValue
                                              to:self.popupParam.hideToValue
                                             dur:self.popupParam.duration];
        if (animation){
            hasBaseAniamtion = YES;
            ext.hideAnimationCount += 1;
            animation.delegate = self;
            [self.layer addAnimation:animation forKey:kHideBaseAnimationKey];
        }
    }
    
    //遮罩
    if (styleInclude(self.style, PopupStyleExtensionMask)) {
        NSTimeInterval dur = self.popupParam.duration;
        NSString *keyPath = @"path";
        CAShapeLayer *mask = self.layer.mask;
        [mask removeAnimationForKey:NSStringFromClass([self class])];
        id from = (__bridge id)self.popupParam.maskHideFromPath.CGPath;
        if (from == nil) {
            from = (__bridge id)self.popupParam.maskShowToPath.CGPath;
        }
        id to = (__bridge id)self.popupParam.maskHideToPath.CGPath;
        if (to == nil) {
            to = (__bridge id)self.popupParam.maskShowFromPath.CGPath;
        }
        CAAnimation *animation = [self animation:keyPath from:from to:to dur:dur];
        if (animation){
            hasMaskAniamtion = YES;
            ext.hideAnimationCount += 1;
            animation.delegate = self;
            [mask addAnimation:animation forKey:kHideMaskAnimationKey];
        }
    }
    
    BOOL removeIfNoAnyAnimation = YES;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewDidHide:)]) {
        removeIfNoAnyAnimation = [self.popupDelegate tf_popupViewDidHide:self];
    }
    if ((hasAlphaAniamtion || hasFrameAniamtion || hasBaseAniamtion || hasMaskAniamtion) == NO) {
        if (removeIfNoAnyAnimation) {
            [self tf_remove];
        }
    }
}

-(void)tf_remove{
    [self removeFromSuperview];
    NSArray *backgroundViewArray = [NSArray arrayWithArray:self.extension.backgroundViewArray];
    for (UIView *v in backgroundViewArray) {
        [v removeFromSuperview];
    }
    self.extension.backgroundViewCount = 0;
    [self.extension.backgroundViewArray removeAllObjects];
    [self.extension.backgroundViewFrameArray removeAllObjects];
}

-(void)showAnimationCompletion{
    TFPopupPrivateExtension *ext = getRunCache(self);
    ext.showAnimationCount -= 1;
    if (ext.showAnimationCount == 0) {
        deleteRunCache(self);
        if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewShowAnimationDidFinish:)]) {
            [self.popupDelegate tf_popupViewShowAnimationDidFinish:self];
        }
        
    }
}
-(void)hideAnimationCompletion{
    TFPopupPrivateExtension *ext = getRunCache(self);
    ext.hideAnimationCount -= 1;
    if (ext.hideAnimationCount == 0) {
        deleteRunCache(self);
        BOOL removeIfAllAnimationFinish = YES;
        if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewHideAnimationDidFinish:)]) {
            removeIfAllAnimationFinish = [self.popupDelegate tf_popupViewHideAnimationDidFinish:self];
        }
        if (removeIfAllAnimationFinish) {
            [self tf_remove];
        }
    }
}
#pragma mark -- 事件
-(void)backgroundViewClick:(UIButton *)ins{
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewBackgroundDidTouch:)]) {
        [self.popupDelegate tf_popupViewBackgroundDidTouch:self];
    }
}

#pragma mark -- TFPopupDelegate
- (void)tf_popupViewWillGetConfiguration:(UIView *)popup{
    
}
- (void)tf_popupViewDidGetConfiguration:(UIView *)popup{
    
}

- (BOOL)tf_popupViewWillShow:(UIView *)popup{
    UIView *backgroundView = self.extension.backgroundViewArray.firstObject;
    if (backgroundView) {
        if (self.popupParam.disuseShowBackgroundAlphaAnimation) {
            backgroundView.alpha = 1;
        }else{
            __weak typeof(backgroundView) weakBackgroundView = backgroundView;
            [UIView animateWithDuration:self.extension.showAnimationDuration
                                  delay:self.extension.showAnimationDelay
                                options:self.extension.showAnimationOptions
                             animations:^{
                                 weakBackgroundView.alpha = 1;
                             } completion:nil];
        }
    }
    return NO;
}
- (void)tf_popupViewDidShow:(UIView *)popup{}
- (void)tf_popupViewShowAnimationDidFinish:(UIView *)popup{}

- (BOOL)tf_popupViewWillHide:(UIView *)popup{
    UIView *backgroundView = self.extension.backgroundViewArray.firstObject;
    if (backgroundView) {
        if (self.popupParam.disuseHideBackgroundAlphaAnimation) {
            backgroundView.alpha = 0;
            [backgroundView removeFromSuperview];
        }else{
            __weak typeof(backgroundView) weakBackgroundView = backgroundView;
            [UIView animateWithDuration:self.extension.hideAnimationDuration
                                  delay:self.extension.hideAnimationDelay
                                options:self.extension.hideAnimationOptions
                             animations:^{
                                 weakBackgroundView.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [weakBackgroundView removeFromSuperview];
                             }];
        }
    }
    return NO;
}
- (BOOL)tf_popupViewDidHide:(UIView *)popup{
    return YES;
}
- (BOOL)tf_popupViewHideAnimationDidFinish:(UIView *)popup{
    return YES;
}

- (void)tf_popupViewBackgroundDidTouch:(UIView *)popup{
    if (self.popupParam.disuseBackgroundTouchHide == NO) {
        [self tf_hide];
    }
}

#pragma mark -- TFPopupBackgroundDelegate
- (NSInteger)tf_popupBackgroundViewCount:(UIView *)popup{
    if (self.popupParam.disuseBackground) {
        return 0;
    }
    return 1;
}

- (UIView *)tf_popupView:(UIView *)popup backgroundViewAtIndex:(NSInteger)index{
    UIButton *backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.popupParam.backgroundColorClear) {
        backgroundView.backgroundColor = [UIColor clearColor];
    }else{
        backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    }
    [backgroundView addTarget:self action:@selector(backgroundViewClick:) forControlEvents:UIControlEventTouchUpInside];
    backgroundView.alpha = 0;
    return backgroundView;
}
- (CGRect)tf_popupView:(UIView *)popup backgroundViewFrameAtIndex:(NSInteger)index{
    CGSize area = self.extension.popupArea;
    return CGRectMake(0, 0, area.width, area.height);
}

#pragma mark -- TFPopupDataSource

- (UIView *)tf_popupInView:(UIView *)popup{
    return self.inView;
}

- (CGSize  )tf_popupInArea:(UIView *)popup{
    return self.popupParam.popupAreaRect.size;
}

- (BOOL    )tf_popupView:(UIView *)popup animationWithAlphaForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            return !self.popupParam.disuseShowPopupAlphaAnimation;
        }break;
        case TFPopupStateHide:{
            return !self.popupParam.disuseHidePopupAlphaAnimation;
        }break;
        default:break;
    }
    return YES;
}
- (CGFloat )tf_popupView:(UIView *)popup fromAlphaForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            return 0;
        }break;
        case TFPopupStateHide:{
            return 1;
        }break;
        default:break;
    }
    return NO;
}
- (CGFloat )tf_popupView:(UIView *)popup toAlphaForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            return 1;
        }break;
        case TFPopupStateHide:{
            return 0;
        }break;
        default:break;
    }
    return NO;
}

- (BOOL    )tf_popupView:(UIView *)popup animationWithFrameForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            return !self.popupParam.disuseShowPopupFrameAnimation;
        }break;
        case TFPopupStateHide:{
            return !self.popupParam.disuseHidePopupFrameAnimation;
        }break;
        default:break;
    }
    return YES;
}
- (CGRect  )tf_popupView:(UIView *)popup fromFrameForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero) == NO) {
                return self.popupParam.popOriginFrame;
            }
            return normalOriginFrame(self.popupParam);
        }break;
        case TFPopupStateHide:{
            if (CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero) == NO) {
                return self.popupParam.popTargetFrame;
            }
            return normalTargetFrame(self.popupParam);
        }break;
        default:break;
    }
    return CGRectZero;
}
- (CGRect  )tf_popupView:(UIView *)popup toFrameForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            if (CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero) == NO) {
                return self.popupParam.popTargetFrame;
            }
            return normalTargetFrame(self.popupParam);
        }break;
        case TFPopupStateHide:{
            if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero) == NO) {
                return self.popupParam.popOriginFrame;
            }
            return normalOriginFrame(self.popupParam);
        }break;
        default:break;
    }
    return CGRectZero;
}
- (NSTimeInterval)tf_popupView:(UIView *)popup animationDurationForState:(TFPopupState)state{
    return 0.3;
}
- (NSTimeInterval)tf_popupView:(UIView *)popup animationDelayForState:(TFPopupState)state{
    return 0;
}
- (UIViewAnimationOptions)tf_popupView:(UIView *)popup animationOptionsForState:(TFPopupState)state{
    return UIViewAnimationOptionCurveEaseOut;
}




#pragma mark -- 代理 TFPopupDelegate 方法
-(void)setDefault{
    
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    //时间
    if (self.popupParam.duration == 0) self.popupParam.duration = 0.3;
    
    //弹框尺寸
    if (CGSizeEqualToSize(self.popupParam.popupSize, CGSizeZero))
        self.popupParam.popupSize = self.bounds.size;
    
    //弹框区域
    if (CGRectEqualToRect(self.popupParam.popupAreaRect, CGRectZero))
        self.popupParam.popupAreaRect = self.inView.bounds;
}

-(void)checkStyle{
    //参数值检测
    //alpha
    PopupStyle style = PopupStyleNone;
    
    //animation
    if (self.popupParam.showKeyPath != nil &&
        self.popupParam.showFromValue != nil &&
        self.popupParam.showToValue != nil){
        
        style = style | PopupStyleExtensionAniamtion;
        
        if (self.popupParam.hideKeyPath == nil)
            self.popupParam.hideKeyPath = self.popupParam.showKeyPath;
        if (self.popupParam.hideFromValue == nil)
            self.popupParam.hideFromValue = self.popupParam.showToValue;
        if (self.popupParam.hideToValue == nil)
            self.popupParam.hideToValue = self.popupParam.showFromValue;
    }
    
    //mask
    if (self.popupParam.maskShowFromPath != nil &&
        self.popupParam.maskShowToPath != nil ) {
        style = style | PopupStyleExtensionMask;
        
        if (self.popupParam.maskHideFromPath == nil)
            self.popupParam.maskHideFromPath = self.popupParam.maskShowToPath;
        if (self.popupParam.maskHideToPath == nil)
            self.popupParam.maskHideToPath = self.popupParam.maskShowFromPath;
    }
    self.style = style;
}


#pragma mark -- 方法抽取

-(CAAnimation *)animation:(NSString *)path from:(id)from to:(id)to dur:(NSTimeInterval)dur{
    
    if (path == nil || from == nil || to == nil || dur == 0.0) return nil;
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:path];
    [ani setFromValue:from];//设置起始值
    [ani setToValue:to];//设置目标值
    [ani setDuration:dur];//设置动画时间，单次动画时间
    [ani setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
    [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [ani setAutoreverses:NO];
    [ani setFillMode:kCAFillModeBoth];
    
    return ani;
}
static inline BOOL styleInclude(PopupStyle total,PopupStyle inc){
    return ((total & inc) == inc);
}

static inline CGRect normalOriginFrame(TFPopupParam *param){
    CGRect ar = param.popupAreaRect;
    CGSize s = param.popupSize;
    CGPoint st = param.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5 + st.x;
    CGFloat y = (ar.size.height - s.height) * 0.5 + st.y;
    return CGRectMake(x, y, s.width, s.height);
}

static inline CGRect normalTargetFrame(TFPopupParam *param){
    CGRect ar = param.popupAreaRect;
    CGSize s = param.popupSize;
    CGPoint st = param.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5 + st.x;
    CGFloat y = (ar.size.height - s.height) * 0.5 + st.y;
    return CGRectMake(x, y, s.width, s.height);
}

static inline CGRect bubbleOrigin(CGPoint basePoint,PopupDirection direction,CGPoint offset){
    
    CGFloat x = 0,y = 0;
    switch (direction) {
        case PopupDirectionTop:
        case PopupDirectionTopRight:
        case PopupDirectionRight:
        case PopupDirectionRightBottom:
        case PopupDirectionBottom:
        case PopupDirectionBottomLeft:
        case PopupDirectionLeft:
        case PopupDirectionLeftTop:{
            x = basePoint.x + offset.x;
            y = basePoint.y + offset.y;
        }break;
        default:break;
    }
    return CGRectMake(x, y, 0, 0);
}

static inline CGRect bubbleTarget(CGPoint basePoint,
                                  CGSize popupSize,
                                  PopupDirection direction,
                                  CGPoint offset){
    
    CGFloat x = 0,y = 0,w = popupSize.width,h = popupSize.height;
    CGFloat halfw = popupSize.width * 0.5,halfh = popupSize.height * 0.5;
    switch (direction) {
        case PopupDirectionTop:{
            x = (basePoint.x - halfw) + offset.x;
            y = (basePoint.y - h) + offset.y;
        }break;
        case PopupDirectionTopRight:{
            x = basePoint.x + offset.x;
            y = (basePoint.y - h) + offset.y;
        }break;
        case PopupDirectionRight:{
            x = basePoint.x + offset.x;
            y = (basePoint.y - halfh) + offset.y;
        }break;
        case PopupDirectionRightBottom:{
            x = basePoint.x + offset.x;
            y = basePoint.y + offset.y;
        }break;
        case PopupDirectionBottom:{
            x = (basePoint.x - halfw) + offset.x;
            y = basePoint.y + offset.y;
        }break;
        case PopupDirectionBottomLeft:{
            x = (basePoint.x - w) + offset.x;
            y = basePoint.y + offset.y;
        }break;
        case PopupDirectionLeft:{
            x = (basePoint.x - w) + offset.x;
            y = (basePoint.y - halfh) + offset.y;
        }break;
        case PopupDirectionLeftTop:{
            x = (basePoint.x - w) + offset.x;
            y = (basePoint.y - h) + offset.y;
        }break;
        default:break;
    }
    return CGRectMake(x, y, w, h);
}

static inline CGRect slideOriginFrame(TFPopupParam *param,PopupDirection direction){
    CGRect ar = param.popupAreaRect;
    CGSize s = param.popupSize;
    CGPoint st = param.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5;
    CGFloat y = (ar.size.height - s.height) * 0.5;
    CGFloat w = s.width;
    CGFloat h = s.height;
    switch (direction) {
        case PopupDirectionTop:{y = - s.height;x = x + st.x;}break;
        case PopupDirectionLeft:{x = - s.width;y = y + st.y;}break;
        case PopupDirectionBottom:{y = ar.size.height;x = x + st.x;}break;
        case PopupDirectionRight:{x = ar.size.width;y = y + st.y;}break;
        default:break;
    }
    CGRect position = CGRectMake(x, y, w, h);
    return position;
}

static inline CGRect slideTargetFrame(TFPopupParam *param,PopupDirection direction){
    CGRect ar = param.popupAreaRect;
    CGSize s = param.popupSize;
    CGPoint st = param.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5;
    CGFloat y = (ar.size.height - s.height) * 0.5;
    CGFloat w = s.width;
    CGFloat h = s.height;
    switch (direction) {
        case PopupDirectionTop:{y = 0 + st.y;x = x + st.x;}break;
        case PopupDirectionLeft:{x = 0 + st.x;y = y + st.y;}break;
        case PopupDirectionBottom:{y = ar.size.height - s.height + st.y;x = x + st.x;}break;
        case PopupDirectionRight:{x = ar.size.width - s.width + st.x;y = y + st.y;}break;
        default:break;
    }
    CGRect position = CGRectMake(x, y, w, h);
    return position;
}

#pragma mark -- 属性绑定

#ifndef tf_synthesize_category_property
#define tf_synthesize_category_property(getter,settter,objc_AssociationPolicy,TYPE)\
- (TYPE)getter{return objc_getAssociatedObject(self, @selector(getter));}\
- (void)settter:(TYPE)obj{objc_setAssociatedObject(self, @selector(getter), obj, objc_AssociationPolicy);}
#endif

#ifndef tf_synthesize_category_property_retain
#define tf_synthesize_category_property_retain(getter,settter) tf_synthesize_category_property(getter,settter,OBJC_ASSOCIATION_RETAIN_NONATOMIC,id)
#endif

#ifndef tf_synthesize_category_property_copy
#define tf_synthesize_category_property_copy(getter,settter)   tf_synthesize_category_property(getter,settter,OBJC_ASSOCIATION_COPY,id)
#endif

#ifndef tf_synthesize_category_property_assign
#define tf_synthesize_category_property_assign(getter,settter) tf_synthesize_category_property(getter,settter,OBJC_ASSOCIATION_ASSIGN,id)
#endif

tf_synthesize_category_property_retain(inView, setInView);
tf_synthesize_category_property_assign(popupDelegate, setPopupDelegate);
tf_synthesize_category_property_assign(popupDataSource, setPopupDataSource);
tf_synthesize_category_property_assign(backgroundDelegate, setBackgroundDelegate);
tf_synthesize_category_property_retain(popupParam, setPopupParam);

-(TFPopupExtension *)extension{
    id value = objc_getAssociatedObject(self, @selector(extension));
    if (value) {
        return value;
    }else{
        self.extension = [[TFPopupExtension alloc]init];
        value = self.extension;
    }
    return value;;
}
-(void)setExtension:(TFPopupExtension *)extension{
    objc_setAssociatedObject(self, @selector(extension), extension, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(PopupDirection)direction{
    id value = objc_getAssociatedObject(self, @selector(direction));
    if (value) {
        return [value integerValue];
    }
    return 0;
}
-(void)setDirection:(PopupDirection)direction{
    objc_setAssociatedObject(self, @selector(direction), @(direction), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(PopupStyle)style{
    id value = objc_getAssociatedObject(self, @selector(style));
    if (value) {
        return [value integerValue];
    }
    return 0;
}
-(void)setStyle:(PopupStyle)style{
    objc_setAssociatedObject(self, @selector(style), @(style), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end


@implementation CAAnimation (TFPopup)
@dynamic startBlock,stopBlock;
-(AnimationStartBlock)startBlock{
    id value = objc_getAssociatedObject(self, @selector(startBlock));
    if (value)return value;
    return nil;
}
-(void)setStartBlock:(AnimationStartBlock)startBlock{
    objc_setAssociatedObject(self, @selector(startBlock), startBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(AnimationStopBlock)stopBlock{
    id value = objc_getAssociatedObject(self, @selector(stopBlock));
    if (value)return value;
    return nil;
}

-(void)setStopBlock:(AnimationStopBlock)stopBlock{
    objc_setAssociatedObject(self, @selector(stopBlock), stopBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


-(void)observerAnimationDidStart:(AnimationStartBlock)start{
    if (self.delegate == nil) {
        self.delegate = self;
        self.startBlock = start;
    }
}
-(void)observerAnimationDidStop:(AnimationStopBlock)stop{
    if (self.delegate == nil) {
        self.delegate = self;
        self.stopBlock = stop;
    }
}

-(void)animationDidStart:(CAAnimation *)anim{
    if (self.startBlock) {
        self.startBlock(anim);
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.stopBlock) {
        self.stopBlock(anim, flag);
    }
}

@end





