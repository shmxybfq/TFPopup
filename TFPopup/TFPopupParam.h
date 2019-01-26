//
//  TFPopupParam.h
//  TFPopupDemo
//
//  Created by Time on 2019/1/18.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,PopupBubbleDirection) {
    PopupBubbleDirectionTop = 0,
    PopupBubbleDirectionTopRight,
    PopupBubbleDirectionRight,
    PopupBubbleDirectionRightBottom,
    PopupBubbleDirectionBottom,
    PopupBubbleDirectionBottomLeft,
    PopupBubbleDirectionLeft,
    PopupBubbleDirectionLeftTop,
};

@interface TFPopupParam : NSObject

/* 【全局属性】时间
 duration,动画时间default=0.3
 autoDissmissDuration,自动消失时间,default=0
 */
@property(nonatomic,assign)NSTimeInterval duration;
@property(nonatomic,assign)NSTimeInterval autoDissmissDuration;


/* 【全局属性】背景
 backgroundColorClear,背景色透明
 disuseBackground,不使用背景视图,default=0.3alpha的黑色视图
 disuseBackgroundTouchHide,禁止点击背景消失弹框
 disuseBackgroundAlphaAnimation,背景视图是否叠加使用渐隐动画
 */
@property(nonatomic,assign)BOOL backgroundColorClear;
@property(nonatomic,assign)BOOL disuseBackground;
@property(nonatomic,assign)BOOL disuseBackgroundTouchHide;
@property(nonatomic,assign)BOOL disuseBackgroundAlphaAnimation;


/* 【全局属性】弹框动画
 disusePopupAlphaAnimation,弹出框是否叠加使用渐隐动画
 */
@property(nonatomic,assign)BOOL disusePopupAlphaAnimation;


/* 【全局属性】弹框尺寸和区域
 popupAreaRect,弹框所在区域尺寸,default=父视图的bounds,不设置弹框尺寸是参与计算弹框的位置和大小
 popupSize,弹框尺寸,default=弹框的frame.size,优先级popupSize<popupFrame
 popupFrame,弹框的frame,设置后popupSize失效
 keepPopupOriginFrame,是否保持弹框原有的位置不变,优先级>popupFrame
 */
@property(nonatomic,assign)CGRect popupAreaRect;
@property(nonatomic,assign)CGSize popupSize;
@property(nonatomic,assign)CGRect popupFrame;
@property(nonatomic,assign)CGPoint offset;
@property(nonatomic,assign)BOOL keepPopupOriginFrame;


/* 【tf_showCustemAnimation】属性动画
 showKeyPath,显示时的属性动画keyPath
 showFromValue,显示动画初始值
 showToValue,,显示动画结束值
 hideKeyPath,隐藏时的属性动画keyPath
 hideFromValue,隐藏动画初始值
 hideToValue,,隐藏动画结束值
 */
@property(nonatomic,  copy)NSString *showKeyPath;
@property(nonatomic,strong)id showFromValue;
@property(nonatomic,strong)id showToValue;
@property(nonatomic,  copy)NSString *hideKeyPath;
@property(nonatomic,strong)id hideFromValue;
@property(nonatomic,strong)id hideToValue;


/* 【tf_showFrame】形变动画,泡泡,位移动画,优先级popOriginFrame&popTargetFrame>bubbleDirection
 basePoint,弹出泡泡基于哪个点
 bubbleDirection,弹出泡泡的方向
 popOriginFrame,弹出初始frame
 popTargetFrame,弹出目标frame
 */
@property(nonatomic,assign)CGPoint basePoint;
@property(nonatomic,assign)PopupBubbleDirection bubbleDirection;
@property(nonatomic,assign)CGRect popOriginFrame;
@property(nonatomic,assign)CGRect popTargetFrame;


/* 【tf_showMask】遮罩
 maskShowFromPath,
 maskShowToPath,
 maskHideFromPath,
 maskHideToPath,
 */
@property(nonatomic,strong)UIBezierPath *maskShowFromPath;
@property(nonatomic,strong)UIBezierPath *maskShowToPath;
@property(nonatomic,strong)UIBezierPath *maskHideFromPath;
@property(nonatomic,strong)UIBezierPath *maskHideToPath;




@end

