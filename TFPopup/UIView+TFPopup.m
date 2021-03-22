//
//  UIView+TFPopup.m
//  TFPopupDemo
//
//  Created by ztf on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "UIView+TFPopup.h"
#import <objc/runtime.h>
#import "TFPopupConst.h"
#import "UIScrollView+TFPopup.h"

#define kShowBaseAnimationKey @"kShowBaseAnimationKey"
#define kShowMaskAnimationKey @"kShowMaskAnimationKey"
#define kHideBaseAnimationKey @"kHideBaseAnimationKey"
#define kHideMaskAnimationKey @"kHideMaskAnimationKey"

#define kDefaultAnimationDuration 0.3
#define kDefaultBackgroundColorAlpha 0.3
#define kDefaultMinDragBackgroundAlpha 0.1
#define kDefaultMinDragDissmissDistance 60.0
#define kDefaultMinDragDirectionDiscernDistance 10.0//需要在用户拖动10个像素内确定用户想要的拖动方向

@interface TFPopupPrivateExtension : NSObject
@property(nonatomic,assign)BOOL currentIsShowState;
@property(nonatomic,assign)NSInteger showAnimationCount;
@property(nonatomic,assign)NSInteger hideAnimationCount;
@end
@implementation TFPopupPrivateExtension
@end

@implementation UIView (TFPopup)
@dynamic inView,extension,popupDataSource,popupDelegate,backgroundDelegate,popupParam;

#pragma mark -- 【入口函数】基本
-(void)tf_showNormal:(UIView *)inView animated:(BOOL)animated{
    [self tf_showNormal:inView offset:CGPointZero animated:animated];
}

-(void)tf_showNormal:(UIView *)inView offset:(CGPoint)offset animated:(BOOL)animated{
    TFPopupParam *param = [TFPopupParam new];
    
    param.offset = offset;
    param.disuseShowPopupAlphaAnimation = !animated;
    param.disuseHidePopupAlphaAnimation = !animated;
    param.disuseShowBackgroundAlphaAnimation = !animated;
    param.disuseHideBackgroundAlphaAnimation = !animated;
    
    [self tf_showNormal:inView popupParam:param];
}

-(void)tf_showNormal:(UIView *)inView popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    [self setDefault];
    
    [self tf_showcustom:inView popupParam:self.popupParam];
}

#pragma mark -- 【入口函数】缩放
-(void)tf_showScale:(UIView *)inView{
    [self tf_showScale:inView offset:CGPointZero];
}

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset{
    [self tf_showScale:inView offset:offset popupParam:[TFPopupParam new]];
}

-(void)tf_showScale:(UIView *)inView offset:(CGPoint)offset popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    [self setDefault];
    
    self.popupParam.offset = CGPointEqualToPoint(offset, CGPointZero)?self.popupParam.offset:offset;
    self.popupParam.showKeyPath = @"transform.scale";
    self.popupParam.showFromValue = @(0.0);
    self.popupParam.showToValue = @(1.0);
    self.popupParam.hideKeyPath = @"transform.scale";
    self.popupParam.hideFromValue = @(1.0);
    self.popupParam.hideToValue = @(0.0);
    
    [self tf_showcustom:inView popupParam:self.popupParam];
}

#pragma mark -- 【入口函数】滑动
-(void)tf_showSlide:(UIView *)inView direction:(PopupDirection)direction{
    [self tf_showSlide:inView direction:direction popupParam:[TFPopupParam new]];
}

-(void)tf_showSlide:(UIView *)inView
          direction:(PopupDirection)direction
         popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    self.extension.slideDirection = direction;
    [self setDefault];
    
    if (direction == PopupDirectionTop ||
        direction == PopupDirectionRight ||
        direction == PopupDirectionBottom ||
        direction == PopupDirectionLeft){
        
        if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero))
            self.popupParam.popOriginFrame = slideOriginFrame(self.popupParam, direction);
        
        if (CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero))
            self.popupParam.popTargetFrame = slideTargetFrame(self.popupParam, direction);
        
    }else if(direction == PopupDirectionFrame){
        if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero)||
            CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero)) {
            return;
        }
    }
    
    [self tf_showcustom:inView popupParam:self.popupParam];
}


#pragma mark -- 【入口函数】折叠
-(void)tf_showFold:(UIView *)inView
       targetFrame:(CGRect)targetFrame
         direction:(PopupDirection)direction
        popupParam:(TFPopupParam *)popupParam{
    
    
    if (CGRectEqualToRect(targetFrame, CGRectZero))return;
    self.inView = inView;
    self.popupParam = popupParam;
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    self.extension.foldDirection = direction;
    [self setDefault];
    
    self.popupParam.popOriginFrame = targetFrame;
    self.popupParam.popTargetFrame = targetFrame;
    self.popupParam.popupSize = targetFrame.size;
    
    if (direction == PopupDirectionTop ||
        direction == PopupDirectionRight ||
        direction == PopupDirectionBottom ||
        direction == PopupDirectionLeft){
        
        self.popupParam.maskShowFromPath = nil;
        self.popupParam.maskShowToPath = nil;
        self.popupParam.maskHideFromPath = nil;
        self.popupParam.maskHideToPath = nil;
        
        self.popupParam.maskShowFromPath = foldPath(targetFrame, direction, NO);
        self.popupParam.maskShowToPath = foldPath(targetFrame, direction, YES);
        
        [self tf_showcustom:inView popupParam:self.popupParam];
    }
}

#pragma mark -- 【入口函数】泡泡
-(void)tf_showBubble:(UIView *)inView
           basePoint:(CGPoint)basePoint
     bubbleDirection:(PopupDirection)bubbleDirection
          popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    self.popupParam.basePoint = basePoint;
    self.popupParam.bubbleDirection = bubbleDirection;
    
    [self setDefault];
    
    if ((self.popupParam.bubbleDirection == PopupDirectionTop ||
         self.popupParam.bubbleDirection == PopupDirectionTopRight ||
         self.popupParam.bubbleDirection == PopupDirectionRight ||
         self.popupParam.bubbleDirection == PopupDirectionRightBottom ||
         self.popupParam.bubbleDirection == PopupDirectionBottom ||
         self.popupParam.bubbleDirection == PopupDirectionBottomLeft ||
         self.popupParam.bubbleDirection == PopupDirectionLeft ||
         self.popupParam.bubbleDirection == PopupDirectionLeftTop) == NO) {
        return;
    }else{
        if (CGPointEqualToPoint(self.popupParam.basePoint, CGPointZero)) {
            return;
        }
    }
    self.popupParam.popOriginFrame = bubbleTarget(self.popupParam.basePoint,
                                                  self.popupParam.popupSize,
                                                  self.popupParam.bubbleDirection,
                                                  self.popupParam.offset);
    self.popupParam.popTargetFrame = self.popupParam.popOriginFrame;
    
    self.popupParam.maskShowFromPath = nil;
    self.popupParam.maskShowToPath = nil;
    self.popupParam.maskHideFromPath = nil;
    self.popupParam.maskHideToPath = nil;
    self.popupParam.maskShowFromPath = bubblePath(self.popupParam.popupSize, bubbleDirection, NO);
    self.popupParam.maskShowToPath = bubblePath(self.popupParam.popupSize, bubbleDirection, YES);
    
    [self tf_showcustom:inView popupParam:self.popupParam];
}




#pragma mark -- 【入口函数】形变
-(void)tf_showFrame:(UIView *)inView
               from:(CGRect)from
                 to:(CGRect)to
         popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    [self setDefault];
    
    self.popupParam.popOriginFrame = CGRectEqualToRect(CGRectZero, from)?self.popupParam.popOriginFrame:from;
    self.popupParam.popTargetFrame = CGRectEqualToRect(CGRectZero, to)?self.popupParam.popOriginFrame:to;
    
    [self tf_showcustom:inView popupParam:self.popupParam];
}


#pragma mark -- 【入口函数】遮罩
-(void)tf_showMask:(UIView *)inView
        popupParam:(TFPopupParam *)popupParam{
    
    self.inView = inView;
    self.popupParam = popupParam;
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    [self setDefault];
    
    [self tf_showcustom:inView popupParam:self.popupParam];
}

#pragma mark -- 【入口函数】自定义
-(void)tf_showcustom:(UIView *)inView popupParam:(TFPopupParam *)popupParam{
    
#ifdef DEBUG
    NSAssert(inView != nil, @"(TFPopup)you must setting a inView.");
    NSAssert([inView isKindOfClass:[UIView class]], @"(TFPopup)inView must be a view.");
#endif
    if (self.tag == 0) {self.tag = kTFPopupDefaultTag;}
    self.inView = inView;
    self.popupParam = popupParam;
    if (self.popupParam == nil)self.popupParam = [[TFPopupParam alloc]init];
    
    //设置时间,弹框大小,弹框区域大小默认值
    [self setDefault];
    
    //设置动画和遮罩默认值
    [self checkStyle];
    //代理
    self.popupDelegate = self.popupDelegate==nil?self:self.popupDelegate;
    self.popupDataSource = self.popupDataSource==nil?self:self.popupDataSource;
    self.backgroundDelegate = self.backgroundDelegate==nil?self:self.backgroundDelegate;
    [self performSelectorOnMainThread:@selector(tf_reload) withObject:nil waitUntilDone:YES];
    [self performSelectorOnMainThread:@selector(tf_show) withObject:nil waitUntilDone:YES];
    
}

