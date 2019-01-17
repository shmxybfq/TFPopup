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
@dynamic inView,manager,popupParam,style,position,popupAreaRect,popupSize;

tf_synthesize_category_property_retain(manager, setManager);
tf_synthesize_category_property_retain(inView, setInView);
tf_synthesize_category_property_retain(popupParam, setPopupParam);

-(void)tf_show:(UIView *)inView
    popupParam:(TFPopupParam *)popupParam
         style:(PopupStyle)style
      position:(PopupPosition)position
 popupAreaRect:(CGRect)popupAreaRect
      willShow:(TFPopupBlock)willShow{
    
    if (inView == nil) {NSLog(@"****** %@ %@ ******",[self class],@"inView 不能为空！");return;}
    if (self.manager == nil) {
        self.manager = [TFPopupManager tf_popupManagerDataSource:self delegate:self];
    }
    
    self.inView = inView;
    
    self.popupParam = popupParam;
    self.style = style;
    self.position = position;
    if (self.style == PopupStyleAlpha) self.position = PopupPositionCenter;
    if (self.style == PopupStyleScale) self.position = PopupPositionCenter;
    
    if (CGRectEqualToRect(popupAreaRect, CGRectZero))self.popupAreaRect = self.inView.bounds;
    else self.popupAreaRect = popupAreaRect;
    
    if (CGSizeEqualToSize(popupParam.popupSize, CGSizeZero))self.popupSize = self.bounds.size;
    else self.popupSize = popupParam.popupSize;
    
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
        case PopupStyleFold:{
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
        cover.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:0.3];
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
    CGRect fo = self.popupParam.foldOriginFrame;
    CGRect ar = self.popupAreaRect;
    CGSize s = self.popupSize;
    
    //此位置为中心位置
    CGFloat x = (ar.size.width - s.width) * 0.5;
    CGFloat y = (ar.size.height - s.height) * 0.5;
    CGFloat w = s.width;
    CGFloat h = s.height;
    
    if (self.style == PopupStyleFold) {
        return fo;
    }else if(self.style == PopupStyleSlide){
        switch (self.position) {
            case PopupPositionCenter:{}break;
            case PopupPositionFromTop:{
                y = - s.height;
            }break;
            case PopupPositionFromLeft:{
                x = - s.width;
            }break;
            case PopupPositionFromBottom:{
                y = ar.size.height;
            }break;
            case PopupPositionFromRight:{
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
    CGRect ft = self.popupParam.foldTargetFrame;
    CGRect ar = self.popupAreaRect;
    CGSize s = self.popupSize;
    
    //此位置为中心位置
    CGFloat x = (ar.size.width - s.width) * 0.5;
    CGFloat y = (ar.size.height - s.height) * 0.5;
    CGFloat w = s.width;
    CGFloat h = s.height;
    
    if (self.style == PopupStyleFold) {
        return ft;
    }else if(self.style == PopupStyleSlide){
       
        switch (self.position) {
            case PopupPositionCenter:{}break;
            case PopupPositionFromTop:{
                y = 0;
            }break;
            case PopupPositionFromLeft:{
                x = 0;
            }break;
            case PopupPositionFromBottom:{
                y = ar.size.height - s.height;
            }break;
            case PopupPositionFromRight:{
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
    [self.manager performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:YES];
}

#pragma mark 代理 TFPopupManagerDelegate 方法

/* 弹出框展示动画开始前回调 */
-(BOOL)tf_popupManager_willShow:(TFPopupManager *)manager
                  tellToManager:(void(^)(BOOL stopDefaultAnimation,NSTimeInterval duration))tellToManager{
    //缩放
    NSTimeInterval dur = 0.3;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    [animation setFromValue:@0.0];//设置起始值
    [animation setToValue:@1.0];//设置目标值
    [animation setDuration:dur];//设置动画时间，单次动画时间
    [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setAutoreverses:NO];
    [animation setFillMode:kCAFillModeBoth];
    [self.layer addAnimation:animation forKey:NSStringFromClass([self class])];
    tellToManager(NO,dur);
    return NO;
}
/* 弹出框展示动画完成后回调,自定义动画不回调 */
/* 弹出框隐藏动画完成后回调,自定义动画不回调 */
-(void)tf_popupManager_didShow:(TFPopupManager *)manager
              defaultAnimation:(TFPopupDefaultAnimation)defaultAnimation
               isAnimationShow:(BOOL)isAnimationShow{
    
}
/* 弹出框隐藏动画开始前回调 */
-(BOOL)tf_popupManager_willHide:(TFPopupManager *)manager
                  tellToManager:(void(^)(BOOL stopDefaultAnimation,NSTimeInterval duration))tellToManager{
    //缩放
    NSTimeInterval dur = 0.3;
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
    return NO;
}

/* 弹出框隐藏动画完成后回调,自定义动画不回调 */
-(void)tf_popupManager_didHide:(TFPopupManager *)manager
              defaultAnimation:(TFPopupDefaultAnimation)defaultAnimation
               isAnimationHide:(BOOL)isAnimationHide{
    
}


#pragma mark 属性绑定函数
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

-(PopupPosition)position{
    id value = objc_getAssociatedObject(self, @selector(position));
    if (value) {
        return [value integerValue];
    }
    return 0;
}
-(void)setPosition:(PopupPosition)position{
    objc_setAssociatedObject(self, @selector(position), @(position), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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


@implementation TFPopupParam



@end
