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
-(void)tf_show:(UIView *)inView animated:(BOOL)animated{
    [self tf_showAtPosition:inView offset:CGPointZero popupParam:nil scale:NO animated:animated];
}

-(void)tf_show:(UIView *)inView offset:(CGPoint)offset animated:(BOOL)animated{
    [self tf_showAtPosition:inView offset:offset popupParam:nil scale:NO animated:animated];
}

-(void)tf_show:(UIView *)inView
        offset:(CGPoint)offset
    popupParam:(TFPopupParam *)popupParam
      animated:(BOOL)animated{
    [self tf_showAtPosition:inView offset:offset popupParam:popupParam scale:NO animated:animated];
}

#pragma mark -- 【缩放动画弹出】方式
-(void)tf_showScale:(UIView *)inView{
    [self tf_showAtPosition:inView offset:CGPointZero popupParam:nil scale:YES animated:YES];
}

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset{
    [self tf_showAtPosition:inView offset:offset popupParam:nil scale:YES animated:YES];
}

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset popupParam:(TFPopupParam *)popupParam{
    [self tf_showAtPosition:inView offset:offset popupParam:popupParam scale:YES animated:YES];
}

#pragma mark -- 【固定位置动画弹出:无动画,透明度动画,缩放动画】方式
-(void)tf_showAtPosition:(UIView *)inView
                  offset:(CGPoint)offset
              popupParam:(TFPopupParam *)popupParam
                   scale:(BOOL)scale
                animated:(BOOL)animated{
    
    self.popupParam.offset = offset;
    
    PopupStyle style = PopupStyleNone;
    if (animated == YES) {
        if(scale){
            style = PopupStyleScale;
            popupParam.showKeyPath = @"transform.scale";
            popupParam.showFromValue = @(0.0);
            popupParam.showToValue = @(1.0);
            popupParam.hideKeyPath = @"transform.scale";
            popupParam.hideFromValue = @(1.0);
            popupParam.hideToValue = @(0.0);
        }else{
            style = PopupStyleAlpha;
        }
    }
    
    [self tf_showCustemAll:inView
                popupParam:popupParam
                     style:style
                 direction:PopupDirectionContainerCenter
                 popupSize:self.bounds.size
                  delegate:self.popupDelegate?:self];
}

#pragma mark -- 【滑动出来动画】方式
-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction{
    [self tf_showSlide:inView direction:direction popupParam:nil];
}

-(void)tf_showSlide:(UIView *)inView
          direction:(PopupDirection)direction
         popupParam:(TFPopupParam *)popupParam{
    
    [self tf_showCustemAll:inView
                popupParam:popupParam
                     style:PopupStyleSlide
                 direction:direction
                 popupSize:self.bounds.size
                  delegate:self.popupDelegate?:self];
}

#pragma mark -- 【形变出来动画】方式
-(void)tf_showFrame:(UIView *)inView popupParam:(TFPopupParam *)popupParam{
    
    [self tf_showCustemAll:inView
                popupParam:popupParam
                     style:PopupStyleFrame
                 direction:PopupDirectionFrame
                 popupSize:self.bounds.size
                  delegate:self.popupDelegate?:self];
}

-(void)tf_showFrame:(UIView *)inView
          basePoint:(CGPoint)basePoint
    bubbleDirection:(PopupDirection)bubbleDirection
         popupParam:(TFPopupParam *)popupParam{
    
    popupParam.basePoint = basePoint;
    popupParam.bubbleDirection = bubbleDirection;
    
    [self tf_showCustemAll:inView
                popupParam:popupParam
                     style:PopupStyleFrame
                 direction:PopupDirectionFrame
                 popupSize:self.bounds.size
                  delegate:self.popupDelegate?:self];
}

#pragma mark -- 【遮罩动画】方式
-(void)tf_showMask:(UIView *)inView popupParam:(TFPopupParam *)popupParam{
    [self tf_showCustemAll:inView
                popupParam:popupParam
                     style:PopupStyleMask
                 direction:PopupDirectionContainerCenter
                 popupSize:self.bounds.size
                  delegate:self.popupDelegate?:self];
}

#pragma mark -- 【自定义动画】方式
-(void)tf_showCustemAnimation:(UIView *)inView
                       offset:(CGPoint)offset
                   popupParam:(TFPopupParam *)popupParam{
    
    [self tf_showCustemAll:inView
                popupParam:popupParam
                     style:PopupStyleAlpha
                 direction:PopupDirectionContainerCenter
                 popupSize:self.bounds.size
                  delegate:self.popupDelegate?:self];
}