#pragma mark -- 动画默认设置和动画类型判断
-(void)setDefault{
    
    //时间
    if (self.popupParam.duration == 0) self.popupParam.duration = kDefaultAnimationDuration;
    
    //弹框尺寸
    if (CGSizeEqualToSize(self.popupParam.popupSize, CGSizeZero))
        self.popupParam.popupSize = self.bounds.size;
    
    //弹框区域
    if (CGRectEqualToRect(self.popupParam.popupAreaRect, CGRectZero))
        self.popupParam.popupAreaRect = self.inView.bounds;
}

-(void)checkStyle{
    //参数值检测
    //alpha
    PopupStyle style = PopupStyleNone;
    
    //animation
    if (self.popupParam.showKeyPath != nil &&
        self.popupParam.showFromValue != nil &&
        self.popupParam.showToValue != nil){
        
        style = style | PopupStyleExtensionAniamtion;
        
        if (self.popupParam.hideKeyPath == nil)
            self.popupParam.hideKeyPath = self.popupParam.showKeyPath;
        if (self.popupParam.hideFromValue == nil)
            self.popupParam.hideFromValue = self.popupParam.showToValue;
        if (self.popupParam.hideToValue == nil)
            self.popupParam.hideToValue = self.popupParam.showFromValue;
    }
    
    //mask
    if (self.popupParam.maskShowFromPath != nil &&
        self.popupParam.maskShowToPath != nil ) {
        style = style | PopupStyleExtensionMask;
        
        if (self.popupParam.maskHideFromPath == nil)
            self.popupParam.maskHideFromPath = self.popupParam.maskShowToPath;
        if (self.popupParam.maskHideToPath == nil)
            self.popupParam.maskHideToPath = self.popupParam.maskShowFromPath;
    }
    self.extension.style = style;
}

#pragma mark -- 刷新和展示
//刷新
-(void)tf_reload{
    
    //将要获取参数
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewWillGetConfiguration:)]) {
        [self.popupDelegate tf_popupViewWillGetConfiguration:self];
    }
    
    //设置内部参数初始值
    self.extension.inView = nil;
    
    self.extension.popupArea = CGSizeZero;
    
    [self.extension.defaultBackgroundView removeFromSuperview];
    self.extension.defaultBackgroundView = nil;
    
    self.extension.backgroundViewCount = 0;
    [self.extension.backgroundViewArray removeAllObjects];
    [self.extension.backgroundViewFrameArray removeAllObjects];
    
    self.extension.disuseShowAlphaAnimation = NO;
    self.extension.showFromAlpha = -1;
    self.extension.showToAlpha = -1;
    self.extension.disuseHideAlphaAnimation = NO;
    self.extension.hideFromAlpha = -1;
    self.extension.hideToAlpha = -1;
    
    self.extension.disuseShowFrameAnimation = NO;
    self.extension.showFromFrame = CGRectZero;
    self.extension.showToFrame = CGRectZero;
    self.extension.disuseHideFrameAnimation = NO;
    self.extension.hideFromFrame = CGRectZero;
    self.extension.hideToFrame = CGRectZero;
    
    self.extension.showAnimationDuration = kDefaultAnimationDuration;
    self.extension.showAnimationDelay = 0.0;
    self.extension.showAnimationOptions = UIViewAnimationOptionCurveEaseOut;
    self.extension.hideAnimationDuration = kDefaultAnimationDuration;
    self.extension.hideAnimationDelay = 0.0;
    self.extension.hideAnimationOptions = UIViewAnimationOptionCurveEaseOut;
    
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupInView:)]) {
        self.extension.inView = [self.popupDataSource tf_popupInView:self];
    }
    
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupInArea:)]) {
        self.extension.popupArea = [self.popupDataSource tf_popupInArea:self];
    }
    
    /* background */
    if (self.popupParam.disuseBackground == NO) {
        if ([self.backgroundDelegate respondsToSelector:@selector(tf_popupBackgroundViewCount:)]) {
            self.extension.backgroundViewCount = [self.backgroundDelegate tf_popupBackgroundViewCount:self];
        }
        
        //默认背景
        if (self.extension.backgroundViewCount <= 0) {
            self.extension.defaultBackgroundView = [UIButton buttonWithType:UIButtonTypeCustom];
            if (self.popupParam.backgroundColor) {
                self.extension.defaultBackgroundView.backgroundColor = self.popupParam.backgroundColor;
            }else if(self.popupParam.backgroundColorClear){
                self.extension.defaultBackgroundView.backgroundColor = [UIColor clearColor];
            }else{
                self.extension.defaultBackgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:kDefaultBackgroundColorAlpha];
            }
            [self.extension.defaultBackgroundView addTarget:self
                                                     action:@selector(defaultBackgroundViewClick:)
                                           forControlEvents:UIControlEventTouchUpInside];
            self.extension.defaultBackgroundView.alpha = 0;
            
        }else{
            //多个背景
            for (NSInteger i = 0; i < self.extension.backgroundViewCount; i++) {
                UIView *backgroundView = nil;
                CGRect  backgroundViewFrame = CGRectZero;
                if ([self.backgroundDelegate respondsToSelector:@selector(tf_popupView:backgroundViewAtIndex:)]) {
                    backgroundView = [self.backgroundDelegate tf_popupView:self backgroundViewAtIndex:i];
                }
                if ([self.backgroundDelegate respondsToSelector:@selector(tf_popupView:backgroundViewFrameAtIndex:)]) {
                    backgroundViewFrame = [self.backgroundDelegate tf_popupView:self backgroundViewFrameAtIndex:i];
                }
#ifdef DEBUG
                NSAssert(backgroundView != nil, @"backgroundView can't be a nil");
                NSAssert([backgroundView isKindOfClass:[UIView class]], @"backgroundView must be a view");
#endif
                if (backgroundView != nil && [backgroundView isKindOfClass:[UIView class]]) {
                    [self.extension.backgroundViewArray addObject:backgroundView];
                    [self.extension.backgroundViewFrameArray addObject:NSStringFromCGRect(backgroundViewFrame)];
                    backgroundView.frame = backgroundViewFrame;
                }
            }
        }
    }
    
    /* show-alpha */
    //show-alpha是否动画
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationWithAlphaForState:)]) {
        BOOL animation = [self.popupDataSource tf_popupView:self animationWithAlphaForState:TFPopupStateShow];
        self.extension.disuseShowAlphaAnimation = !animation;
    }
    //show-alpha开始初始的alpha
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:fromAlphaForState:)]) {
        self.extension.showFromAlpha = [self.popupDataSource tf_popupView:self fromAlphaForState:TFPopupStateShow];
        self.alpha = self.extension.showFromAlpha;
    }
    //show-alpha开始目标的alpha
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:toAlphaForState:)]) {
        self.extension.showToAlpha = [self.popupDataSource tf_popupView:self toAlphaForState:TFPopupStateShow];
    }
    
    /* show-frame */
    //show-frame是否动画
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationWithFrameForState:)]) {
        BOOL animation = [self.popupDataSource tf_popupView:self animationWithFrameForState:TFPopupStateShow];
        self.extension.disuseShowFrameAnimation = !animation;
    }
    //show-frame开始时的frame
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:fromFrameForState:)]) {
        self.extension.showFromFrame = [self.popupDataSource tf_popupView:self fromFrameForState:TFPopupStateShow];
        self.frame = self.extension.showFromFrame;
    }
    //show-frame结束时的frame
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:toFrameForState:)]) {
        self.extension.showToFrame = [self.popupDataSource tf_popupView:self toFrameForState:TFPopupStateShow];
    }
    
    /* hide-alpha */
    //hide-alpha是否动画
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationWithAlphaForState:)]) {
        BOOL animation = [self.popupDataSource tf_popupView:self animationWithAlphaForState:TFPopupStateHide];
        self.extension.disuseHideAlphaAnimation = !animation;
    }
    //hide-alpha开始时的alpha
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:fromAlphaForState:)]) {
        self.extension.hideFromAlpha = [self.popupDataSource tf_popupView:self fromAlphaForState:TFPopupStateHide];
    }
    //hide-alpha结束时的alpha
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:toAlphaForState:)]) {
        self.extension.hideToAlpha = [self.popupDataSource tf_popupView:self toAlphaForState:TFPopupStateHide];
    }
    
    /* hide-frame */
    //hide-frame是否动画
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationWithFrameForState:)]) {
        BOOL animation = [self.popupDataSource tf_popupView:self animationWithFrameForState:TFPopupStateHide];
        self.extension.disuseHideFrameAnimation = !animation;
    }
    //hide-frame开始时的frame
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:fromFrameForState:)]) {
        self.extension.hideFromFrame = [self.popupDataSource tf_popupView:self fromFrameForState:TFPopupStateHide];
    }
    //hide-frame结束时的frame
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:toFrameForState:)]) {
        self.extension.hideToFrame = [self.popupDataSource tf_popupView:self toFrameForState:TFPopupStateHide];
    }
    
    /* animation-configue */
    /* show */
    //show动画时间
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationDurationForState:)]) {
        self.extension.showAnimationDuration = [self.popupDataSource tf_popupView:self animationDurationForState:TFPopupStateShow];
    }
    //show动画延迟
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationDelayForState:)]) {
        self.extension.showAnimationDelay = [self.popupDataSource tf_popupView:self animationDelayForState:TFPopupStateShow];
    }
    //show动画选项
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationOptionsForState:)]) {
        self.extension.showAnimationOptions = [self.popupDataSource tf_popupView:self animationOptionsForState:TFPopupStateShow];
    }
    
    
    /* hide */
    //hide动画时间
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationDurationForState:)]) {
        self.extension.hideAnimationDuration = [self.popupDataSource tf_popupView:self animationDurationForState:TFPopupStateHide];
    }
    //hide动画延迟
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationDelayForState:)]) {
        self.extension.hideAnimationDelay = [self.popupDataSource tf_popupView:self animationDelayForState:TFPopupStateHide];
    }
    //hide动画选项
    if ([self.popupDataSource respondsToSelector:@selector(tf_popupView:animationOptionsForState:)]) {
        self.extension.hideAnimationOptions = [self.popupDataSource tf_popupView:self animationOptionsForState:TFPopupStateHide];
    }
    
    
    /* 设置默认参数 */
    if (self.extension.inView == nil) {
        self.extension.inView = [UIApplication sharedApplication].keyWindow;
    }
    
    if (CGSizeEqualToSize(self.extension.popupArea, CGSizeZero)) {
        self.extension.popupArea = self.extension.inView.frame.size;
    }
    
    if (self.extension.showFromAlpha == -1) {
        self.extension.showFromAlpha = 0;
    }
    if (self.extension.showToAlpha == -1) {
        self.extension.showToAlpha = 1;
    }
    if (CGRectEqualToRect(self.extension.showFromFrame, CGRectZero)) {
        self.extension.showFromFrame = self.frame;
    }
    if (CGRectEqualToRect(self.extension.showToFrame, CGRectZero)) {
        self.extension.showToFrame = self.frame;
    }
    
    
    if (self.extension.hideFromAlpha == -1) {
        self.extension.hideFromAlpha = self.extension.showToAlpha;
    }
    if (self.extension.hideToAlpha == -1) {
        self.extension.hideToAlpha = self.extension.showFromAlpha;
    }
    if (CGRectEqualToRect(self.extension.hideFromFrame, CGRectZero)) {
        self.extension.hideFromFrame = self.extension.showToFrame;
    }
    if (CGRectEqualToRect(self.extension.hideToFrame, CGRectZero)) {
        self.extension.hideToFrame = self.extension.showFromFrame;
    }
    
    //拖拽开关
    if (self.popupParam.dragEnable) {
        if (!self.extension.dragGes) {
            //添加手势
            self.extension.dragGes = [[UIPanGestureRecognizer alloc]init];
            [self.extension.dragGes addTarget:self action:@selector(dragGestureRecognizer:)];
            [self addGestureRecognizer:self.extension.dragGes];
            
#warning 调试设置推测滚动
            self.popupParam.discernScrollEnable = YES;
            if (self.popupParam.discernScrollEnable) {
                //子UIScrollView传入pop对象
                NSMutableArray *all = allSubViews(self, YES);
                for (UIView *sub in all) {
                    if ([sub isKindOfClass:[UIScrollView class]]) {
                        UIScrollView *subScrollView = (UIScrollView *)sub;
                        if (subScrollView.scrollEnabled) {
                            subScrollView.faterPopupView = self;
                        }
                    }
                }
            }
        }
    }
    
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewDidGetConfiguration:)]) {
        [self.popupDelegate tf_popupViewDidGetConfiguration:self];
    }
}

