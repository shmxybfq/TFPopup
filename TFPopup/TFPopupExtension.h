//
//  TFPopupExtension.h
//  TFPopupDemo
//
//  Created by Time on 2019/3/4.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFPopupParam.h"


typedef NS_ENUM(NSInteger,DelegateProcess) {
    DelegateProcessWillGetConfiguration = 0,//将要获取弹出配置
    DelegateProcessDidGetConfiguration,//已经获取弹出配置
    DelegateProcessWillShow,//将要弹出
    DelegateProcessDidShow,//已经调用完弹出,正在执行动画
    DelegateProcessShowAnimationDidFinish,//弹出动画执行完成
    DelegateProcessWillHide,//将要消失
    DelegateProcessDidHide,//已经调用完消失,正在执行动画
    DelegateProcessHideAnimationDidFinish,//消失动画执行完成
    DelegateProcessBackgroundDidTouch,//默认背景点击
};

typedef void(^TFDelegateProcessBlock)(UIView *pop,DelegateProcess pro);

@interface TFPopupExtension : NSObject

/* TFPopupDataSource */
@property(nonatomic,strong)UIView *inView;

@property(nonatomic,assign)CGSize popupArea;

@property(nonatomic,strong)UIButton *defaultBackgroundView;
@property(nonatomic,assign)NSInteger backgroundViewCount;
@property(nonatomic,strong)NSMutableArray *backgroundViewArray;
@property(nonatomic,strong)NSMutableArray *backgroundViewFrameArray;

@property(nonatomic,assign)BOOL disuseShowAlphaAnimation;
@property(nonatomic,assign)CGFloat showFromAlpha;
@property(nonatomic,assign)CGFloat showToAlpha;

@property(nonatomic,assign)BOOL disuseShowFrameAnimation;
@property(nonatomic,assign)CGRect showFromFrame;
@property(nonatomic,assign)CGRect showToFrame;

@property(nonatomic,assign)BOOL disuseHideAlphaAnimation;
@property(nonatomic,assign)CGFloat hideFromAlpha;
@property(nonatomic,assign)CGFloat hideToAlpha;

@property(nonatomic,assign)BOOL disuseHideFrameAnimation;
@property(nonatomic,assign)CGRect hideFromFrame;
@property(nonatomic,assign)CGRect hideToFrame;


/* TFPopupDelegate */
@property(nonatomic,assign)NSTimeInterval showAnimationDuration;
@property(nonatomic,assign)NSTimeInterval showAnimationDelay;
@property(nonatomic,assign)UIViewAnimationOptions showAnimationOptions;

@property(nonatomic,assign)NSTimeInterval hideAnimationDuration;
@property(nonatomic,assign)NSTimeInterval hideAnimationDelay;
@property(nonatomic,assign)UIViewAnimationOptions hideAnimationOptions;

@property(nonatomic,assign)PopupStyle style;//默认动画类型
@property(nonatomic,assign)PopupDirection direction;//默认动画方向，仅在滑动动画和泡泡动画下有效

//存储折叠和滑动时的方向
@property(nonatomic,assign)PopupDirection foldDirection;
@property(nonatomic,assign)PopupDirection slideDirection;

//监听弹框隐藏完毕回调,需要再显示弹框前调用此方法
@property(nonatomic,  copy)TFDelegateProcessBlock delegateProcessBlock;

//拖动相关属性
@property(nonatomic,strong)UIPanGestureRecognizer *dragGes;

@property(nonatomic,assign)CGPoint dragBeginSelfPoint;
@property(nonatomic,assign)CGPoint dragBeginSuperPoint;

@property(nonatomic,assign)BOOL needDiscernDragStyle;
@property(nonatomic,assign)DragStyle runtimeDragStyle;

@property(nonatomic,assign)CGPoint discernDragStyleBeginSelfPoint;
@property(nonatomic,assign)CGPoint discernDragStyleBeginSuperPoint;

@property(nonatomic,assign)CGRect  dragDissmissFrame;


@end


