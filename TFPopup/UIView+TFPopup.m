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

@implementation UIView (TFPopup)
@dynamic inView,extension,popupDataSource,popupDelegate,popupParam,style,direction;

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
    
    [self tf_showCustem:inView
             popupParam:self.popupParam
               delegate:self.popupDelegate?self.popupDelegate:self];
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
    
    [self tf_showCustem:inView
             popupParam:self.popupParam
               delegate:self.popupDelegate?self.popupDelegate:self];
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
    
    [self tf_showCustem:inView
             popupParam:self.popupParam
               delegate:self.popupDelegate?self.popupDelegate:self];
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
    [self tf_showCustem:inView
             popupParam:self.popupParam
               delegate:self.popupDelegate?self.popupDelegate:self];
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
    
    [self tf_showCustem:inView
             popupParam:self.popupParam
               delegate:self.popupDelegate?self.popupDelegate:self];
}


#pragma mark -- 遮罩
-(void)tf_showMask:(UIView *)inView
        popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    
    [self setDefault];
    
    [self tf_showCustem:inView
             popupParam:self.popupParam
               delegate:self.popupDelegate?self.popupDelegate:self];
}


-(void)tf_showCustem:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam
            delegate:(id<TFPopupDelegate>)delegate{
    
    if (inView == nil) {NSLog(@"****** %@ %@ ******",[self class],@"inView 不能为空！");return;}
    
    self.inView = inView;
    self.popupParam = popupParam;
    
    [self setDefault];
    
    [self checkStyle];
    //代理
    self.popupDelegate = delegate==nil?self:delegate;
    self.popupDataSource = self;
    
    [self performSelectorOnMainThread:@selector(tf_reload) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(tf_show) withObject:nil waitUntilDone:YES];
}

-(void)tf_reload{
    
    if (self.popupDataSource == nil) {return;}
    
    self.extension.inView = nil;
    
    self.extension.popupArea = CGSizeZero;
    
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
    
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupInView:)]) {
        self.extension.inView = [self.popupDataSource tf_popupInView:self];
    }
    
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupInArea:)]) {
        self.extension.popupArea = [self.popupDataSource tf_popupInArea:self];
    }
    
    /* show-alpha */
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationWithAlphaForState:)]) {
        BOOL animation = [self.popupDataSource tf_popupView:self animationWithAlphaForState:TFPopupStateShow];
        self.extension.disuseShowAlphaAnimation = animation;
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
        self.extension.disuseShowFrameAnimation = animation;
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
        self.extension.disuseHideAlphaAnimation = animation;
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
        self.extension.disuseHideFrameAnimation = animation;
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:fromFrameForState:)]) {
        self.extension.hideFromFrame = [self.popupDataSource tf_popupView:self fromFrameForState:TFPopupStateHide];
    }
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:toFrameForState:)]) {
        self.extension.hideToFrame = [self.popupDataSource tf_popupView:self toFrameForState:TFPopupStateHide];
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
    
}