//弹出
-(void)tf_show{
    x_weakSelf;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewWillShow:)]) {
        BOOL continueAnimation = [self.popupDelegate tf_popupViewWillShow:self];
        if (continueAnimation == NO) {
            return;
        }
    }
    //自动消失时间
    if (self.popupParam.autoDissmissDuration != 0) {
        [self performSelector:@selector(tf_hide)
                   withObject:nil
                   afterDelay:self.popupParam.autoDissmissDuration];
    }
    
    if (self.extension.backgroundViewCount <= 0) {
        CGSize area = self.extension.popupArea;
        self.extension.defaultBackgroundView.frame = CGRectMake(0, 0, area.width, area.height);
        [self.inView addSubview:self.extension.defaultBackgroundView];
    }else{
        for (NSInteger i = 0; i < self.extension.backgroundViewCount; i++) {
            UIView *backgroundView = [self.extension.backgroundViewArray objectAtIndex:i];
            NSString *frameString = [self.extension.backgroundViewFrameArray objectAtIndex:i];
            backgroundView.frame = CGRectFromString(frameString);
            [self.inView addSubview:backgroundView];
        }
    }
    
    self.alpha = self.extension.showFromAlpha;
    self.frame = self.extension.showFromFrame;
    [self.inView addSubview:self];
    
    
    TFPopupPrivateExtension *ext = getRunCache(self);
    ext.currentIsShowState = YES;
    ext.showAnimationCount = 0;
    
    if (self.extension.disuseShowAlphaAnimation == NO &&
        self.extension.showFromAlpha != self.extension.showToAlpha) {
        ext.showAnimationCount += 1;
        [UIView animateWithDuration:self.extension.showAnimationDuration
                              delay:self.extension.showAnimationDelay
                            options:self.extension.showAnimationOptions
                         animations:^{
            weakself.alpha = weakself.extension.showToAlpha;
        } completion:^(BOOL finished) {
            [weakself showAnimationCompletion];
        }];
    }else{
        self.alpha = weakself.extension.showToAlpha;
    }
    if (self.extension.disuseShowFrameAnimation == NO &&
        (CGRectEqualToRect(self.extension.showFromFrame, self.extension.showToFrame) == NO)) {
        ext.showAnimationCount += 1;
        [UIView animateWithDuration:self.extension.showAnimationDuration
                              delay:self.extension.showAnimationDelay
                            options:self.extension.showAnimationOptions
                         animations:^{
            weakself.frame = weakself.extension.showToFrame;
        } completion:^(BOOL finished) {
            [weakself showAnimationCompletion];
        }];
    }else{
        self.frame = weakself.extension.showToFrame;
    }
    
    
    //动画
    if (popupStyleInclude(self.extension.style, PopupStyleExtensionAniamtion)) {
        CAAnimation *animation = [self animation:self.popupParam.showKeyPath
                                            from:self.popupParam.showFromValue
                                              to:self.popupParam.showToValue
                                             dur:self.popupParam.duration];
        if (animation){
            ext.showAnimationCount += 1;
            animation.delegate = self;
            tf_popupDelay(self.extension.showAnimationDelay, ^{
                [weakself.layer addAnimation:animation forKey:kShowBaseAnimationKey];
            });
        }
    }
    
    //遮罩
    if (popupStyleInclude(self.extension.style, PopupStyleExtensionMask)) {
        
        NSTimeInterval dur = self.popupParam.duration;
        NSString *keyPath = @"path";
        CAShapeLayer *mask = [[CAShapeLayer alloc]init];
        mask.frame = CGRectMake(0, 0, self.popupParam.popupSize.width, self.popupParam.popupSize.height);
        mask.path = self.popupParam.maskShowFromPath.CGPath;
        self.layer.mask = mask;
        
        id from = (__bridge id)self.popupParam.maskShowFromPath.CGPath;
        id to = (__bridge id)self.popupParam.maskShowToPath.CGPath;
        
        CAAnimation *animation = [self animation:keyPath from:from to:to dur:dur];
        if (animation){
            ext.showAnimationCount += 1;
            animation.delegate = self;
            __weak typeof(mask) weakMask = mask;
            tf_popupDelay(self.extension.showAnimationDelay, ^{
                [weakMask addAnimation:animation forKey:kShowMaskAnimationKey];
            });
        }
    }
    
    //将弹窗放进弹窗池
    [TFPopupPool addToPool:self];
    
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewDidShow:)]) {
        [self.popupDelegate tf_popupViewDidShow:self];
    }
}


