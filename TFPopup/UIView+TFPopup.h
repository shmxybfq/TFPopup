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
    PopupStyleMask,
};


@protocol TFPopupDelegate<NSObject>
@optional;
-(UIView *)tf_popupCustemBackgroundView:(TFPopupManager *)manager popup:(UIView *)popup;
-(BOOL    )tf_popupWillShow:(TFPopupManager *)manager popup:(UIView *)popup;
-(BOOL    )tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup;
-(BOOL    )tf_popupBackgroundTouch:(TFPopupManager *)manager popup:(UIView *)popup;
@end

@interface UIView (TFPopup)<TFPopupDelegate,TFPopupManagerDataSource,TFPopupManagerDelegate>

@property(nonatomic,strong)UIView *inView;
@property(nonatomic,strong)TFPopupManager *manager;
@property(nonatomic,assign)id<TFPopupDelegate>popupDelegate;

@property(nonatomic,strong)TFPopupParam *popupParam;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,assign)PopupStyle style;
@property(nonatomic,assign)PopupDirection direction;

-(void)tf_hide;

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

//#pragma mark -- 【缩放动画弹出】方式
//-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset popupParam:(TFPopupParam *)popupParam;

#pragma mark -- 【滑动出来动画】方式

-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction;

-(void)tf_showSlide:(UIView *)inView
          direction:(PopupDirection)direction
         popupParam:(TFPopupParam *)popupParam;

#pragma mark -- 【形变出来动画】方式
-(void)tf_showFrame:(UIView *)inView popupParam:(TFPopupParam *)popupParam;

#pragma mark -- 【遮罩动画】方式
-(void)tf_showMask:(UIView *)inView popupParam:(TFPopupParam *)popupParam;


#pragma mark -- 【自定义动画】方式
-(void)tf_showCustemAnimation:(UIView *)inView
                  offset:(CGPoint)offset
              popupParam:(TFPopupParam *)popupParam;

-(void)tf_showCustemAll:(UIView *)inView
             popupParam:(TFPopupParam *)popupParam
                  style:(PopupStyle)style
              direction:(PopupDirection)direction
              popupSize:(CGSize)popupSize
               delegate:(id<TFPopupDelegate>)delegate;

@end

