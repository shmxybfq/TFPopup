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

//如果弹框view不设tag值,那么弹框的tag值将设为此值
#define kTFPopupDefaultTag (201912)

/* 动画数据源代理,询问动画的各种配置
 * 弹框本身自动实现,若将代理设为其他类则其他类需要实现以下方法
 */
@protocol TFPopupDataSource<NSObject>

@required;

- (UIView *)tf_popupInView:(UIView *)popup;//将弹框弹到哪个view上,无默认值
- (CGSize  )tf_popupInArea:(UIView *)popup;//参与计算的弹框区域的大小,默认为弹框容器的size
/* 弹框的渐隐动画设置
 * popup:弹框本类
 * state:有两个参数TFPopupStateShow,TFPopupStateHide分别设置弹框展示时的参数和参考消失时的参数
 * animationWithAlphaForState:弹出和消失时分别是否需要渐隐动画
 * fromAlphaForState:弹出和消失时起始alpha值
 * toAlphaForState:弹出和消失时结束alpha值
 */
- (BOOL    )tf_popupView:(UIView *)popup animationWithAlphaForState:(TFPopupState)state;//默认返回YES
- (CGFloat )tf_popupView:(UIView *)popup fromAlphaForState:(TFPopupState)state;//默认show=0,hide=1
- (CGFloat )tf_popupView:(UIView *)popup toAlphaForState:(TFPopupState)state;//默认show=1,hide=0
/* 弹框的尺寸【位移】动画设置
 * popup:弹框本类
 * state:有两个参数TFPopupStateShow,TFPopupStateHide分别设置弹框展示时的参数和参考消失时的参数
 * animationWithAlphaForState:弹出和消失时分别是否需要尺寸【位移】动画
 * fromAlphaForState:弹出和消失时起始frame值
 * toAlphaForState:弹出和消失时结束frame值
 */
- (BOOL    )tf_popupView:(UIView *)popup animationWithFrameForState:(TFPopupState)state;//默认返回YES
//默认show&hide大小为弹框原来尺寸,位置为弹框区域的终点位置
- (CGRect  )tf_popupView:(UIView *)popup fromFrameForState:(TFPopupState)state;
- (CGRect  )tf_popupView:(UIView *)popup toFrameForState:(TFPopupState)state;//同上

/* 弹出动画参数设置
 * popup:弹框本类
 * state:有两个参数TFPopupStateShow,TFPopupStateHide分别设置弹框展示时的参数和参考消失时的参数
 * animationDurationForState:弹出和消失时分别的动画时间
 * animationDelayForState:弹出和消失时分别的动画开始前延迟时间
 * animationOptionsForState:弹出和消失时分别的动画曲线类型
 */
@optional;
- (NSTimeInterval)tf_popupView:(UIView *)popup animationDurationForState:(TFPopupState)state;//默认0.3
- (NSTimeInterval)tf_popupView:(UIView *)popup animationDelayForState:(TFPopupState)state;//默认0.0
//默认UIViewAnimationOptionCurveEaseOut
- (UIViewAnimationOptions)tf_popupView:(UIView *)popup animationOptionsForState:(TFPopupState)state;

//拖动子scrollView时是否同步识别并改变弹框
- (BOOL)tf_popupView:(UIView *)popup enableScrollViewGestureRecognizerWhenDrag:(UIScrollView *)scrollView;
@end



/* 弹出背景视图代理,询问背景视图的数量,view,和frame
 * 弹框本身自动实现,默认为一个背景black-0.3透明度,尺寸为弹出区域尺寸,若将代理设为其他类则其他类需要实现以下方法
 */
@protocol TFPopupBackgroundDelegate<NSObject>
/* 弹出背景视图设置
 * popup:弹框本类
 * tf_popupBackgroundViewCount:背景视图的数量
 * backgroundViewAtIndex:返回每一个背景视图
 * backgroundViewFrameAtIndex:返回每一个背景视图的frame
 */
@optional
- (NSInteger)tf_popupBackgroundViewCount:(UIView *)popup;//默认1
//默认UIButton背景色为black-0.3透明度
- (UIView *)tf_popupView:(UIView *)popup backgroundViewAtIndex:(NSInteger)index;
- (CGRect)tf_popupView:(UIView *)popup backgroundViewFrameAtIndex:(NSInteger)index;//默认弹框区域大小
@end




/* 动画过程代理
 * 代理包含了动画执行过程中的各个阶段,在这个阶段中你可以获取和修改参数以达到修改动画的目的
 */
@protocol TFPopupDelegate<NSObject>
@optional;
/* 监听获取参数前后
 * popup:弹框本类
 * tf_popupViewWillGetConfiguration:开始获取所有配置前调用
 * tf_popupViewDidGetConfiguration:获取完所有配置后调用
 */
- (void)tf_popupViewWillGetConfiguration:(UIView *)popup;
- (void)tf_popupViewDidGetConfiguration:(UIView *)popup;

/* 弹框show过程
 * popup:弹框本类
 * tf_popupViewWillShow:开始执行动画代码前调用
 * tf_popupViewDidShow:执行完动画代码后调用,此函数早于tf_popupViewShowAnimationDidFinish调用
 * tf_popupViewShowAnimationDidFinish:动画执行完成时调用
 */
- (BOOL)tf_popupViewWillShow:(UIView *)popup;//默认YES
- (void)tf_popupViewDidShow:(UIView *)popup;
- (void)tf_popupViewShowAnimationDidFinish:(UIView *)popup;