#pragma mark - 拖动部分
//@property(nonatomic,assign)BOOL dragEnable;//是否可拖拽
//@property(nonatomic,assign)DragStyle dragStyle;//拖拽类型
//@property(nonatomic,assign)BOOL dragBouncesEnable;//是否可弹性
//@property(nonatomic,assign)BOOL discernScrollEnable;//识别滚动
//@property(nonatomic,assign)NSUInteger dragAutoDissmissMinDistance;//最小拖动消失距离
//规则
//1.先识别方向再作操作相当于一个方向了
//2.存在对冲方向不存在弹性和阻止，非对冲方向存在弹性和阻止
//3.和scrollview的拖动兼容性。向下拖动时，向下滚动到头需要拖动，向上滚动则不需要
//4.识别的反方向为阻止方向，如果反方向也是可拖动方向则不阻止
//5.是否支持scrolview应该是可设置的
//6.弹性应该是可设置的
//7.拖动应该是可以自定义的
//8.非单一方向需要先做方向识别
//9.应该可以设置拖动消失点和识别距离
//10.可以自定义拖动

/*
 * 拖动非scrollview的view时调用
 * popup:弹框本类
 * dragGes:拖拽手势
 */
-(void)dragGestureRecognizer:(UIPanGestureRecognizer *)dragGes{
    //NSLog(@"弹框拖动手势事件=======:%@",[dragGes.view class]);
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewDidDrag:dragGes:)]) {
        
        //拖动开始时,左右拖动操作前的配置
        UIGestureRecognizerState state = dragGes.state;
        if (state == UIGestureRecognizerStateBegan) {
            self.extension.needDiscernDragStyle = NO;
            self.extension.runtimeDragStyle = DragStyleNone;
            self.extension.discernDragStyleBeginSelfPoint = CGPointZero;
            self.extension.discernDragStyleBeginSuperPoint = CGPointZero;
            self.extension.dragBeginSelfPoint = CGPointZero;
            self.extension.dragBeginSuperPoint = CGPointZero;
            self.extension.dragDissmissFrame = self.extension.showToFrame;
        }else if (state == UIGestureRecognizerStateChanged) {
            
        }else{
            //拖动结束后将当前正在滚动的view置空
            self.extension.currentDragScrollView = nil;
            self.extension.currentDragScrollViewAllowScroll = YES;
        }
        
        
        //        if (self.extension.currentDragScrollView == nil) {
        [self.popupDelegate tf_popupViewDidDrag:self dragGes:dragGes];
        //        }else{
        //            [self.popupDelegate tf_popupViewDidDrag:self dragGes:dragGes];
        //        }
    }
}


//1.判断点到哪了，是scrollview还是其他地方
//2.如果scrollview不允许
//3.如果是空白区域，就不管了，如果是scrollview，先确定方向(tableview肯定是竖向，cell肯定是横向)，然后再确定拖滚动还是弹框
- (void)tf_popupViewDidDrag:(UIView *)popup dragGes:(UIPanGestureRecognizer *)dragGes{
    
    CGPoint selfPoint = [dragGes locationInView:self];
    CGPoint superPoint = [dragGes locationInView:self.superview];
    
    if (dragGes.state == UIGestureRecognizerStateBegan) {
        
        if (self.extension.defaultBackgroundView) {
            self.extension.defaultBackgroundView.userInteractionEnabled = NO;//拖动期间不允许点击背景
        }
        
        if (self.popupParam.dragAutoDissmissMinDistance <= 0) {
            self.popupParam.dragAutoDissmissMinDistance = kDefaultMinDragDissmissDistance;//最小拖动距离
        }
        
        self.extension.needDiscernDragStyle = [self tf_popupSetOrEstimateDragStyleAndDismissFrame:popup];//计算是否需要推测拖拽方式
        
        if (self.extension.needDiscernDragStyle) {
            self.extension.discernDragStyleBeginSelfPoint = selfPoint;
            self.extension.discernDragStyleBeginSuperPoint = superPoint;
        }else{
            self.extension.dragBeginSelfPoint = selfPoint;
            self.extension.dragBeginSuperPoint = superPoint;
        }
        
    }else if(dragGes.state == UIGestureRecognizerStateChanged){
        
        if (self.extension.needDiscernDragStyle) {//需要推测拖拽方向
            
            CGFloat x = selfPoint.x - self.extension.discernDragStyleBeginSelfPoint.x;
            CGFloat y = selfPoint.y - self.extension.discernDragStyleBeginSelfPoint.y;
            
            DragStyle discernDragStyle = DragStyleNone;
            if (ABS(x) >= kDefaultMinDragDirectionDiscernDistance || ABS(y) >= kDefaultMinDragDirectionDiscernDistance) {//到达拖动识别长度
                if (ABS(x) > ABS(y)) {
                    if (x > 0) discernDragStyle = DragStyleToRight;//右
                    else discernDragStyle = DragStyleToLeft;//左
                }else{
                    if (y > 0) discernDragStyle = DragStyleToBottom;//下
                    else discernDragStyle = DragStyleToTop;//上
                }
            }
            
            if (discernDragStyle != DragStyleNone) {//用户拖动方向已识别
                if (dragStyleInclude(self.popupParam.dragStyle, discernDragStyle) == NO) {//识别的方向不在用户设置的方向范围内,则认为此方向拖动失败
                    self.extension.runtimeDragStyle = DragStyleNone;
                }else{//识别的方向在用户设置的方向范围内
                    BOOL caseSuccess = [self setDragStyleAndDissmissFrame:discernDragStyle dissmissFrame:CGRectZero];
                    if (caseSuccess) {
                        self.extension.needDiscernDragStyle = NO;
                        self.extension.runtimeDragStyle = discernDragStyle;
                        self.extension.dragBeginSelfPoint = selfPoint;
                        self.extension.dragBeginSuperPoint = superPoint;
                    }
                }
            }
        }
        
        if (self.extension.runtimeDragStyle != DragStyleNone){//有拖动方式才处理拖动
            if (CGPointEqualToPoint(self.extension.dragBeginSelfPoint, CGPointZero) == NO &&
                CGPointEqualToPoint(self.extension.dragBeginSuperPoint, CGPointZero) == NO) {
                [self tf_popupViewDidDragSlide:self superPoint:superPoint state:dragGes.state];
            }
        }
        
    }else{
        
        self.extension.defaultBackgroundView.userInteractionEnabled = YES;//拖动结束允许点击背景
        //拖拽结束/取消/打断等
        if (CGPointEqualToPoint(self.extension.dragBeginSelfPoint, CGPointZero) == NO &&
            CGPointEqualToPoint(self.extension.dragBeginSuperPoint, CGPointZero) == NO) {
            [self tf_popupViewDidDragSlide:self superPoint:superPoint state:dragGes.state];
        }
    }
}


//开始拖动前计算拖动方向和将要消失的目标方向
- (BOOL)tf_popupSetOrEstimateDragStyleAndDismissFrame:(UIView *)popup{
    
    BOOL needDiscernDragStyle = YES;//是否需要根据拖动实时计算拖动方式
    if (self.popupParam.dragStyle == DragStyleNone) {//打开拖动,且未设置拖动方向
        DragStyle dragStyle = DragStyleNone;
        switch (self.extension.slideDirection) {//如果未手动设置方向,判断是否是滑动动画,滑动动画默认同方向拖动手势
            case PopupDirectionTop:dragStyle = DragStyleToTop;break;
            case PopupDirectionLeft:dragStyle = DragStyleToLeft;break;
            case PopupDirectionBottom:dragStyle = DragStyleToBottom;break;
            case PopupDirectionRight:dragStyle = DragStyleToRight;break;
            default:break;
        }
        BOOL caseSuccess = [self setDragStyleAndDissmissFrame:dragStyle dissmissFrame:self.extension.hideToFrame];
        if (caseSuccess) {
            needDiscernDragStyle = NO;
            self.extension.runtimeDragStyle = dragStyle;
        }
    }else if(self.popupParam.dragStyle == DragStyleFree){
        //手动设置为自由拖动方式
        needDiscernDragStyle = NO;
        self.extension.runtimeDragStyle = DragStyleFree;
        self.extension.dragDissmissFrame = self.extension.showToFrame;
    }else{
        NSInteger count = 0;//已手动设置方向,判断手动设置的方向是否为单方向,如果不是单方向则需要根据拖动动态识别用户意向的拖动方向
        count += dragStyleInclude(self.popupParam.dragStyle, DragStyleToTop);
        count += dragStyleInclude(self.popupParam.dragStyle, DragStyleToLeft);
        count += dragStyleInclude(self.popupParam.dragStyle, DragStyleToBottom);
        count += dragStyleInclude(self.popupParam.dragStyle, DragStyleToRight);
        if (count == 1) {//设置单方向,需要根据方向计算消失的位置
            BOOL caseSuccess = [self setDragStyleAndDissmissFrame:self.popupParam.dragStyle dissmissFrame:CGRectZero];
            if (caseSuccess) {
                needDiscernDragStyle = NO;
                self.extension.runtimeDragStyle = self.popupParam.dragStyle;
            }
        }else{
            needDiscernDragStyle = YES;//设置了多方向,需要自动识别方向
        }
    }
    return needDiscernDragStyle;
}



