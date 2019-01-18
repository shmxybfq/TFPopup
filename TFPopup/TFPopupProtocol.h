//
//  TFPopupProtocol.h
//  TFPopupDemo
//
//  Created by Time on 2019/1/15.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, TFPopupDefaultAnimation) {
    TFPopupDefaultAnimationNone    = 0,
    TFPopupDefaultAnimationCoverAlpha   = 1 << 0,
    TFPopupDefaultAnimationPopBoardAlpha   = 1 << 1,
    TFPopupDefaultAnimationPopBoardFrame   = 1 << 2,
    TFPopupDefaultAnimationCustem      = 1 << 3,
};



@class TFPopupManager;

@protocol TFPopupManagerDataSource<NSObject>

@required;
/* 执行顺序:0 返回【默认使用的动画方式,可叠加】 */
-(TFPopupDefaultAnimation)tf_popupManager_popDefaultAnimation:(TFPopupManager *)manager;
/* 执行顺序:1 返回【弹框的父视图】 */
-(UIView  *)tf_popupManager_popForView:(TFPopupManager *)manager;
/* 执行顺序:4 返回【弹出框view】 */
-(UIView  *)tf_popupManager_popBoardView:(TFPopupManager *)manager;

@optional;
/* 执行顺序:2 返回【弹出框的上层背景视图,默认动画alpha=0,弹出时动画为alpha=1,自定义动画则忽略默认动画 */
-(UIView  *)tf_popupManager_popForCoverView:(TFPopupManager *)manager;
/* 执行顺序:3 返回【弹出框的上层背景视图的位置,frame或者 约束,如设置了约束则frame无效 */
-(CGRect   )tf_popupManager_popForCoverViewPosition:(TFPopupManager *)manager
                                          coverView:(UIView *)coverView;


/* 执行顺序:5 返回【弹出框view,动画开始时候的位置,frame或者 约束,自定义动画则忽略默认动画】 */
-(CGRect   )tf_popupManager_popBoardViewBeginPosition:(TFPopupManager *)manager
                                            boardView:(UIView *)boardView;
/* 执行顺序:6 返回【弹出框view,动画结束时候的位置,frame或者 约束,自定义动画则忽略默认动画】 */
-(CGRect   )tf_popupManager_popBoardViewEndPosition:(TFPopupManager *)manager
                                          boardView:(UIView *)boardView;


/* 执行顺序:7 返回【弹出框的子视图个数,子视图将被直接addSubview到boardView】 */
-(NSInteger)tf_popupManager_popBoardItemCount:(TFPopupManager *)manager;
/* 执行顺序:8 返回【弹出框的子视图,子视图将被直接addSubview到boardView】 */
-(UIView  *)tf_popupManager_popBoardItemView:(TFPopupManager *)manager
                                       index:(NSInteger)index;
/* 执行顺序:9 返回【弹出框的子视图位置,frame或者 约束,如设置了约束则frame无效】 */
-(CGRect   )tf_popupManager_popBoardItemPersition:(TFPopupManager *)manager
                                         itemView:(UIView *)itemView
                                            index:(NSInteger)index;

/* 执行顺序:10 返回【动画时间,默认0.3s,自定义动画则忽略默认动画】 */
-(NSTimeInterval)tf_popupManager_popDefaultAnimationDuration:(TFPopupManager *)manager;

@end

@protocol TFPopupManagerDelegate<NSObject>

@optional;

/* 弹出框展示动画开始前回调 */
-(void)tf_popupManager_willShow:(TFPopupManager *)manager
                  tellToManager:(void(^)(BOOL stopDefaultAnimation,NSTimeInterval duration))tellToManager;

/* 弹出框展示动画完成后回调,自定义动画不回调 */
-(void)tf_popupManager_didShow:(TFPopupManager *)manager
              defaultAnimation:(TFPopupDefaultAnimation)defaultAnimation
               isAnimationShow:(BOOL)isAnimationShow;

/* 弹出框隐藏动画开始前回调 */
-(void)tf_popupManager_willHide:(TFPopupManager *)manager
                  tellToManager:(void(^)(BOOL stopDefaultAnimation,NSTimeInterval duration))tellToManager;;

/* 弹出框隐藏动画完成后回调,自定义动画不回调 */
-(void)tf_popupManager_didHide:(TFPopupManager *)manager
              defaultAnimation:(TFPopupDefaultAnimation)defaultAnimation
               isAnimationHide:(BOOL)isAnimationHide;

@end

@interface TFPopupProtocol : NSObject

@end