-(void)tf_showCustemAll:(UIView *)inView
             popupParam:(TFPopupParam *)popupParam
                  style:(PopupStyle)style
              direction:(PopupDirection)direction
              popupSize:(CGSize)popupSize
               delegate:(id<TFPopupDelegate>)delegate{
    
    if (inView == nil) {NSLog(@"****** %@ %@ ******",[self class],@"inView 不能为空！");return;}
    self.inView = inView;
    
    if (self.manager == nil) {
        self.manager = [TFPopupManager tf_popupManagerDataSource:self delegate:self];
    }
    
    self.popupParam = popupParam;
    if (self.popupParam == nil) self.popupParam = [[TFPopupParam alloc]init];
    if (self.popupParam.duration == 0) self.popupParam.duration = 0.3;
    if (self.popupParam.autoDissmissDuration != 0) {
        [self.manager performSelector:@selector(hide)
                           withObject:nil
                           afterDelay:self.popupParam.autoDissmissDuration];
    }
    
    
    self.style = style;
    self.direction = direction;
    if (self.style == PopupStyleAlpha) self.direction = PopupDirectionContainerCenter;
    if (self.style == PopupStyleScale) self.direction = PopupDirectionContainerCenter;
    if (self.style == PopupStyleMask) {
        self.direction = PopupDirectionContainerCenter;
        if (self.popupParam.maskShowFromPath == nil || self.popupParam.maskShowToPath == nil) {
            return;
        }
    }
    
    if (CGSizeEqualToSize(self.popupParam.popupSize, CGSizeZero))
        self.popupParam.popupSize = self.bounds.size;
    
    if (CGRectEqualToRect(self.popupParam.popupAreaRect, CGRectZero)) {
        self.popupParam.popupAreaRect = self.inView.bounds;
    }
    
    self.popupDelegate = delegate;
    
    [self.manager performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    [self.manager performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

#pragma mark 代理 TFPopupManagerDataSource 方法
/* 执行顺序:0 返回【默认使用的动画方式,可叠加】 */
-(TFPopupDefaultAnimation)tf_popupManager_popDefaultAnimation:(TFPopupManager *)manager{
    TFPopupDefaultAnimation ani = TFPopupDefaultAnimationNone;
    switch (self.style) {
        case PopupStyleNone:{
            ani = TFPopupDefaultAnimationNone;
        }break;
        case PopupStyleAlpha:{
            if (self.popupParam.disuseBackgroundAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationBackgroundAlpha;
            }
            if (self.popupParam.disusePopupAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationPopBoardAlpha;
            }
        }break;
        case PopupStyleSlide:{
            ani = TFPopupDefaultAnimationPopBoardFrame;
            if (self.popupParam.disuseBackgroundAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationBackgroundAlpha;
            }
            if (self.popupParam.disusePopupAlphaAnimation == NO) {
                ani =ani | TFPopupDefaultAnimationPopBoardAlpha;
            }
        }break;
        case PopupStyleScale:{
            if (self.popupParam.disuseBackgroundAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationBackgroundAlpha;
            }
            if (self.popupParam.disusePopupAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationPopBoardAlpha;
            }
            if (ani == TFPopupDefaultAnimationNone || ani == TFPopupDefaultAnimationBackgroundAlpha) {
                ani = ani | TFPopupDefaultAnimationCustem;
            }
        }break;
        case PopupStyleFrame:{
            ani = TFPopupDefaultAnimationPopBoardFrame;
            if (self.popupParam.disuseBackgroundAlphaAnimation == NO) {
                ani =ani | TFPopupDefaultAnimationBackgroundAlpha;
            }
            if (self.popupParam.disusePopupAlphaAnimation == NO) {
                ani =ani | TFPopupDefaultAnimationPopBoardAlpha;
            }
        }break;
        case PopupStyleMask:{
            if (self.popupParam.disuseBackgroundAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationBackgroundAlpha;
            }
            if (self.popupParam.disusePopupAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationPopBoardAlpha;
            }
            if (ani == TFPopupDefaultAnimationNone || ani == TFPopupDefaultAnimationBackgroundAlpha) {
                ani = ani | TFPopupDefaultAnimationCustem;
            }
        }break;
        default:break;
    }
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
        UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([self.popupDelegate respondsToSelector:@selector(tf_popupCustemBackgroundView:popup:)]) {
            self.backgroundView = [self.popupDelegate tf_popupCustemBackgroundView:self.manager popup:self];
            cover = (UIButton *)self.backgroundView;
        }
        if (self.popupParam.backgroundColorClear) {
            cover.backgroundColor = [UIColor clearColor];
        }else{
            cover.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        }
        
        if ([cover respondsToSelector:@selector(addTarget:action:forControlEvents:)]) {
            [cover addTarget:self
                      action:@selector(coverClick:)
            forControlEvents:UIControlEventTouchUpInside];
        }else{
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]init];
            [tapGes addTarget:self action:@selector(coverTap:)];
            [cover addGestureRecognizer:tapGes];
        }
        return cover;
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
    
    if (self.popupParam.keepPopupOriginFrame)return self.frame;
    
    if (self.style == PopupStyleFrame) {
        //frame优先
        if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero) == NO)
        return self.popupParam.popOriginFrame;
        
        CGPoint os = self.popupParam.offset;
        CGPoint bp = self.popupParam.basePoint;
        CGFloat x = 0,y = 0;
        switch (self.popupParam.bubbleDirection) {
            case PopupDirectionTop:
            case PopupDirectionTopRight:
            case PopupDirectionRight:
            case PopupDirectionRightBottom:
            case PopupDirectionBottom:
            case PopupDirectionBottomLeft:
            case PopupDirectionLeft:
            case PopupDirectionLeftTop:{
                x = bp.x + os.x;
                y = bp.y + os.y;
            }break;
            default:break;
        }
        return CGRectMake(x, y, 0, 0);
        
    }else if(self.style == PopupStyleSlide){
        CGRect ar = self.popupParam.popupAreaRect;
        CGSize s = self.popupParam.popupSize;
        CGFloat x = (ar.size.width - s.width) * 0.5;
        CGFloat y = (ar.size.height - s.height) * 0.5;
        CGFloat w = s.width;
        CGFloat h = s.height;
        switch (self.direction) {
            case PopupDirectionContainerCenter:{}break;
            case PopupDirectionTop:{y = - s.height;}break;
            case PopupDirectionLeft:{x = - s.width;}break;
            case PopupDirectionBottom:{y = ar.size.height;}break;
            case PopupDirectionRight:{x = ar.size.width;}break;
            default:break;
        }
        CGRect position = CGRectMake(x, y, w, h);
        return position;
    }else{
        //此位置为中心位置
        CGRect ar = self.popupParam.popupAreaRect;
        CGSize s = self.popupParam.popupSize;
        CGFloat x = (ar.size.width - s.width) * 0.5;
        CGFloat y = (ar.size.height - s.height) * 0.5;
        CGFloat w = s.width;
        CGFloat h = s.height;
        return CGRectMake(x, y, w, h);
    }
}