//根据拖动方向和设置的frame设置运行时的拖动方向和目标拖动消失frame
-(BOOL)setDragStyleAndDissmissFrame:(DragStyle)style dissmissFrame:(CGRect)dissmissFrame{
    BOOL caseSuccess = NO;
    CGRect st = self.extension.showToFrame;
    switch (style) {
        case DragStyleToTop:{
            if (CGRectEqualToRect(CGRectZero, dissmissFrame)) {
                self.extension.dragDissmissFrame = CGRectMake(st.origin.x, -st.size.height, st.size.width, st.size.height);
            }else{
                self.extension.dragDissmissFrame = dissmissFrame;
            }
            caseSuccess = YES;
        }break;
        case DragStyleToLeft:{
            if (CGRectEqualToRect(CGRectZero, dissmissFrame)) {
                self.extension.dragDissmissFrame = CGRectMake(-st.size.width, st.origin.y, st.size.width, st.size.height);
            }else{
                self.extension.dragDissmissFrame = dissmissFrame;
            }
            caseSuccess = YES;
        }break;
        case DragStyleToBottom:{
            if (CGRectEqualToRect(CGRectZero, dissmissFrame)) {
                self.extension.dragDissmissFrame = CGRectMake(st.origin.x, self.extension.popupArea.height, st.size.width, st.size.height);
            }else{
                self.extension.dragDissmissFrame = dissmissFrame;
            }
            caseSuccess = YES;
        }break;
        case DragStyleToRight:{
            if (CGRectEqualToRect(CGRectZero, dissmissFrame)) {
                self.extension.dragDissmissFrame = CGRectMake(self.extension.popupArea.width, st.origin.y, st.size.width, st.size.height);
            }else{
                self.extension.dragDissmissFrame = dissmissFrame;
            }
            caseSuccess = YES;
        }break;
        default:break;
    }
    return caseSuccess;
}

/*
 * 滑动弹出后的拖拽
 * popup:弹框本类
 * dragGes:拖拽手势
 */
- (void)tf_popupViewDidDragSlide:(UIView *)popup superPoint:(CGPoint)superPoint state:(UIGestureRecognizerState)state{
    
    x_weakSelf;
    CGFloat originX = self.extension.showToFrame.origin.x;
    CGFloat originY = self.extension.showToFrame.origin.y;
    CGFloat x = superPoint.x - self.extension.dragBeginSelfPoint.x;
    CGFloat y = superPoint.y - self.extension.dragBeginSelfPoint.y;
    
    if (state == UIGestureRecognizerStateChanged) {
        switch (self.extension.runtimeDragStyle) {
            case DragStyleNone:{return;}break;
            case DragStyleFree:{}break;//自由模式不控制xy拖动自由
            case DragStyleToTop:{
                x = originX;
                CGFloat distanceY = y - originY;
                if (distanceY > 0) {
                    if (self.popupParam.dragBouncesEnable) {
                        y = originY + ABS(distanceY) * 0.15;
                    }else{
                        y = originY;
                    }
                }
            }break;
            case DragStyleToBottom:{
                x = originX;
                CGFloat distanceY = y - originY;
                if (distanceY < 0) {
                    if (self.popupParam.dragBouncesEnable) {
                        y = originY - ABS(distanceY) * 0.15;
                    }else{
                        y = originY;
                    }
                }
            }break;
            case DragStyleToLeft:{
                y = originY;
                CGFloat distanceX = x - originX;
                if (distanceX > 0) {
                    if (self.popupParam.dragBouncesEnable) {
                        x = originX + ABS(distanceX) * 0.15;
                    }else{
                        x = originX;
                    }
                }
            }break;
            case DragStyleToRight:{
                y = originY;
                CGFloat distanceX = x - originX;
                if (distanceX < 0) {
                    if (self.popupParam.dragBouncesEnable) {
                        x = originX - ABS(distanceX) * 0.15;
                    }else{
                        x = originX;
                    }
                }
            }break;
            default:break;
        }
        
        self.frame = CGRectMake(x, y, self.frame.size.width, self.frame.size.height);//更新拖动位置
        //根据位置计算背景透明度
        if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewDidDragSlide:distancePercent:distance:state:)]) {
            CGFloat percent = [self percentOfDragAndOrigin];
            CGFloat distance = [self distanceOfShowToFrameAndNow];
            [self.popupDelegate tf_popupViewDidDragSlide:self distancePercent:percent distance:distance state:state];
        }
        
    }else if (state == UIGestureRecognizerStateEnded ||
              state == UIGestureRecognizerStateCancelled ||
              state == UIGestureRecognizerStateFailed ||
              state == UIGestureRecognizerStateRecognized) {
        
        if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewDidDragSlide:distancePercent:distance:state:)]) {
            
            CGFloat percent = [self percentOfDragAndOrigin];
            CGFloat distance = [self distanceOfShowToFrameAndNow];
            CGFloat surplusPer = MAX(kDefaultMinDragBackgroundAlpha, percent);;
            CGFloat minDragDis = ABS(self.popupParam.dragAutoDissmissMinDistance);
            
            BOOL continueFlow = [self.popupDelegate tf_popupViewDidDragSlide:self distancePercent:percent distance:distance state:state];
            
            if (continueFlow) {
                if (distance >= minDragDis) {
                    //拖动距离大于最小拖动消失距离自动滑动消失
                    CGFloat duration = MAX(0.1, (kDefaultAnimationDuration * surplusPer));
                    [UIView animateKeyframesWithDuration:duration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                        weakself.frame = weakself.extension.dragDissmissFrame;
                        if (weakself.extension.runtimeDragStyle == DragStyleFree) {
                            if (weakself.extension.defaultBackgroundView) {
                                weakself.extension.defaultBackgroundView.alpha = 1;
                            }
                        }else{
                            if (weakself.extension.defaultBackgroundView) {
                                weakself.extension.defaultBackgroundView.alpha = 0;
                            }
                        }
                    } completion:^(BOOL finished) {
                        if (weakself.extension.runtimeDragStyle != DragStyleFree) {
                            [weakself tf_remove];
                        }
                    }];
                }else{
                    //拖动距离小于最小拖动消失距离自动回到原位
                    [UIView animateKeyframesWithDuration:kDefaultAnimationDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                        weakself.frame = weakself.extension.showToFrame;
                        if (weakself.extension.defaultBackgroundView) {
                            weakself.extension.defaultBackgroundView.alpha = 1;
                        }
                    } completion:nil];
                }
            }
        }
    }
}


//拖动距离百分比代理,默认改变背景视图的透明度
- (BOOL)tf_popupViewDidDragSlide:(UIView *)popup distancePercent:(CGFloat)percent distance:(CGFloat)distance state:(UIGestureRecognizerState)state{
    if (self.superview && self.extension.defaultBackgroundView) {
        percent = percent > kDefaultMinDragBackgroundAlpha ? percent : kDefaultMinDragBackgroundAlpha;
        self.extension.defaultBackgroundView.alpha = percent;
    }
    return YES;
}


-(CGFloat)percentOfDragAndOrigin{
    CGFloat distance = [self distanceOfShowToFrameAndNow];
    CGFloat max = [self radiusOfMaxDragArea];
    CGFloat percnet = 1 - distance / max;
    return percnet;
}

//拖动-根据拖拽方向得出拖动最大半径,以用于计算拖动于屏幕的百分比
-(CGFloat)radiusOfMaxDragArea{
    CGFloat max = MAX(self.extension.popupArea.height, self.extension.popupArea.width);
    switch (self.extension.runtimeDragStyle) {
        case DragStyleToTop:
        case DragStyleToBottom:{
            max = self.extension.popupArea.height * 0.5;
        }break;
        case DragStyleToLeft:
        case DragStyleToRight:{
            max = self.extension.popupArea.width * 0.5;
        }break;
        default:break;
    }
    return max;
}

//拖动-计算当前拖动位置和展示位置的中点距离
-(CGFloat)distanceOfShowToFrameAndNow{
    CGPoint nowCenter = CGPointMake(self.frame.origin.x + self.frame.size.width * 0.5,
                                    self.frame.origin.y + self.frame.size.height * 0.5);
    CGPoint showedCenter = CGPointMake(self.extension.showToFrame.origin.x + self.extension.showToFrame.size.width * 0.5,
                                       self.extension.showToFrame.origin.y + self.extension.showToFrame.size.height * 0.5);
    CGFloat distance = tf_pointDistance(nowCenter, showedCenter);
    return distance;
}

//两点间距离
static inline CGFloat tf_pointDistance(CGPoint p0,CGPoint p1){
    CGFloat a = ABS(p1.x - p0.x);
    CGFloat b = ABS(p1.y - p0.y);
    return sqrt((a * a + b * b));
}

