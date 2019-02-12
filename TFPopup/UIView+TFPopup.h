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

-(void)tf_showNormal:(UIView *)inView animated:(BOOL)animated;
-(void)tf_showNormal:(UIView *)inView offset:(CGPoint)offset animated:(BOOL)animated;
-(void)tf_showNormal:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam;

-(void)tf_showScale:(UIView *)inView;
-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset;
-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset popupParam:(TFPopupParam *)popupParam;

-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction;
-(void)tf_showSlide:(UIView *)inView
          direction:(PopupDirection)direction
         popupParam:(TFPopupParam *)popupParam;


-(void)tf_showBubble:(UIView *)inView
           basePoint:(CGPoint)basePoint
     bubbleDirection:(PopupDirection)bubbleDirection
          popupParam:(TFPopupParam *)popupParam;

-(void)tf_showFrame:(UIView *)inView
               from:(CGRect)from
                 to:(CGRect)to
         popupParam:(TFPopupParam *)popupParam;


-(void)tf_showMask:(UIView *)inView
        popupParam:(TFPopupParam *)popupParam;

@end