/* 执行顺序:6 返回【弹出框view,动画结束时候的位置,frame或者 约束,自定义动画则忽略默认动画】 */
-(CGRect   )tf_popupManager_popBoardViewEndPosition:(TFPopupManager *)manager
                                          boardView:(UIView *)boardView{
    
    if (self.popupParam.keepPopupOriginFrame)return self.frame;
    
    
    
    if (self.style == PopupStyleFrame) {
        //frame优先
        if (CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero) == NO)
            return self.popupParam.popTargetFrame;
        
        CGPoint os = self.popupParam.offset;
        CGPoint bp = self.popupParam.basePoint;
        CGSize  ps = self.popupParam.popupSize;
        CGFloat x = 0,y = 0,w = ps.width,h = ps.height;
        CGFloat halfw = ps.width * 0.5,halfh = ps.height * 0.5;
        switch (self.popupParam.bubbleDirection) {
            case PopupDirectionTop:{
                x = (bp.x - halfw) + os.x;
                y = (bp.y - h) + os.y;
            }break;
            case PopupDirectionTopRight:{
                x = bp.x + os.x;
                y = (bp.y - h) + os.y;
            }break;
            case PopupDirectionRight:{
                x = bp.x + os.x;
                y = (bp.y - halfh) + os.y;
            }break;
            case PopupDirectionRightBottom:{
                x = bp.x + os.x;
                y = bp.y + os.y;
            }break;
            case PopupDirectionBottom:{
                x = (bp.x - halfw) + os.x;
                y = bp.y + os.y;
            }break;
            case PopupDirectionBottomLeft:{
                x = (bp.x - w) + os.x;
                y = bp.y + os.y;
            }break;
            case PopupDirectionLeft:{
                x = (bp.x - w) + os.x;
                y = (bp.y - halfh) + os.y;
            }break;
            case PopupDirectionLeftTop:{
                x = (bp.x - w) + os.x;
                y = (bp.y - h) + os.y;
            }break;
            default:break;
        }
        return CGRectMake(x, y, w, h);
        
        
    }else if(self.style == PopupStyleSlide){
        CGRect ar = self.popupParam.popupAreaRect;
        CGSize s = self.popupParam.popupSize;
        CGFloat x = (ar.size.width - s.width) * 0.5;
        CGFloat y = (ar.size.height - s.height) * 0.5;
        CGFloat w = s.width;
        CGFloat h = s.height;
        switch (self.direction) {
            case PopupDirectionContainerCenter:{}break;
            case PopupDirectionTop:{
                y = 0;
            }break;
            case PopupDirectionLeft:{
                x = 0;
            }break;
            case PopupDirectionBottom:{
                y = ar.size.height - s.height;
            }break;
            case PopupDirectionRight:{
                x = ar.size.width - s.width;
            }break;
            default:break;
        }
        CGRect position = CGRectMake(x, y, w, h);
        return position;
    }else{
        //此位置为中心位置
        CGRect ar = self.popupParam.popupAreaRect;
        CGSize s = self.popupParam.popupSize;
        CGFloat x = (ar.size.width - s.width) * 0.5;
        CGFloat y = (ar.size.height - s.height) * 0.5;
        CGFloat w = s.width;
        CGFloat h = s.height;
        return CGRectMake(x, y, w, h);
    }
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
    //缩放
    if (self.style == PopupStyleScale ||
        self.style == PopupStyleAlpha) {
        CAAnimation *animation = [self animation:self.popupParam.showKeyPath
                                            from:self.popupParam.showFromValue
                                              to:self.popupParam.showToValue
                                             dur:self.popupParam.duration];
        if (animation)
        [self.layer addAnimation:animation forKey:NSStringFromClass([self class])];
        tellToManager(NO,self.popupParam.duration);
        //遮罩
    }else if (self.style == PopupStyleMask) {
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
        tellToManager(NO,dur);
    }else{
        tellToManager(NO,self.popupParam.duration);
    }
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
    
    //缩放
    if (self.style == PopupStyleScale ||
        self.style == PopupStyleAlpha) {
        CAAnimation *animation = [self animation:self.popupParam.hideKeyPath
                                            from:self.popupParam.hideFromValue
                                              to:self.popupParam.hideToValue
                                             dur:self.popupParam.duration];
        if (animation)
        [self.layer addAnimation:animation forKey:NSStringFromClass([self class])];
        tellToManager(NO,self.popupParam.duration);
        //遮罩
    }else if (self.style == PopupStyleMask) {
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
        tellToManager(NO,dur);
    }else{
        tellToManager(NO,self.popupParam.duration);
    }
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
    if ((self.style == PopupStyleNone ||
         self.style == PopupStyleAlpha ||
         self.style == PopupStyleScale ||
         self.style == PopupStyleMask) &&
        CGPointEqualToPoint(self.popupParam.offset, CGPointZero) == NO) {
        CGPoint offset = self.popupParam.offset;
        CGRect bf = manager.popBoardViewBeginFrame;
        CGRect nf = CGRectMake(bf.origin.x + offset.x,
                               bf.origin.y + offset.y,
                               bf.size.width,
                               bf.size.height);
        manager.popBoardViewEndFrame = nf;
    }
    return NO;
}
-(BOOL)tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup{
    if ((self.style == PopupStyleNone ||
         self.style == PopupStyleAlpha ||
         self.style == PopupStyleScale ||
         self.style == PopupStyleMask) &&
        CGPointEqualToPoint(self.popupParam.offset, CGPointZero) == NO) {
        CGPoint offset = self.popupParam.offset;
        CGRect bf = manager.popBoardViewEndFrame;
        CGRect nf = CGRectMake(bf.origin.x + offset.x,
                               bf.origin.y + offset.y,
                               bf.size.width,
                               bf.size.height);
        manager.popBoardViewBeginFrame = nf;
    }
    return NO;
}
-(BOOL)tf_popupBackgroundTouch:(TFPopupManager *)manager popup:(UIView *)popup{
    return self.popupParam.disuseBackgroundTouchHide;
}


#pragma mark 属性绑定函数

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
