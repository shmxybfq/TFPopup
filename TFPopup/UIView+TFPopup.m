//
//  UIView+TFPopup.m
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "UIView+TFPopup.h"
#import <objc/runtime.h>

@implementation UIView (TFPopup)
@dynamic inView,manager,popupParam,style,direction;
@dynamic popupDelegate,backgroundView;

#pragma mark -- 【隐藏】
-(void)tf_hide{
    [self.manager performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:YES];
}

#pragma mark -- 【无动画弹出,透明度动画弹出】方式
-(void)tf_showNormal:(UIView *)inView animated:(BOOL)animated{
    [self tf_showNormal:inView offset:CGPointZero animated:animated];
}

-(void)tf_showNormal:(UIView *)inView offset:(CGPoint)offset animated:(BOOL)animated{
    TFPopupParam *param = [TFPopupParam new];
    param.offset = offset;
    param.disusePopupAlphaAnimation = !animated;
    param.disuseBackgroundAlphaAnimation = !animated;
    [self tf_showNormal:inView popupParam:param];
}

-(void)tf_showNormal:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam{
    
    self.popupParam = popupParam;
    self.inView = inView;
    [self setDefault];
    
    [self tf_showCustem:inView
             popupParam:self.popupParam
               delegate:self.popupDelegate?self.popupDelegate:self];
}

