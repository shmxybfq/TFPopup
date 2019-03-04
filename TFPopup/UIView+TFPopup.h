//
//  UIView+TFPopup.h
//  TFPopupDemo
//
//  Created by ztf on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPopupParam.h"
#import "TFPopupExtension.h"

@protocol TFPopupDataSource<NSObject>
@required;
- (UIView *)tf_popupInView:(UIView *)popup;

- (CGSize  )tf_popupInArea:(UIView *)popup;

- (BOOL    )tf_popupView:(UIView *)popup animationWithAlphaForState:(TFPopupState)state;
- (CGFloat )tf_popupView:(UIView *)popup fromAlphaForState:(TFPopupState)state;
- (CGFloat )tf_popupView:(UIView *)popup toAlphaForState:(TFPopupState)state;

- (BOOL    )tf_popupView:(UIView *)popup animationWithFrameForState:(TFPopupState)state;
- (CGRect  )tf_popupView:(UIView *)popup fromFrameForState:(TFPopupState)state;
- (CGRect  )tf_popupView:(UIView *)popup toFrameForState:(TFPopupState)state;

@end

// 自定义动画代理,弹出框模式实现了此代理，并且代理对象为本身。通过以下代理的设置，为弹框设置了动画。
@protocol TFPopupDelegate<NSObject>

@optional;

- (NSTimeInterval)tf_popupView:(UIView *)popup animationDurationForState:(TFPopupState)state;
- (NSTimeInterval)tf_popupView:(UIView *)popup animationDelayForState:(TFPopupState)state;
- (UIViewAnimationOptions)tf_popupView:(UIView *)popup animationOptionsForState:(TFPopupState)state;

- (BOOL)tf_popupView:(UIView *)popup willShowStopAnimationForPopupStyle:(PopupStyle)style;

- (BOOL)tf_popupView:(UIView *)popup willHideStopAnimationForPopupStyle:(PopupStyle)style;

//- (BOOL)tf_popupView:(UIView *)popup
//     touchBackground:(UIView *)backgroundView
//               index:(NSInteger)index;

@end



@interface UIView (TFPopup)<TFPopupDataSource,TFPopupDelegate>

@property(nonatomic,strong)UIView *inView;//弹框的容器视图
@property(nonatomic,strong)TFPopupExtension *extension;

@property(nonatomic,assign)id<TFPopupDelegate>popupDelegate;//自定义动画代理
@property(nonatomic,assign)id<TFPopupDataSource>popupDataSource;

@property(nonatomic,strong)TFPopupParam *popupParam;//默认动画参数
@property(nonatomic,assign)PopupStyle style;//默认动画类型
@property(nonatomic,assign)PopupDirection direction;//默认动画方向，仅在滑动动画和泡泡动画下有效


-(void)tf_hide;//手动控制弹框消失

/* 基本动画，位置固定，可设置无任何动画弹出和渐隐方式
 * inView 容器视图
 * animated YES为渐隐动画NO为无任何动画
 * offset 弹框基于默认的便宜y正数为向下便宜，y负数为向上便宜，x值同理
 * popupParam 弹出的更多参数设置，具体参照TFPopupParam类 */
-(void)tf_showNormal:(UIView *)inView animated:(BOOL)animated;
-(void)tf_showNormal:(UIView *)inView offset:(CGPoint)offset animated:(BOOL)animated;
-(void)tf_showNormal:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam;


/* 缩放动画，位置固定
 * inView 容器视图
 * offset 弹框基于默认的便宜y正数为向下便宜，y负数为向上便宜，x值同理
 * popupParam 弹出的更多参数设置，具体参照TFPopupParam类 */
-(void)tf_showScale:(UIView *)inView;
-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset;
-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset popupParam:(TFPopupParam *)popupParam;


/* 滑动动画，初始位置->目标位置
 * inView 容器视图
 * direction 弹出方向，如设置此参数则弹出动画会根据popupParam.popupSize参数计算出弹出方向和位置。示例：设direction=PopupDirectionTop，popupParam.popupSize=CGSizeMake(300, 200)弹框会从容器视图顶部向下弹出，水平居中，垂直方向弹框盖于顶部并显示完全。也可以通过设置popupParam.offset设置弹框基于默认计算位置的偏移，也可以设置popupParam.popupAreaRect改变默认计算区域。direction只支持上下左右四个方向弹出。
 * 如不设置direction值，可以设置popupParam.popOriginFrame&popupParam.popTargetFrame自由控制弹框的初始frame和最终frame
 * popupParam 弹出的更多参数设置，具体参照TFPopupParam类 */
-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction;
-(void)tf_showSlide:(UIView *)inView
          direction:(PopupDirection)direction
         popupParam:(TFPopupParam *)popupParam;


/* 泡泡动画，基于point&bubbleDirection -> 展开弹框
 * inView 容器视图
 * basePoint 基础点，泡泡基于哪个位置做弹出，
 * direction 弹出方向，支持上，右上，右，右下，下，下左，左，左上八个方向，可结合popupParam.offset设置弹框的偏移
 * popupParam 弹出的更多参数设置，具体参照TFPopupParam类 */
-(void)tf_showBubble:(UIView *)inView
           basePoint:(CGPoint)basePoint
     bubbleDirection:(PopupDirection)bubbleDirection
          popupParam:(TFPopupParam *)popupParam;


/* 形变动画，初始frame -> 目标frame
 * inView 容器视图
 * from 初始frame
 * to 目标frame
 * popupParam 弹出的更多参数设置，具体参照TFPopupParam类 */
-(void)tf_showFrame:(UIView *)inView
               from:(CGRect)from
                 to:(CGRect)to
         popupParam:(TFPopupParam *)popupParam;


/* 遮罩动画，位置固定，由mask执行动画
 * inView 容器视图
 * 必须参数：popupParam.maskShowFromPath,popupParam.maskShowToPath,popupParam.maskHideFromPath,popupParam.maskHideToPath四个参数控制遮罩的动画path，可以最少设置popupParam.maskShowFromPath,popupParam.maskShowToPath两个参数，其余两个参数可选
 * popupParam 弹出的更多参数设置，具体参照TFPopupParam类 */
-(void)tf_showMask:(UIView *)inView
        popupParam:(TFPopupParam *)popupParam;


/* 自定义动画
 * inView 容器视图
 * popupParam 弹出的更多参数设置，具体参照TFPopupParam类
 * delegate 动画代理，默认为弹框本类，具体请参照TFPopupDelegate类 */
-(void)tf_showCustem:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam
            delegate:(id<TFPopupDelegate>)delegate;
@end



typedef void(^AnimationStartBlock)(CAAnimation *anima);
typedef void(^AnimationStopBlock)(CAAnimation *anima,BOOL finished);
@interface CAAnimation (TFPopup)<CAAnimationDelegate>

@property(nonatomic,  copy)AnimationStartBlock startBlock;
@property(nonatomic,  copy)AnimationStopBlock stopBlock;

-(void)observerAnimationDidStart:(AnimationStartBlock)start;
-(void)observerAnimationDidStop:(AnimationStopBlock)stop;

@end
