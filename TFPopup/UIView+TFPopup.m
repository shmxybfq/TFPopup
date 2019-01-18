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
@dynamic inView,manager,popupParam,style,direction,popupAreaRect,popupSize;
@dynamic willShowBlock,willHideBlock,coverTouchBlock;

#pragma mark -- 【监听过程的block】

-(void)observerWillShowAction:(TFPopupActionBlock)willShow{self.willShowBlock = willShow;}
-(void)observerWillHideAction:(TFPopupActionBlock)willHide{self.willHideBlock = willHide;}
-(void)observerCoverTouchAction:(TFPopupActionBlock)coverTouch{self.coverTouchBlock = coverTouch;}

#pragma mark -- 【隐藏】方式
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
    
    PopupStyle style = PopupStyleNone;
    if (animated == YES) {
        if (scale) style = PopupStyleScale;
        else style = PopupStyleAlpha;
    }
    
    [self tf_showCustem:inView
             popupParam:popupParam
                  style:style
              direction:PopupDirectionCenter
              popupSize:self.bounds.size
          popupAreaRect:self.inView.bounds
               willShow:^(TFPopupManager *manager, UIView *popup) {
                   CGRect bf = manager.popBoardViewBeginFrame;
                   CGRect nf = CGRectMake(bf.origin.x + offset.x,
                                          bf.origin.y + offset.y,
                                          bf.size.width,
                                          bf.size.height);
                   manager.popBoardViewEndFrame = nf;
               } willHide:^(TFPopupManager *manager, UIView *popup) {
                   CGRect bf = manager.popBoardViewEndFrame;
                   CGRect nf = CGRectMake(bf.origin.x + offset.x,
                                          bf.origin.y + offset.y,
                                          bf.size.width,
                                          bf.size.height);
                   manager.popBoardViewBeginFrame = nf;
               } coverTouch:nil];
}

#pragma mark -- 【滑动出来动画】方式
-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction{
    [self tf_showSlide:inView direction:direction popupParam:nil];
}

-(void)tf_showSlide:(UIView *)inView
          direction:(PopupDirection)direction
         popupParam:(TFPopupParam *)popupParam{
    
    [self tf_showCustem:inView
             popupParam:popupParam
                  style:PopupStyleSlide
              direction:direction
              popupSize:self.bounds.size
          popupAreaRect:self.inView.bounds
               willShow:nil
               willHide:nil
             coverTouch:nil];
}

#pragma mark -- 【滑动出来动画】方式
-(void)tf_showFold:(UIView *)inView popupParam:(TFPopupParam *)popupParam{
    
    [self tf_showCustem:inView
             popupParam:popupParam
                  style:PopupStyleFrame
              direction:PopupDirectionFrame
              popupSize:self.bounds.size
          popupAreaRect:self.inView.bounds
               willShow:nil
               willHide:nil
             coverTouch:nil];
}