#pragma mark -- 【缩放动画弹出】方式
-(void)tf_showScale:(UIView *)inView{
    [self tf_showScale:inView offset:CGPointZero];
}

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset{
    [self tf_showScale:inView offset:offset popupParam:[TFPopupParam new]];
}

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset popupParam:(TFPopupParam *)popupParam{
    
    self.popupParam = popupParam;
    self.inView = inView;
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

#pragma mark -- 【滑动出来动画】方式
-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction{
    [self tf_showSlide:inView direction:direction popupParam:[TFPopupParam new]];
}

-(void)tf_showSlide:(UIView *)inView
          direction:(PopupDirection)direction
         popupParam:(TFPopupParam *)popupParam{
    
    self.popupParam = popupParam;
    self.inView = inView;
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


#pragma mark -- 【形变出来动画】方式
-(void)tf_showBubble:(UIView *)inView
           basePoint:(CGPoint)basePoint
     bubbleDirection:(PopupDirection)bubbleDirection
          popupParam:(TFPopupParam *)popupParam{
    
    self.popupParam = popupParam;
    self.inView = inView;
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
    }
    
    
    if (self.popupParam.bubbleDirection != PopupDirectionFrame &&
        CGPointEqualToPoint(self.popupParam.basePoint, CGPointZero))
        return;
    
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

#pragma mark -- 【形变出来动画】方式
-(void)tf_showFrame:(UIView *)inView
               from:(CGRect)from
                 to:(CGRect)to
         popupParam:(TFPopupParam *)popupParam{
    
    self.popupParam = popupParam;
    self.inView = inView;
    [self setDefault];
    
    self.popupParam.popOriginFrame = CGRectEqualToRect(CGRectZero, from)?self.popupParam.popOriginFrame:from;
    self.popupParam.popTargetFrame = CGRectEqualToRect(CGRectZero, to)?self.popupParam.popOriginFrame:to;
    
    [self tf_showCustem:inView
             popupParam:self.popupParam
               delegate:self.popupDelegate?self.popupDelegate:self];
}


-(void)tf_showMask:(UIView *)inView
        popupParam:(TFPopupParam *)popupParam{
    
    self.popupParam = popupParam;
    self.inView = inView;
    [self setDefault];
    
    [self tf_showCustem:inView
             popupParam:self.popupParam
               delegate:self.popupDelegate?self.popupDelegate:self];
}


-(void)tf_showCustem:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam
            delegate:(id<TFPopupDelegate>)delegate{
    if (inView == nil) {NSLog(@"****** %@ %@ ******",[self class],@"inView 不能为空！");return;}
    self.popupParam = popupParam;
    self.inView = inView;
    [self setDefault];
    [self checkStyle];
    //代理
    self.popupDelegate = delegate;
    
    [self.manager performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    [self.manager performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

-(void)setDefault{
    
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    
    //初始化弹框管理
    if (self.manager == nil) {
        self.manager = [TFPopupManager tf_popupManagerDataSource:self delegate:self];
    }
    
    //时间
    if (self.popupParam.duration == 0) self.popupParam.duration = 0.3;
    //自动消失时间
    if (self.popupParam.autoDissmissDuration != 0) {
        [self.manager performSelector:@selector(hide)
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
    if (self.popupParam.disuseBackgroundAlphaAnimation == NO ||
        self.popupParam.disusePopupAlphaAnimation == NO)
        style = style | PopupStyleAlpha;
    
    //animation
    if (self.popupParam.showKeyPath != nil &&
        self.popupParam.showFromValue != nil &&
        self.popupParam.showToValue != nil){
        
        style = style | PopupStyleAniamtion;
        
        if (self.popupParam.hideKeyPath == nil)
            self.popupParam.hideKeyPath = self.popupParam.showKeyPath;
        if (self.popupParam.hideFromValue == nil)
            self.popupParam.hideFromValue = self.popupParam.showToValue;
        if (self.popupParam.hideToValue == nil)
            self.popupParam.hideToValue = self.popupParam.showFromValue;
    }
    
    //frame
    if (CGRectEqualToRect(self.popupParam.popOriginFrame, self.popupParam.popTargetFrame) == NO) {
        style = style | PopupStyleFrame;
    }
    
    //mask
    if (self.popupParam.maskShowFromPath != nil &&
        self.popupParam.maskShowToPath != nil ) {
        style = style | PopupStyleMask;
        
        if (self.popupParam.maskHideFromPath == nil)
            self.popupParam.maskHideFromPath = self.popupParam.maskShowToPath;
        if (self.popupParam.maskHideToPath == nil)
            self.popupParam.maskHideToPath = self.popupParam.maskShowFromPath;
    }
    self.style = style;
}

#pragma mark 代理 TFPopupManagerDataSource 方法
/* 执行顺序:0 返回【默认使用的动画方式,可叠加】 */
-(TFPopupDefaultAnimation)tf_popupManager_popDefaultAnimation:(TFPopupManager *)manager{
    
    TFPopupDefaultAnimation ani = TFPopupDefaultAnimationNone;
    if (styleInclude(self.style, PopupStyleAlpha)){
        if (self.popupParam.disuseBackgroundAlphaAnimation == NO)
            ani = ani | TFPopupDefaultAnimationBackgroundAlpha;
        if (self.popupParam.disusePopupAlphaAnimation == NO)
            ani = ani | TFPopupDefaultAnimationPopBoardAlpha;
    }
    
    if (styleInclude(self.style, PopupStyleAniamtion)||
        styleInclude(self.style, PopupStyleMask)){
        ani = ani | TFPopupDefaultAnimationCustem;
    }
    
    if (styleInclude(self.style, PopupStyleFrame)){
        ani = ani | TFPopupDefaultAnimationPopBoardFrame;
    }
    
    //if (ani == TFPopupDefaultAnimationNone)
    // ani = ani | TFPopupDefaultAnimationCustem;
    
    return ani;
}

/* 执行顺序:1 返回【弹框的父视图】 */
-(UIView  *)tf_popupManager_popForView:(TFPopupManager *)manager{
    return self.inView;
}

/* 执行顺序:4 返回【弹出框view】 */
-(UIView  *)tf_popupManager_popBoardView:(TFPopupManager *)manager{
    return self;
}

/* 执行顺序:2 返回【弹出框的上层背景视图,默认动画alpha=0,弹出时动画为alpha=1,自定义动画则忽略默认动画 */
-(UIView  *)tf_popupManager_popForBackgroundView:(TFPopupManager *)manager{
    if (self.popupParam.disuseBackground == NO) {
        if ([self.popupDelegate respondsToSelector:@selector(tf_popupCustemBackgroundView:popup:)]) {
            self.backgroundView = [self.popupDelegate tf_popupCustemBackgroundView:self.manager
                                                                             popup:self];
        }else{
            self.backgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        if (self.popupParam.backgroundColorClear) {
            self.backgroundView.backgroundColor = [UIColor clearColor];
        }else{
            UIColor *color = [[UIColor blackColor]colorWithAlphaComponent:0.3];
            self.backgroundView.backgroundColor = color;
        }
        if ([self.backgroundView respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
            [((UIButton *)self.backgroundView) addTarget:self
                                                  action:@selector(coverClick:)
                                        forControlEvents:UIControlEventTouchUpInside];
        }else{
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
            [tapGes addTarget:self action:@selector(coverTap:)];
            [self.backgroundView addGestureRecognizer:tapGes];
        }
        return self.backgroundView;
    }
    return nil;
}

/* 执行顺序:3 返回【弹出框的上层背景视图的位置,frame或者 约束,如设置了约束则frame无效 */
-(CGRect   )tf_popupManager_popForBackgroundViewPosition:(TFPopupManager *)manager
                                          backgroundView:(UIView *)backgroundView{
    return self.popupParam.popupAreaRect;
}

/* 执行顺序:5 返回【弹出框view,动画开始时候的位置,frame或者 约束,自定义动画则忽略默认动画】 */
-(CGRect   )tf_popupManager_popBoardViewBeginPosition:(TFPopupManager *)manager
                                            boardView:(UIView *)boardView{
    
    //不改变
    if (self.popupParam.keepPopupOriginFrame)return self.frame;
    //优先级popOriginFrame > 默认计算
    if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero) == NO)
        return self.popupParam.popOriginFrame;
    //默认计算
    CGRect ar = self.popupParam.popupAreaRect;
    CGSize s = self.popupParam.popupSize;
    CGPoint st = self.popupParam.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5 + st.x;
    CGFloat y = (ar.size.height - s.height) * 0.5 + st.y;
    return CGRectMake(x, y, s.width, s.height);
}

/* 执行顺序:6 返回【弹出框view,动画结束时候的位置,frame或者 约束,自定义动画则忽略默认动画】 */
-(CGRect   )tf_popupManager_popBoardViewEndPosition:(TFPopupManager *)manager
                                          boardView:(UIView *)boardView{
    
    if (self.popupParam.keepPopupOriginFrame)return self.frame;
    //优先级popTargetFrame > 默认计算
    if (CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero) == NO)
        return self.popupParam.popTargetFrame;
    //默认计算
    CGRect ar = self.popupParam.popupAreaRect;
    CGSize s = self.popupParam.popupSize;
    CGPoint st = self.popupParam.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5 + st.x;
    CGFloat y = (ar.size.height - s.height) * 0.5 + st.y;
    return CGRectMake(x, y, s.width, s.height);
}

-(NSTimeInterval)tf_popupManager_popDefaultAnimationDuration:(TFPopupManager *)manager{
    return self.popupParam.duration;
}

#pragma mark 代理 TFPopupManagerDelegate 方法

/* 弹出框展示动画开始前回调 */
-(void)tf_popupManager_willShow:(TFPopupManager *)manager
                  tellToManager:(void(^)(BOOL stopDefaultAnimation,NSTimeInterval duration))tellToManager{
    
    BOOL breakOriginAnimation = NO;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupWillShow:popup:)]) {
        breakOriginAnimation = [self.popupDelegate tf_popupWillShow:self.manager popup:self];
        if (breakOriginAnimation) {
            tellToManager(YES,self.popupParam.duration);
            return;
        }
    }
    
    //动画
    if (styleInclude(self.style, PopupStyleAniamtion)) {
        CAAnimation *animation = [self animation:self.popupParam.showKeyPath
                                            from:self.popupParam.showFromValue
                                              to:self.popupParam.showToValue
                                             dur:self.popupParam.duration];
        if (animation)
            [self.layer addAnimation:animation forKey:NSStringFromClass([self class])];
    }
    
    //遮罩
    if (styleInclude(self.style, PopupStyleMask)) {
        
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
    tellToManager(NO,self.popupParam.duration);
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

/* 弹出框展示动画完成后回调,自定义动画不回调 */
-(void)tf_popupManager_didShow:(TFPopupManager *)manager
              defaultAnimation:(TFPopupDefaultAnimation)defaultAnimation
               isAnimationShow:(BOOL)isAnimationShow{
    
}
/* 弹出框隐藏动画开始前回调 */
-(void)tf_popupManager_willHide:(TFPopupManager *)manager
                  tellToManager:(void(^)(BOOL stopDefaultAnimation,NSTimeInterval duration))tellToManager{
    BOOL breakOriginAnimation = NO;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupWillHide:popup:)]) {
        breakOriginAnimation = [self.popupDelegate tf_popupWillHide:self.manager popup:self];
        if (breakOriginAnimation) {
            tellToManager(YES,self.popupParam.duration);
            return;
        }
    }
    
    //动画
    if (styleInclude(self.style, PopupStyleAniamtion)) {
        CAAnimation *animation = [self animation:self.popupParam.hideKeyPath
                                            from:self.popupParam.hideFromValue
                                              to:self.popupParam.hideToValue
                                             dur:self.popupParam.duration];
        if (animation)
            [self.layer addAnimation:animation forKey:NSStringFromClass([self class])];
    }
    
    //遮罩
    if (styleInclude(self.style, PopupStyleMask)) {
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
    tellToManager(NO,self.popupParam.duration);
}

/* 弹出框隐藏动画完成后回调,自定义动画不回调 */
-(void)tf_popupManager_didHide:(TFPopupManager *)manager
              defaultAnimation:(TFPopupDefaultAnimation)defaultAnimation
               isAnimationHide:(BOOL)isAnimationHide{
    
}


-(void)coverClick:(UIButton *)ins{
    [self coverAction];
}

-(void)coverTap:(UITapGestureRecognizer *)ins{
    [self coverAction];
}

-(void)coverAction{
    BOOL breakOpration = NO;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupBackgroundTouch:popup:)]) {
        breakOpration = [self.popupDelegate tf_popupBackgroundTouch:self.manager popup:self];
        if (breakOpration) {
            return;
        }
    }
    if (self.popupParam.disuseBackgroundTouchHide == NO) {
        [self.manager performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark -- 代理 TFPopupDelegate 方法
-(BOOL)tf_popupWillShow:(TFPopupManager *)manager popup:(UIView *)popup{
    return NO;
}
-(BOOL)tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup{
    return NO;
}
-(BOOL)tf_popupBackgroundTouch:(TFPopupManager *)manager popup:(UIView *)popup{
    return self.popupParam.disuseBackgroundTouchHide;
}


#pragma mark -- styleInclude
static inline BOOL styleInclude(PopupStyle total,PopupStyle inc){
    return ((total & inc) == inc);
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

tf_synthesize_category_property_retain(manager, setManager);
tf_synthesize_category_property_retain(inView, setInView);
tf_synthesize_category_property_retain(popupParam, setPopupParam);
tf_synthesize_category_property_assign(popupDelegate, setPopupDelegate);
tf_synthesize_category_property_retain(backgroundView, setBackgroundView);

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