//延时
static inline void tf_popupDelay(NSTimeInterval interval,dispatch_block_t block){
    if (!block) {return;}
    if (interval == 0) {
        block();
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((interval) * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
    }
}
//通过id查找弹窗，如果多个弹窗id一样，则返回最先弹出的弹窗
+(UIView *)tf_findPopup:(NSString *)identifier{
    return [TFPopupPool findPopup:identifier];
}

//获取所有已弹出的弹窗
+(NSArray <UIView *>*)tf_getAllPopup{
    return [TFPopupPool allPopup];
}

//消失
-(void)tf_hide{
    x_weakSelf;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewWillHide:)]) {
        BOOL continueAnimation = [self.popupDelegate tf_popupViewWillHide:self];
        if (continueAnimation == NO) {
            return;
        }
    }
    
    TFPopupPrivateExtension *ext = getRunCache(self);
    ext.currentIsShowState = NO;
    ext.hideAnimationCount = 0;
    
    BOOL hasAlphaAniamtion = NO;
    BOOL hasFrameAniamtion = NO;
    BOOL hasBaseAniamtion = NO;
    BOOL hasMaskAniamtion = NO;
    if (self.extension.disuseHideAlphaAnimation == NO &&
        self.extension.hideFromAlpha != self.extension.hideToAlpha) {
        
        hasAlphaAniamtion = YES;
        ext.hideAnimationCount += 1;
        [UIView animateWithDuration:self.extension.hideAnimationDuration
                              delay:self.extension.hideAnimationDelay
                            options:self.extension.hideAnimationOptions
                         animations:^{
            weakself.alpha = weakself.extension.hideToAlpha;
        } completion:^(BOOL finished) {
            [weakself hideAnimationCompletion];
        }];
    }
    
    if (self.extension.disuseHideFrameAnimation == NO &&
        (CGRectEqualToRect(self.extension.hideFromFrame, self.extension.hideToFrame) == NO)) {
        
        hasFrameAniamtion = YES;
        ext.hideAnimationCount += 1;
        [UIView animateWithDuration:self.extension.hideAnimationDuration
                              delay:self.extension.hideAnimationDelay
                            options:self.extension.hideAnimationOptions
                         animations:^{
            weakself.frame = weakself.extension.hideToFrame;
        } completion:^(BOOL finished) {
            [weakself hideAnimationCompletion];
        }];
    }
    
    //动画
    if (popupStyleInclude(self.extension.style, PopupStyleExtensionAniamtion)) {
        CAAnimation *animation = [self animation:self.popupParam.hideKeyPath
                                            from:self.popupParam.hideFromValue
                                              to:self.popupParam.hideToValue
                                             dur:self.popupParam.duration];
        if (animation){
            hasBaseAniamtion = YES;
            ext.hideAnimationCount += 1;
            animation.delegate = self;
            tf_popupDelay(self.extension.showAnimationDelay, ^{
                [weakself.layer addAnimation:animation forKey:kHideBaseAnimationKey];
            });
        }
    }
    
    //遮罩
    if (popupStyleInclude(self.extension.style, PopupStyleExtensionMask)) {
        NSTimeInterval dur = self.popupParam.duration;
        NSString *keyPath = @"path";
        CAShapeLayer *mask = self.layer.mask;
        [mask removeAnimationForKey:NSStringFromClass([self class])];
        id from = (__bridge id)self.popupParam.maskHideFromPath.CGPath;
        if (from == nil) {
            from = (__bridge id)self.popupParam.maskShowToPath.CGPath;
        }
        id to = (__bridge id)self.popupParam.maskHideToPath.CGPath;
        if (to == nil) {
            to = (__bridge id)self.popupParam.maskShowFromPath.CGPath;
        }
        CAAnimation *animation = [self animation:keyPath from:from to:to dur:dur];
        if (animation){
            hasMaskAniamtion = YES;
            ext.hideAnimationCount += 1;
            animation.delegate = self;
            __weak typeof(mask) weakMask = mask;
            tf_popupDelay(self.extension.showAnimationDelay, ^{
                [weakMask addAnimation:animation forKey:kHideMaskAnimationKey];
            });
        }
    }
    
    BOOL removeIfNoAnyAnimation = YES;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewDidHide:)]) {
        removeIfNoAnyAnimation = [self.popupDelegate tf_popupViewDidHide:self];
    }
    if ((hasAlphaAniamtion || hasFrameAniamtion || hasBaseAniamtion || hasMaskAniamtion) == NO) {
        if (removeIfNoAnyAnimation) {
            [self tf_remove];
        }
    }
}

#pragma mark -- CAAnimationDelegate
- (void)animationDidStart:(CAAnimation *)anim{
    
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    TFPopupPrivateExtension *ext = getRunCache(self);
    if (ext.currentIsShowState) {
        [self showAnimationCompletion];
    }else{
        [self hideAnimationCompletion];
    }
}

#pragma mark -- TFPopupDataSource
- (UIView *)tf_popupInView:(UIView *)popup{
    return self.inView;
}

- (CGSize  )tf_popupInArea:(UIView *)popup{
    return self.popupParam.popupAreaRect.size;
}

- (BOOL    )tf_popupView:(UIView *)popup animationWithAlphaForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            return !self.popupParam.disuseShowPopupAlphaAnimation;
        }break;
        case TFPopupStateHide:{
            return !self.popupParam.disuseHidePopupAlphaAnimation;
        }break;
        default:break;
    }
    return YES;
}
- (CGFloat )tf_popupView:(UIView *)popup fromAlphaForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            return 0;
        }break;
        case TFPopupStateHide:{
            return 1;
        }break;
        default:break;
    }
    return NO;
}
- (CGFloat )tf_popupView:(UIView *)popup toAlphaForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            return 1;
        }break;
        case TFPopupStateHide:{
            return 0;
        }break;
        default:break;
    }
    return NO;
}

- (BOOL    )tf_popupView:(UIView *)popup animationWithFrameForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            return !self.popupParam.disuseShowPopupFrameAnimation;
        }break;
        case TFPopupStateHide:{
            return !self.popupParam.disuseHidePopupFrameAnimation;
        }break;
        default:break;
    }
    return YES;
}
- (CGRect  )tf_popupView:(UIView *)popup fromFrameForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero) == NO) {
                return self.popupParam.popOriginFrame;
            }
            return normalOriginFrame(self.popupParam);
        }break;
        case TFPopupStateHide:{
            if (CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero) == NO) {
                return self.popupParam.popTargetFrame;
            }
            return normalTargetFrame(self.popupParam);
        }break;
        default:break;
    }
    return CGRectZero;
}
- (CGRect  )tf_popupView:(UIView *)popup toFrameForState:(TFPopupState)state{
    switch (state) {
        case TFPopupStateShow:{
            if (CGRectEqualToRect(self.popupParam.popTargetFrame, CGRectZero) == NO) {
                return self.popupParam.popTargetFrame;
            }
            return normalTargetFrame(self.popupParam);
        }break;
        case TFPopupStateHide:{
            if (CGRectEqualToRect(self.popupParam.popOriginFrame, CGRectZero) == NO) {
                return self.popupParam.popOriginFrame;
            }
            return normalOriginFrame(self.popupParam);
        }break;
        default:break;
    }
    return CGRectZero;
}
- (NSTimeInterval)tf_popupView:(UIView *)popup animationDurationForState:(TFPopupState)state{
    if (self.popupParam.duration > 0) {
        return self.popupParam.duration;
    }
    return kDefaultAnimationDuration;
}
- (NSTimeInterval)tf_popupView:(UIView *)popup animationDelayForState:(TFPopupState)state{
    if (state == TFPopupStateShow) {
        return MAX(self.popupParam.showAnimationDelay, 0.0);
    }else if(state == TFPopupStateHide){
        return MAX(self.popupParam.hideAnimationDelay, 0.0);
    }
    return 0;
}
- (UIViewAnimationOptions)tf_popupView:(UIView *)popup animationOptionsForState:(TFPopupState)state{
    if (self.popupParam.animationOptions == 0) {
        return UIViewAnimationOptionCurveEaseOut;
    }
    return self.popupParam.animationOptions;
}

- (BOOL)tf_popupView:(UIView *)popup enableScrollViewGestureRecognizerWhenDrag:(UIScrollView *)scrollView{
    return self.popupParam.discernScrollEnable;
}

#pragma mark -- TFPopupBackgroundDelegate
- (NSInteger)tf_popupBackgroundViewCount:(UIView *)popup{
    return 0;
}
- (UIView *)tf_popupView:(UIView *)popup backgroundViewAtIndex:(NSInteger)index{
    return nil;
}
- (CGRect)tf_popupView:(UIView *)popup backgroundViewFrameAtIndex:(NSInteger)index{
    return CGRectZero;
}