#pragma mark -- 【自定义任何动画】方式
-(void)tf_showCustem:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam
               style:(PopupStyle)style
           direction:(PopupDirection)direction
           popupSize:(CGSize)popupSize
       popupAreaRect:(CGRect)popupAreaRect
            willShow:(TFPopupActionBlock)willShow
            willHide:(TFPopupActionBlock)willHide
          coverTouch:(TFPopupActionBlock)coverTouch{
    
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
    if (self.style == PopupStyleAlpha) self.direction = PopupDirectionCenter;
    if (self.style == PopupStyleScale) self.direction = PopupDirectionCenter;
    
    self.popupSize = popupSize;
    if (CGSizeEqualToSize(popupSize, CGSizeZero))
        self.popupSize = self.bounds.size;
    
    if (CGRectEqualToRect(popupAreaRect, CGRectZero))self.popupAreaRect = self.inView.bounds;
    else self.popupAreaRect = popupAreaRect;
    
    [self observerWillShowAction:willShow];
    [self observerWillHideAction:willHide];
    [self observerCoverTouchAction:coverTouch];
    
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
            if (self.popupParam.noCoverAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationCoverAlpha;
            }
            if (self.popupParam.noPopupAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationPopBoardAlpha;
            }
        }break;
        case PopupStyleSlide:{
            ani = TFPopupDefaultAnimationPopBoardFrame;
            if (self.popupParam.noCoverAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationCoverAlpha;
            }
            if (self.popupParam.noPopupAlphaAnimation == NO) {
                ani =ani | TFPopupDefaultAnimationPopBoardAlpha;
            }
        }break;
        case PopupStyleScale:{
            if (self.popupParam.noCoverAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationCoverAlpha;
            }
            if (self.popupParam.noPopupAlphaAnimation == NO) {
                ani = ani | TFPopupDefaultAnimationPopBoardAlpha;
            }
            if (ani == TFPopupDefaultAnimationNone || ani == TFPopupDefaultAnimationCoverAlpha) {
                ani = ani | TFPopupDefaultAnimationCustem;
            }
        }break;
        case PopupStyleFrame:{
            ani = TFPopupDefaultAnimationPopBoardFrame;
            if (self.popupParam.noCoverAlphaAnimation == NO) {
                ani =ani | TFPopupDefaultAnimationCoverAlpha;
            }
            if (self.popupParam.noPopupAlphaAnimation == NO) {
                ani =ani | TFPopupDefaultAnimationPopBoardAlpha;
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
-(UIView  *)tf_popupManager_popForCoverView:(TFPopupManager *)manager{
    if (self.popupParam.noCoverView == NO) {
        UIButton *cover = [UIButton buttonWithType:UIButtonTypeCustom];
        if (self.popupParam.coverBackgroundColorClear) {
            cover.backgroundColor = [UIColor clearColor];
        }else{
            cover.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        }
        [cover addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
        return cover;
    }
    return nil;
}

/* 执行顺序:3 返回【弹出框的上层背景视图的位置,frame或者 约束,如设置了约束则frame无效 */
-(CGRect   )tf_popupManager_popForCoverViewPosition:(TFPopupManager *)manager
                                          coverView:(UIView *)coverView{
    return self.popupAreaRect;
}

/* 执行顺序:5 返回【弹出框view,动画开始时候的位置,frame或者 约束,自定义动画则忽略默认动画】 */
-(CGRect   )tf_popupManager_popBoardViewBeginPosition:(TFPopupManager *)manager
                                            boardView:(UIView *)boardView{
    CGRect fo = self.popupParam.popOriginFrame;
    CGRect ar = self.popupAreaRect;
    CGSize s = self.popupSize;
    //此位置为中心位置
    CGFloat x = (ar.size.width - s.width) * 0.5;
    CGFloat y = (ar.size.height - s.height) * 0.5;
    CGFloat w = s.width;
    CGFloat h = s.height;
    if (self.style == PopupStyleFrame) {
        return fo;
    }else if(self.style == PopupStyleSlide){
        switch (self.direction) {
            case PopupDirectionCenter:{}break;
            case PopupDirectionFromTop:{
                y = - s.height;
            }break;
            case PopupDirectionFromLeft:{
                x = - s.width;
            }break;
            case PopupDirectionFromBottom:{
                y = ar.size.height;
            }break;
            case PopupDirectionFromRight:{
                x = ar.size.width;
            }break;
            default:break;
        }
        CGRect position = CGRectMake(x, y, w, h);
        return position;
    }else{
        return CGRectMake(x, y, w, h);
    }
}

/* 执行顺序:6 返回【弹出框view,动画结束时候的位置,frame或者 约束,自定义动画则忽略默认动画】 */
-(CGRect   )tf_popupManager_popBoardViewEndPosition:(TFPopupManager *)manager
                                          boardView:(UIView *)boardView{
    CGRect ft = self.popupParam.popTargetFrame;
    CGRect ar = self.popupAreaRect;
    CGSize s = self.popupSize;
    //此位置为中心位置
    CGFloat x = (ar.size.width - s.width) * 0.5;
    CGFloat y = (ar.size.height - s.height) * 0.5;
    CGFloat w = s.width;
    CGFloat h = s.height;
    if (self.style == PopupStyleFrame) {
        return ft;
    }else if(self.style == PopupStyleSlide){
        
        switch (self.direction) {
            case PopupDirectionCenter:{}break;
            case PopupDirectionFromTop:{
                y = 0;
            }break;
            case PopupDirectionFromLeft:{
                x = 0;
            }break;
            case PopupDirectionFromBottom:{
                y = ar.size.height - s.height;
            }break;
            case PopupDirectionFromRight:{
                x = ar.size.width - s.width;
            }break;
            default:break;
        }
        CGRect position = CGRectMake(x, y, w, h);
        return position;
    }else{
        return CGRectMake(x, y, w, h);
    }
}

-(NSTimeInterval)tf_popupManager_popDefaultAnimationDuration:(TFPopupManager *)manager{
    return self.popupParam.duration;
}

-(void)coverClick:(UIButton *)ins{
    if (self.coverTouchBlock) {
        self.coverTouchBlock(self.manager, self);
    }
    if (self.popupParam.noCoverTouchHide == NO) {
        [self.manager performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:YES];
    }
}

#pragma mark 代理 TFPopupManagerDelegate 方法

/* 弹出框展示动画开始前回调 */
-(void)tf_popupManager_willShow:(TFPopupManager *)manager
                  tellToManager:(void(^)(BOOL stopDefaultAnimation,NSTimeInterval duration))tellToManager{
    //缩放
    if (self.willShowBlock) {
        self.willShowBlock(self.manager, self);
    }
    
    if (self.style == PopupStyleScale) {
        NSTimeInterval dur = self.popupParam.duration;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:@0.0];//设置起始值
        [animation setToValue:@1.0];//设置目标值
        [animation setDuration:dur];//设置动画时间，单次动画时间
        [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setAutoreverses:NO];
        [animation setFillMode:kCAFillModeBoth];
        [self.layer addAnimation:animation forKey:NSStringFromClass([self class])];
        tellToManager(NO,dur);
    }else{
        tellToManager(NO,self.popupParam.duration);
    }
}
/* 弹出框展示动画完成后回调,自定义动画不回调 */
-(void)tf_popupManager_didShow:(TFPopupManager *)manager
              defaultAnimation:(TFPopupDefaultAnimation)defaultAnimation
               isAnimationShow:(BOOL)isAnimationShow{
    
}
/* 弹出框隐藏动画开始前回调 */
-(void)tf_popupManager_willHide:(TFPopupManager *)manager
                  tellToManager:(void(^)(BOOL stopDefaultAnimation,NSTimeInterval duration))tellToManager{
    //缩放
    if (self.willHideBlock) {
        self.willHideBlock(self.manager, self);
    }
    if (self.style == PopupStyleScale) {
        NSTimeInterval dur = self.popupParam.duration;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        [animation setFromValue:@1.0];//设置起始值
        [animation setToValue:@0.0];//设置目标值
        [animation setDuration:dur];//设置动画时间，单次动画时间
        [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setAutoreverses:NO];
        [animation setFillMode:kCAFillModeBoth];
        [self.layer addAnimation:animation forKey:NSStringFromClass([self class])];
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

#ifndef tf_synthesize_category_property_block
#define tf_synthesize_category_property_block(getter,settter,TYPE)   tf_synthesize_category_property(getter,settter,OBJC_ASSOCIATION_COPY,TYPE)
#endif

tf_synthesize_category_property_retain(manager, setManager);
tf_synthesize_category_property_retain(inView, setInView);
tf_synthesize_category_property_retain(popupParam, setPopupParam);
tf_synthesize_category_property_block(willShowBlock, setWillShowBlock, TFPopupActionBlock);
tf_synthesize_category_property_block(willHideBlock, setWillHideBlock, TFPopupActionBlock);
tf_synthesize_category_property_block(coverTouchBlock, setCoverTouchBlock, TFPopupActionBlock);

-(CGSize)popupSize{
    id value = objc_getAssociatedObject(self, @selector(popupSize));
    if (value) {
        return CGSizeFromString(value);
    }
    return CGSizeZero;
}

-(void)setPopupSize:(CGSize)popupSize{
    objc_setAssociatedObject(self, @selector(popupSize), NSStringFromCGSize(popupSize), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(CGRect)popupAreaRect{
    id value = objc_getAssociatedObject(self, @selector(popupAreaRect));
    if (value) {
        return CGRectFromString(value);
    }
    return CGRectZero;
}
-(void)setPopupAreaRect:(CGRect)popupAreaRect{
    objc_setAssociatedObject(self, @selector(popupAreaRect), NSStringFromCGRect(popupAreaRect), OBJC_ASSOCIATION_COPY_NONATOMIC);
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