/* 弹框即将执行hide代码
 * popup:弹框本类
 * return:返回是否继续动画,如返回NO则需要自己定义消失方式和自己调用tf_remove
 */
- (BOOL)tf_popupViewWillHide:(UIView *)popup;//默认YES
/* 弹框已经执行完hide代码
 * popup:弹框本类
 * return:返回如果没有任何动画的情况下,是否移除背景和弹框
 */
- (BOOL)tf_popupViewDidHide:(UIView *)popup;//默认YES
/* hide动画执行完成时调用
 * popup:弹框本类
 * return:返回是否移除背景和弹框,如果返回NO则需要自己调用tf_remove
 */
- (BOOL)tf_popupViewHideAnimationDidFinish:(UIView *)popup;//默认YES

/* 点击默认背景时调用
 * popup:弹框本类
 * return:返回点击背景后是否调用tf_hide
 */
- (BOOL)tf_popupViewBackgroundDidTouch:(UIView *)popup;//默认YES

/* 拖动非scrollview的view时调用,处理了view的拖动
 * popup:弹框本类
 * dragGes:拖拽手势
 */
- (void)tf_popupViewDidDrag:(UIView *)popup dragGes:(UIPanGestureRecognizer *)dragGes;

/* 拖动过程中调用,对外释放拖动距离百分比
* popup:弹框本类
* percent:拖动距离原始位置的直线百分比
* state:拖拽手势状态
*/
- (BOOL)tf_popupViewDidDragSlide:(UIView *)popup distancePercent:(CGFloat)percent distance:(CGFloat)distance state:(UIGestureRecognizerState)state;

@end



@interface UIView (TFPopup)<TFPopupDataSource,TFPopupDelegate,TFPopupBackgroundDelegate>

@property(nonatomic,  weak)UIView *inView;//弹框的容器视图

@property(nonatomic,  copy)NSString *identifier;//标示符，用于在弹出池里查找弹出的view

@property(nonatomic,strong)TFPopupExtension *extension;

@property(nonatomic,assign)id<TFPopupDelegate>popupDelegate;//动画调用过程代理
@property(nonatomic,assign)id<TFPopupDataSource>popupDataSource;//动画所有配置代理
@property(nonatomic,assign)id<TFPopupBackgroundDelegate>backgroundDelegate;//动画背景视图设置代理

@property(nonatomic,strong)TFPopupParam *popupParam;//默认动画参数

//通过id查找弹窗，如果多个弹窗id一样，则返回最先弹出的弹窗
+(UIView *)tf_findPopup:(NSString *)identifier;
//获取所有已弹出的弹窗
+(NSArray <UIView *>*)tf_getAllPopup;

//手动控制弹框消失,此函数是将弹框正常动画移除,动画完成后内部调用tf_remove
-(void)tf_hide;
//手动控制弹框移除
-(void)tf_remove;
//手动控制显示默认弹框 popupParam.disuseBackground = YES 时无效
-(void)showDefaultBackground;
//手动控制移除默认弹框
-(void)hideDefaultBackground;
//监听弹框隐藏完毕回调,需要再显示弹框前调用此方法
-(void)tf_observerDelegateProcess:(TFDelegateProcessBlock)delegateProcessBlock;


/* 基本动画，位置固定，可设置无任何动画弹出和渐隐方式
 * inView 容器视图
 * animated YES为渐隐动画NO为无任何动画
 * offset 弹框基于默认的偏移y正数为向下偏移，y负数为向上偏移，x值同理
 * popupParam 弹出的更多参数设置，具体参照TFPopupParam类 */
-(void)tf_showNormal:(UIView *)inView animated:(BOOL)animated;
-(void)tf_showNormal:(UIView *)inView offset:(CGPoint)offset animated:(BOOL)animated;
-(void)tf_showNormal:(UIView *)inView popupParam:(TFPopupParam *)popupParam;


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
-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction popupParam:(TFPopupParam *)popupParam;



/* 基于mask,所以此弹出方式不可以同时使用mask动画
 * 折叠动画，弹框最终显示位置->可选四个方向折叠展开
 * inView 容器视图
 * targetFrame 弹框的显示frame
 * direction 折叠方向,可设置四个默认折叠方向：向下展开，向右展开，向左展开，向上展开
 * popupParam 弹出的更多参数设置，具体参照TFPopupParam类
 */
-(void)tf_showFold:(UIView *)inView
       targetFrame:(CGRect)targetFrame
         direction:(PopupDirection)direction
        popupParam:(TFPopupParam *)popupParam;



/* 基于mask,所以此弹出方式不可以同时使用mask动画
 * 泡泡动画，基于point&bubbleDirection -> 展开弹框
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
-(void)tf_showcustom:(UIView *)inView
          popupParam:(TFPopupParam *)popupParam;

@end


typedef void(^AnimationStartBlock)(CAAnimation *anima);
typedef void(^AnimationStopBlock)(CAAnimation *anima,BOOL finished);

@interface CAAnimation (TFPopup)<CAAnimationDelegate>

@property(nonatomic,assign)BOOL openOberserBlock;
@property(nonatomic,  copy)AnimationStartBlock startBlock;
@property(nonatomic,  copy)AnimationStopBlock stopBlock;

-(void)observerAnimationDidStart:(AnimationStartBlock)start;
-(void)observerAnimationDidStop:(AnimationStopBlock)stop;

@end