#pragma mark -- TFPopupDelegate
- (void)tf_popupViewWillGetConfiguration:(UIView *)popup{
    x_weakSelf;
    if (self.extension.delegateProcessBlock) {
        self.extension.delegateProcessBlock(weakself,DelegateProcessWillGetConfiguration);
    }
}
- (void)tf_popupViewDidGetConfiguration:(UIView *)popup{
    x_weakSelf;
    if (self.extension.delegateProcessBlock) {
        self.extension.delegateProcessBlock(weakself,DelegateProcessDidGetConfiguration);
    }
}
- (BOOL)tf_popupViewWillShow:(UIView *)popup{
    x_weakSelf;
    [self showDefaultBackground];
    if (self.extension.delegateProcessBlock) {
        self.extension.delegateProcessBlock(weakself,DelegateProcessWillShow);
    }
    return YES;
}
- (void)tf_popupViewDidShow:(UIView *)popup{
    x_weakSelf;
    if (self.extension.delegateProcessBlock) {
        self.extension.delegateProcessBlock(weakself,DelegateProcessDidShow);
    }
}
- (void)tf_popupViewShowAnimationDidFinish:(UIView *)popup{
    x_weakSelf;
    if (self.extension.delegateProcessBlock) {
        self.extension.delegateProcessBlock(weakself,DelegateProcessShowAnimationDidFinish);
    }
}

- (BOOL)tf_popupViewWillHide:(UIView *)popup{
    x_weakSelf;
    [self hideDefaultBackground];
    if (self.extension.delegateProcessBlock) {
        self.extension.delegateProcessBlock(weakself,DelegateProcessWillHide);
    }
    return YES;
}
- (BOOL)tf_popupViewDidHide:(UIView *)popup{
    x_weakSelf;
    if (self.extension.delegateProcessBlock) {
        self.extension.delegateProcessBlock(weakself,DelegateProcessDidHide);
    }
    return YES;
}
- (BOOL)tf_popupViewHideAnimationDidFinish:(UIView *)popup{
    x_weakSelf;
    if (self.extension.delegateProcessBlock) {
        self.extension.delegateProcessBlock(weakself,DelegateProcessHideAnimationDidFinish);
    }
    return YES;
}

- (BOOL)tf_popupViewBackgroundDidTouch:(UIView *)popup{
    x_weakSelf;
    if (self.extension.delegateProcessBlock) {
        self.extension.delegateProcessBlock(weakself,DelegateProcessBackgroundDidTouch);
    }
    return YES;
}

#pragma mark -- 收尾函数
-(void)showDefaultBackground{
    x_weakSelf;
    if (self.popupParam.disuseBackground) {
        return;
    }
    if (self.extension.backgroundViewCount <= 0) {
        if (self.extension.defaultBackgroundView) {
            if (self.popupParam.disuseShowBackgroundAlphaAnimation) {
                self.extension.defaultBackgroundView.alpha = 1;
            }else{
                [UIView animateWithDuration:self.extension.showAnimationDuration
                                      delay:self.extension.showAnimationDelay
                                    options:self.extension.showAnimationOptions
                                 animations:^{
                    weakself.extension.defaultBackgroundView.alpha = 1;
                } completion:nil];
            }
        }
    }
}

-(void)hideDefaultBackground{
    x_weakSelf;
    if (self.popupParam.disuseBackground) {
        return;
    }
    if (self.extension.backgroundViewCount <= 0) {
        if (self.extension.defaultBackgroundView) {
            if (self.popupParam.disuseHideBackgroundAlphaAnimation) {
                self.extension.defaultBackgroundView.alpha = 0;
                [self.extension.defaultBackgroundView removeFromSuperview];
            }else{
                [UIView animateWithDuration:self.extension.hideAnimationDuration
                                      delay:self.extension.hideAnimationDelay
                                    options:self.extension.hideAnimationOptions
                                 animations:^{
                    weakself.extension.defaultBackgroundView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakself.extension.defaultBackgroundView removeFromSuperview];
                }];
            }
        }
    }
}

#pragma mark -- 监听代理过程block
//监听弹框隐藏完毕回调
-(void)tf_observerDelegateProcess:(TFDelegateProcessBlock)delegateProcessBlock{
    if (delegateProcessBlock) {
        self.extension.delegateProcessBlock = delegateProcessBlock;
    }
}

-(void)showAnimationCompletion{
    TFPopupPrivateExtension *ext = getRunCache(self);
    ext.showAnimationCount -= 1;
    if (ext.showAnimationCount == 0) {
        deleteRunCache(self);
        if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewShowAnimationDidFinish:)]) {
            [self.popupDelegate tf_popupViewShowAnimationDidFinish:self];
        }
        
    }
}
-(void)hideAnimationCompletion{
    TFPopupPrivateExtension *ext = getRunCache(self);
    ext.hideAnimationCount -= 1;
    if (ext.hideAnimationCount == 0) {
        deleteRunCache(self);
        BOOL removeIfAllAnimationFinish = YES;
        if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewHideAnimationDidFinish:)]) {
            removeIfAllAnimationFinish = [self.popupDelegate tf_popupViewHideAnimationDidFinish:self];
            //如果有延迟,取消之前的延迟
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tf_hide) object:nil];
        }
        if (removeIfAllAnimationFinish) {
            [self tf_remove];
        }
    }
}