-(void)tf_show{
    
    x_weakSelf;
    
    [self.inView addSubview:self];
    
    self.alpha = self.extension.showFromAlpha;
    self.frame = self.extension.showFromFrame;
    
    self.extension.showAnimationDuration = 0.3;
    self.extension.showAnimationDelay = 0.0;
    self.extension.showAnimationOptions = UIViewAnimationOptionCurveEaseOut;
    
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupView:animationDurationForState:)]) {
        self.extension.showAnimationDuration = [self.popupDelegate tf_popupView:self animationDurationForState:TFPopupStateShow];
    }
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupView:animationDelayForState:)]) {
        self.extension.showAnimationDelay = [self.popupDelegate tf_popupView:self animationDelayForState:TFPopupStateShow];
    }
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupView:animationOptionsForState:)]) {
        self.extension.showAnimationOptions = [self.popupDelegate tf_popupView:self animationOptionsForState:TFPopupStateShow];
    }
    
    if (self.extension.disuseShowAlphaAnimation == NO &&
        self.extension.showFromAlpha != self.extension.showToAlpha) {
        
        [UIView animateWithDuration:self.extension.showAnimationDuration
                              delay:self.extension.showAnimationDelay
                            options:self.extension.showAnimationOptions
                         animations:^{
                             weakself.alpha = weakself.extension.showToAlpha;
                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        self.alpha = weakself.extension.showToAlpha;
    }
    if (self.extension.disuseShowFrameAnimation == NO &&
        (CGRectEqualToRect(self.extension.showFromFrame, self.extension.showToFrame) == NO)) {
        
        [UIView animateWithDuration:self.extension.showAnimationDuration
                              delay:self.extension.showAnimationDelay
                            options:self.extension.showAnimationOptions
                         animations:^{
                             weakself.frame = weakself.extension.showToFrame;
                         } completion:^(BOOL finished) {
                             
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
        if (animation)
            [self.layer addAnimation:animation forKey:NSStringFromClass([self class])];
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
        if (animation)
            [mask addAnimation:animation forKey:NSStringFromClass([self class])];
    }
}



-(void)tf_hide{
    
    x_weakSelf;
   
    self.extension.hideAnimationDuration = 0.3;
    self.extension.hideAnimationDelay = 0.0;
    self.extension.hideAnimationOptions = UIViewAnimationOptionCurveEaseOut;
    
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupView:animationDurationForState:)]) {
        self.extension.hideAnimationDuration = [self.popupDelegate tf_popupView:self animationDurationForState:TFPopupStateHide];
    }
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupView:animationDelayForState:)]) {
        self.extension.hideAnimationDelay = [self.popupDelegate tf_popupView:self animationDelayForState:TFPopupStateHide];
    }
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupView:animationOptionsForState:)]) {
        self.extension.hideAnimationOptions = [self.popupDelegate tf_popupView:self animationOptionsForState:TFPopupStateHide];
    }
    
    if (self.extension.disuseHideAlphaAnimation == NO &&
        self.extension.hideFromAlpha != self.extension.hideToAlpha) {
        
        [UIView animateWithDuration:self.extension.hideAnimationDuration
                              delay:self.extension.hideAnimationDelay
                            options:self.extension.hideAnimationOptions
                         animations:^{
                             weakself.alpha = weakself.extension.hideToAlpha;
                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        self.alpha = weakself.extension.hideToAlpha;
    }
    
    if (self.extension.disuseHideFrameAnimation == NO &&
        (CGRectEqualToRect(self.extension.hideFromFrame, self.extension.hideToFrame) == NO)) {
        
        [UIView animateWithDuration:self.extension.hideAnimationDuration
                              delay:self.extension.hideAnimationDelay
                            options:self.extension.hideAnimationOptions
                         animations:^{
                             weakself.frame = weakself.extension.hideToFrame;
                         } completion:^(BOOL finished) {
                             
                         }];
    }else{
        self.frame = weakself.extension.hideToFrame;
    }
    
    //动画
    if (styleInclude(self.style, PopupStyleExtensionAniamtion)) {
        CAAnimation *animation = [self animation:self.popupParam.hideKeyPath
                                            from:self.popupParam.hideFromValue
                                              to:self.popupParam.hideToValue
                                             dur:self.popupParam.duration];
        if (animation)
            [self.layer addAnimation:animation forKey:NSStringFromClass([self class])];
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
        if (animation)
            [mask addAnimation:animation forKey:NSStringFromClass([self class])];
    }
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
            return !self.popupParam.disuseShowBackgroundAlphaAnimation;
        }break;
        case TFPopupStateHide:{
            return !self.popupParam.disuseHideBackgroundAlphaAnimation;
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

#pragma mark -- 代理 TFPopupDelegate 方法
-(void)setDefault{
    
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    //时间
    if (self.popupParam.duration == 0) self.popupParam.duration = 0.3;
    //自动消失时间
    if (self.popupParam.autoDissmissDuration != 0) {
        [self performSelector:@selector(tf_hide)
                           withObject:nil
                           afterDelay:self.popupParam.autoDissmissDuration];
    }
    
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

#pragma mark -- styleInclude
static inline BOOL styleInclude(PopupStyle total,PopupStyle inc){
    return ((total & inc) == inc);
}


#pragma mark -- normal-frame
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


#pragma mark -- bubble-frame
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

#pragma mark -- slide-frame
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
