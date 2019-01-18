//
//  UIView+TFPopup.h
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPopupParam.h"
#import "TFPopupManager.h"


typedef NS_ENUM(NSInteger,PopupDirection) {
    PopupDirectionCenter = 0,
    PopupDirectionFromLeft,
    PopupDirectionFromBottom,
    PopupDirectionFromRight,
    PopupDirectionFromTop,
    PopupDirectionFrame,
};

typedef NS_ENUM(NSInteger,PopupStyle) {
    PopupStyleNone = 0,
    PopupStyleAlpha,
    PopupStyleScale,
    PopupStyleSlide,
    PopupStyleFrame,
};

typedef void(^TFPopupActionBlock)(TFPopupManager *manager,UIView *popup);

@class TFPopupParam;
@interface UIView (TFPopup)<TFPopupManagerDataSource,TFPopupManagerDelegate>

@property(nonatomic,strong)UIView *inView;
@property(nonatomic,strong)TFPopupManager *manager;

@property(nonatomic,strong)TFPopupParam *popupParam;
@property(nonatomic,assign)PopupStyle style;
@property(nonatomic,assign)PopupDirection direction;
@property(nonatomic,assign)CGRect popupAreaRect;
@property(nonatomic,assign)CGSize popupSize;
@property(nonatomic,  copy)TFPopupActionBlock willShowBlock;
@property(nonatomic,  copy)TFPopupActionBlock willHideBlock;
@property(nonatomic,  copy)TFPopupActionBlock coverTouchBlock;


-(void)observerWillShowAction:(TFPopupActionBlock)willShow;
-(void)observerWillHideAction:(TFPopupActionBlock)willHide;
-(void)observerCoverTouchAction:(TFPopupActionBlock)coverTouch;


#pragma mark -- 【无动画弹出,透明度动画弹出】方式
-(void)tf_show:(UIView *)inView animated:(BOOL)animated;

-(void)tf_show:(UIView *)inView offset:(CGPoint)offset animated:(BOOL)animated;

-(void)tf_show:(UIView *)inView
        offset:(CGPoint)offset
    popupParam:(TFPopupParam *)popupParam
      animated:(BOOL)animated;

#pragma mark -- 【缩放动画弹出】方式
-(void)tf_showScale:(UIView *)inView;

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset;

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset popupParam:(TFPopupParam *)popupParam;


#pragma mark -- 【滑动出来动画】方式
-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction;

-(void)tf_showSlide:(UIView *)inView
          direction:(PopupDirection)direction
         popupParam:(TFPopupParam *)popupParam;

#pragma mark -- 【滑动出来动画】方式
-(void)tf_showFold:(UIView *)inView popupParam:(TFPopupParam *)popupParam;

#pragma mark -- 【自定义任何动画】方式
-(void)tf_showCustem:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam
               style:(PopupStyle)style
           direction:(PopupDirection)direction
           popupSize:(CGSize)popupSize
       popupAreaRect:(CGRect)popupAreaRect
            willShow:(TFPopupActionBlock)willShow
            willHide:(TFPopupActionBlock)willHide
          coverTouch:(TFPopupActionBlock)coverTouch;

@end