-(void)tf_remove{
    
    [self.layer removeAllAnimations];
    if (self.layer.mask) [self.layer.mask removeAllAnimations];
    [self removeFromSuperview];
    if (self.extension.backgroundViewCount <= 0) {
        [self.extension.defaultBackgroundView removeFromSuperview];
    }else{
        [self.extension.backgroundViewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    self.extension.defaultBackgroundView = nil;
    self.extension.backgroundViewCount = 0;
    [self.extension.backgroundViewArray removeAllObjects];
    [self.extension.backgroundViewFrameArray removeAllObjects];
    [TFPopupPool refreshPool];
}


#pragma mark -- 点击事件
-(void)defaultBackgroundViewClick:(UIButton *)ins{
    if (self.popupParam.disuseBackgroundTouchHide) {
        return;
    }
    BOOL continueAnimation = YES;
    if ([self.popupDelegate respondsToSelector:@selector(tf_popupViewBackgroundDidTouch:)]) {
        continueAnimation = [self.popupDelegate tf_popupViewBackgroundDidTouch:self];
    }
    if (continueAnimation) {
        [self tf_hide];
    }
}

#pragma mark -- 封装函数

static inline BOOL dragStyleInclude(DragStyle total,DragStyle inc){
    return ((total & inc) == inc);
}

static NSMutableDictionary *_tfPopupRunCache = nil;
static inline TFPopupPrivateExtension *getRunCache(NSObject *obj){
    if (obj == nil) {
        return nil;
    }
    if (_tfPopupRunCache == nil) {
        _tfPopupRunCache = [[NSMutableDictionary alloc]init];
    }
    NSString *addr = [NSString stringWithFormat:@"%p",obj];
    TFPopupPrivateExtension *ext = [_tfPopupRunCache objectForKey:addr];
    if (ext == nil) {
        ext = [[TFPopupPrivateExtension alloc]init];
        [_tfPopupRunCache setObject:ext forKey:addr];
    }
    return ext;
}
static inline void deleteRunCache(NSObject *obj){
    if (obj == nil) {
        return;
    }
    if (_tfPopupRunCache == nil) {
        _tfPopupRunCache = [[NSMutableDictionary alloc]init];
    }
    NSString *addr = [NSString stringWithFormat:@"%p",obj];
    [_tfPopupRunCache removeObjectForKey:addr];
}


-(CAAnimation *)animation:(NSString *)path from:(id)from to:(id)to dur:(NSTimeInterval)dur{
    
    if (path == nil || from == nil || to == nil || dur == 0.0) return nil;
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:path];
    [ani setFromValue:from];//设置起始值
    [ani setToValue:to];//设置目标值
    [ani setDuration:dur];//设置动画时间，单次动画时间
    [ani setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
    [ani setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [ani setAutoreverses:NO];
    [ani setFillMode:kCAFillModeBoth];
    
    return ani;
}

static inline BOOL popupStyleInclude(PopupStyle total,PopupStyle inc){
    return ((total & inc) == inc);
}


static inline CGRect normalOriginFrame(TFPopupParam *param){
    CGRect ar = param.popupAreaRect;
    CGSize s = param.popupSize;
    CGPoint st = param.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5 + st.x;
    CGFloat y = (ar.size.height - s.height) * 0.5 + st.y;
    return CGRectMake(x, y, s.width, s.height);
}

static inline CGRect normalTargetFrame(TFPopupParam *param){
    CGRect ar = param.popupAreaRect;
    CGSize s = param.popupSize;
    CGPoint st = param.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5 + st.x;
    CGFloat y = (ar.size.height - s.height) * 0.5 + st.y;
    return CGRectMake(x, y, s.width, s.height);
}


static inline UIBezierPath *foldPath(CGRect targetFrame,PopupDirection direction,BOOL target){
    CGSize ss = targetFrame.size;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 0;
    switch (direction) {
        case PopupDirectionTop:{
            x = 0;
            y = 0;
            w = ss.width;
            h = target?ss.height:0;
        }break;
        case PopupDirectionLeft:{
            x = 0;
            y = 0;
            w = target?ss.width:0;
            h = ss.height;
        }break;
        case PopupDirectionBottom:{
            x = 0;
            y = target?0:ss.height;
            w = ss.width;
            h = target?ss.height:0;
        }break;
        case PopupDirectionRight:{
            x = target?0:ss.width;
            y = 0;
            w = target?ss.width:0;
            h = ss.height;
        }break;
        default:break;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
    return path;
}


static inline CGRect bubbleTarget(CGPoint basePoint,
                                  CGSize popupSize,
                                  PopupDirection direction,
                                  CGPoint offset){
    
    CGFloat x = 0,y = 0,w = popupSize.width,h = popupSize.height;
    CGFloat halfw = popupSize.width * 0.5,halfh = popupSize.height * 0.5;
    switch (direction) {
        case PopupDirectionTop:{
            x = (basePoint.x - halfw) + offset.x;
            y = (basePoint.y - h) + offset.y;
        }break;
        case PopupDirectionTopRight:{
            x = basePoint.x + offset.x;
            y = (basePoint.y - h) + offset.y;
        }break;
        case PopupDirectionRight:{
            x = basePoint.x + offset.x;
            y = (basePoint.y - halfh) + offset.y;
        }break;
        case PopupDirectionRightBottom:{
            x = basePoint.x + offset.x;
            y = basePoint.y + offset.y;
        }break;
        case PopupDirectionBottom:{
            x = (basePoint.x - halfw) + offset.x;
            y = basePoint.y + offset.y;
        }break;
        case PopupDirectionBottomLeft:{
            x = (basePoint.x - w) + offset.x;
            y = basePoint.y + offset.y;
        }break;
        case PopupDirectionLeft:{
            x = (basePoint.x - w) + offset.x;
            y = (basePoint.y - halfh) + offset.y;
        }break;
        case PopupDirectionLeftTop:{
            x = (basePoint.x - w) + offset.x;
            y = (basePoint.y - h) + offset.y;
        }break;
        default:break;
    }
    return CGRectMake(x, y, w, h);
}


static inline UIBezierPath *bubblePath(CGSize popupSize,PopupDirection direction,BOOL target){
    CGSize ss = popupSize;
    CGFloat halfW = ss.width * 0.5;
    CGFloat halfH = ss.height * 0.5;
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 0;
    switch (direction) {
        case PopupDirectionTop:{
            x = target?0:halfW;
            y = target?0:ss.height;
            w = target?ss.width:0;
            h = target?ss.height:0;
        }break;
        case PopupDirectionTopRight:{
            x = 0;
            y = target?0:ss.height;
            w = target?ss.width:0;
            h = target?ss.height:0;
        }break;
        case PopupDirectionRight:{
            x = 0;
            y = target?0:halfH;
            w = target?ss.width:0;
            h = target?ss.height:0;
        }break;
        case PopupDirectionRightBottom:{
            x = 0;
            y = 0;
            w = target?ss.width:0;
            h = target?ss.height:0;
        }break;
        case PopupDirectionBottom:{
            x = target?0:halfW;
            y = 0;
            w = target?ss.width:0;
            h = target?ss.height:0;
        }break;
        case PopupDirectionBottomLeft:{
            x = target?0:ss.width;
            y = 0;
            w = target?ss.width:0;
            h = target?ss.height:0;
        }break;
        case PopupDirectionLeft:{
            x = target?0:ss.width;
            y = target?0:halfH;
            w = target?ss.width:0;
            h = target?ss.height:0;
        }break;
        case PopupDirectionLeftTop:{
            x = target?0:ss.width;
            y = target?0:ss.height;
            w = target?ss.width:0;
            h = target?ss.height:0;
        }break;
        default:break;
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
    return path;
}


static inline CGRect slideOriginFrame(TFPopupParam *param,PopupDirection direction){
    CGRect ar = param.popupAreaRect;
    CGSize s = param.popupSize;
    CGPoint st = param.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5;
    CGFloat y = (ar.size.height - s.height) * 0.5;
    CGFloat w = s.width;
    CGFloat h = s.height;
    switch (direction) {
        case PopupDirectionTop:{y = - s.height;x = x + st.x;}break;
        case PopupDirectionLeft:{x = - s.width;y = y + st.y;}break;
        case PopupDirectionBottom:{y = ar.size.height;x = x + st.x;}break;
        case PopupDirectionRight:{x = ar.size.width;y = y + st.y;}break;
        default:break;
    }
    CGRect position = CGRectMake(x, y, w, h);
    return position;
}

static inline CGRect slideTargetFrame(TFPopupParam *param,PopupDirection direction){
    CGRect ar = param.popupAreaRect;
    CGSize s = param.popupSize;
    CGPoint st = param.offset;
    CGFloat x = (ar.size.width - s.width) * 0.5;
    CGFloat y = (ar.size.height - s.height) * 0.5;
    CGFloat w = s.width;
    CGFloat h = s.height;
    switch (direction) {
        case PopupDirectionTop:{y = 0 + st.y;x = x + st.x;}break;
        case PopupDirectionLeft:{x = 0 + st.x;y = y + st.y;}break;
        case PopupDirectionBottom:{y = ar.size.height - s.height + st.y;x = x + st.x;}break;
        case PopupDirectionRight:{x = ar.size.width - s.width + st.x;y = y + st.y;}break;
        default:break;
    }
    CGRect position = CGRectMake(x, y, w, h);
    return position;
}


static inline NSMutableArray<UIView*>*allSubViews(UIView *target,BOOL containTarget){
    NSMutableArray *allSubviews = [NSMutableArray array];
    NSMutableArray *curSubviews = [NSMutableArray arrayWithArray:target.subviews];
    while (curSubviews.count!=0) {
        NSMutableArray *temSubviews = [NSMutableArray array];
        for (UIView *view in curSubviews) {
            [allSubviews addObject:view];
            if (view.subviews.count !=0) {
                [temSubviews addObjectsFromArray:view.subviews];
            }
        }
        [curSubviews removeAllObjects];
        [curSubviews addObjectsFromArray:temSubviews];
    }
    if (containTarget) {
        [allSubviews addObject:target];
    }
    return allSubviews;
}

#pragma mark -- 属性绑定
tf_synthesize_category_property_retain(inView, setInView);
tf_synthesize_category_property_copy(identifier, setIdentifier);
tf_synthesize_category_property_assign(popupDelegate, setPopupDelegate);
tf_synthesize_category_property_assign(popupDataSource, setPopupDataSource);
tf_synthesize_category_property_assign(backgroundDelegate, setBackgroundDelegate);
tf_synthesize_category_property_retain(popupParam, setPopupParam);

-(TFPopupExtension *)extension{
    id value = objc_getAssociatedObject(self, @selector(extension));
    if (value) {
        return value;
    }else{
        self.extension = [[TFPopupExtension alloc]init];
        value = self.extension;
    }
    return value;;
}
-(void)setExtension:(TFPopupExtension *)extension{
    objc_setAssociatedObject(self, @selector(extension), extension, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end


@implementation CAAnimation (TFPopup)
@dynamic startBlock,stopBlock;

-(BOOL)openOberserBlock{
    if (self.delegate == self) {
        return YES;
    }
    return NO;
}
-(void)setOpenOberserBlock:(BOOL)openOberserBlock{
    if (openOberserBlock && self.delegate == nil) {
        self.delegate = self;
    }
}

-(AnimationStartBlock)startBlock{
    id value = objc_getAssociatedObject(self, @selector(startBlock));
    if (value)return value;
    return nil;
}
-(void)setStartBlock:(AnimationStartBlock)startBlock{
    objc_setAssociatedObject(self, @selector(startBlock), startBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(AnimationStopBlock)stopBlock{
    id value = objc_getAssociatedObject(self, @selector(stopBlock));
    if (value)return value;
    return nil;
}

-(void)setStopBlock:(AnimationStopBlock)stopBlock{
    objc_setAssociatedObject(self, @selector(stopBlock), stopBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(void)observerAnimationDidStart:(AnimationStartBlock)start{
    if (self.delegate == nil) {
        self.delegate = self;
    }
    self.startBlock = start;
}
-(void)observerAnimationDidStop:(AnimationStopBlock)stop{
    if (self.delegate == nil) {
        self.delegate = self;
    }
    self.stopBlock = stop;
}

-(void)animationDidStart:(CAAnimation *)anim{
    if (self.startBlock) {
        self.startBlock(anim);
    }
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (self.stopBlock) {
        self.stopBlock(anim, flag);
    }
}

@end





