//
//  TFPopupManager.m
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "TFPopupManager.h"
@interface TFPopupManager()

@property(nonatomic,  weak)id<TFPopupManagerDataSource>dataSource;
@property(nonatomic,  weak)id<TFPopupManagerDelegate>delegate;

@property(nonatomic,assign)BOOL popForViewOriginUserInteractionEnabled;

@end

@implementation TFPopupManager


+(TFPopupManager *)tf_popupManagerDataSource:(id<TFPopupManagerDataSource>)dataSource
                                    delegate:(id<TFPopupManagerDelegate>)delegate{
    
    TFPopupManager *ins = [[TFPopupManager alloc]init];
    ins.dataSource = dataSource;
    ins.delegate = delegate;
    
    return ins;
}

-(void)show{
    [self performSelectorOnMainThread:@selector(excuteShow)
                           withObject:nil
                        waitUntilDone:YES];
}

-(void)excuteShow{
    x_weakSelf;
    __block BOOL animationStop = NO;
    if ([self.delegate respondsToSelector:@selector(tf_popupManager_willShow:tellToManager:)]) {
        animationStop = [self.delegate tf_popupManager_willShow:self tellToManager:^(BOOL stopDefaultAnimation, NSTimeInterval duration) {
            animationStop = stopDefaultAnimation;
            weakself.custemAnimationDuration = duration;
        }];
    }
    if (animationStop == YES) {
        return;
    }

    
    //不需要动画
    if (self.defaultAnimation == TFPopupDefaultAnimationNone) {
        self.popForCoverView.alpha = 1;
        self.popBoardView.alpha = 1;
        self.popBoardView.frame = self.popBoardViewEndFrame;
        [self finishShow:TFPopupDefaultAnimationNone isAnimationShow:NO];
    }else{
        
        //动画前禁止被弹视图用户交互
        self.popForViewOriginUserInteractionEnabled = self.popForView.userInteractionEnabled;
        self.popForView.userInteractionEnabled = NO;
        NSTimeInterval max = MAX(self.custemAnimationDuration, self.defaultAnimationDuration);
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(max * NSEC_PER_SEC));
        dispatch_after(time, dispatch_get_main_queue(), ^{
            weakself.popForView.userInteractionEnabled = weakself.popForViewOriginUserInteractionEnabled;
        });
        
        //遮罩-透明度动画
        if (self.popForCoverView){
            if ((self.defaultAnimation & TFPopupDefaultAnimationCoverAlpha) == TFPopupDefaultAnimationCoverAlpha){
                [UIView animateWithDuration:self.defaultAnimationDuration animations:^{
                    weakself.popForCoverView.alpha = 1;
                } completion:^(BOOL finished) {
                    [weakself finishShow:TFPopupDefaultAnimationCoverAlpha isAnimationShow:YES];
                }];
            }else{
                self.popForCoverView.alpha = 1;
                [self finishShow:TFPopupDefaultAnimationCoverAlpha isAnimationShow:NO];
            }
        }
        
        
        //弹出框-透明度动画
        if ((self.defaultAnimation & TFPopupDefaultAnimationPopBoardAlpha) == TFPopupDefaultAnimationPopBoardAlpha){
            if (self.popBoardView) {
                [UIView animateWithDuration:self.defaultAnimationDuration animations:^{
                    weakself.popBoardView.alpha = 1;
                } completion:^(BOOL finished) {
                    [weakself finishShow:TFPopupDefaultAnimationPopBoardAlpha isAnimationShow:YES];
                }];
            }
        }else{
            self.popBoardView.alpha = 1;
            [self finishShow:TFPopupDefaultAnimationPopBoardAlpha isAnimationShow:NO];
        }
        
        //弹出框-位移动画
        if ((self.defaultAnimation & TFPopupDefaultAnimationPopBoardFrame) == TFPopupDefaultAnimationPopBoardFrame){
            if (self.popBoardView) {
                [UIView animateWithDuration:self.defaultAnimationDuration animations:^{
                    weakself.popBoardView.frame = weakself.popBoardViewEndFrame;
                } completion:^(BOOL finished) {
                    [weakself finishShow:TFPopupDefaultAnimationPopBoardFrame isAnimationShow:YES];
                }];
            }
        }else{
            self.popBoardView.frame = weakself.popBoardViewEndFrame;
            [self finishShow:TFPopupDefaultAnimationPopBoardFrame isAnimationShow:NO];
        }
    }
}

-(void)finishShow:(TFPopupDefaultAnimation)animation isAnimationShow:(BOOL)isAnimationShow{
    if ([self.delegate respondsToSelector:@selector(tf_popupManager_didShow:defaultAnimation:isAnimationShow:)]) {
        [self.delegate tf_popupManager_didShow:self
                              defaultAnimation:animation
                               isAnimationShow:isAnimationShow];
    }
}
-(void)finishHide:(TFPopupDefaultAnimation)animation isAnimationHide:(BOOL)isAnimationHide{
    if ([self.delegate respondsToSelector:@selector(tf_popupManager_didHide:defaultAnimation:isAnimationHide:)]) {
        [self.delegate tf_popupManager_didHide:self
                              defaultAnimation:animation
                               isAnimationHide:isAnimationHide];
    }
}

-(void)hide{
    [self performSelectorOnMainThread:@selector(excuteHide)
                           withObject:nil
                        waitUntilDone:YES];
}

-(void)excuteHide{
    x_weakSelf;
    __block BOOL animationStop = NO;
    if ([self.delegate respondsToSelector:@selector(tf_popupManager_willHide:tellToManager:)]) {
        animationStop = [self.delegate tf_popupManager_willHide:self tellToManager:^(BOOL stopDefaultAnimation, NSTimeInterval duration) {
            animationStop = stopDefaultAnimation;
            weakself.custemAnimationDuration = duration;
        }];
    }
    if (animationStop == YES) {
        if (self.popForCoverView) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.custemAnimationDuration) * NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [weakself.popForCoverView removeFromSuperview];
            });
        }
        if (self.popBoardView) {
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.custemAnimationDuration) * NSEC_PER_SEC));
            dispatch_after(time, dispatch_get_main_queue(), ^{
                [weakself.popBoardView removeFromSuperview];
            });
        }
        return;
    }
    
    //不需要动画
    if (self.defaultAnimation == TFPopupDefaultAnimationNone) {
        self.popForCoverView.alpha = 0;
        self.popBoardView.alpha = 0;
        self.popBoardView.frame = self.popBoardViewBeginFrame;
        [self finishHide:TFPopupDefaultAnimationNone isAnimationHide:NO];
    }else{
        //遮罩-透明度动画
        if ((self.defaultAnimation & TFPopupDefaultAnimationCoverAlpha) == TFPopupDefaultAnimationCoverAlpha){
            if (self.popForCoverView){
                [UIView animateWithDuration:self.defaultAnimationDuration animations:^{
                    weakself.popForCoverView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakself finishHide:TFPopupDefaultAnimationCoverAlpha isAnimationHide:YES];
                    [weakself.popForCoverView removeFromSuperview];
                }];
            }
        }else{
            [self finishHide:TFPopupDefaultAnimationCoverAlpha isAnimationHide:NO];
            [self.popForCoverView removeFromSuperview];
        }
        
        //弹出框-透明度动画
        if ((self.defaultAnimation & TFPopupDefaultAnimationPopBoardAlpha) == TFPopupDefaultAnimationPopBoardAlpha){
            if (self.popBoardView) {
                [UIView animateWithDuration:self.defaultAnimationDuration animations:^{
                    weakself.popBoardView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakself finishHide:TFPopupDefaultAnimationPopBoardAlpha isAnimationHide:YES];
                    [weakself.popBoardView removeFromSuperview];
                }];
            }
        }else{
            [self finishHide:TFPopupDefaultAnimationPopBoardAlpha  isAnimationHide:NO];
        }
        
        //弹出框-位移动画
        if ((self.defaultAnimation & TFPopupDefaultAnimationPopBoardFrame) == TFPopupDefaultAnimationPopBoardFrame){
            if (self.popBoardView) {
                [UIView animateWithDuration:self.defaultAnimationDuration animations:^{
                    weakself.popBoardView.frame = weakself.popBoardViewBeginFrame;
                } completion:^(BOOL finished) {
                    [weakself finishHide:TFPopupDefaultAnimationPopBoardFrame  isAnimationHide:YES];
                    [weakself.popBoardView removeFromSuperview];
                }];
            }
        }else{
            [self finishHide:TFPopupDefaultAnimationPopBoardFrame  isAnimationHide:NO];
        }
        
        //弹出框-自定义动画
        if ((self.defaultAnimation & TFPopupDefaultAnimationCustem) == TFPopupDefaultAnimationCustem){
            if (self.popBoardView) {
                NSTimeInterval max = MAX(self.custemAnimationDuration, self.defaultAnimationDuration);
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(max * NSEC_PER_SEC));
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [weakself finishHide:TFPopupDefaultAnimationCustem isAnimationHide:YES];
                    [weakself.popBoardView removeFromSuperview];
                });
            }
        }else{
            [self finishHide:TFPopupDefaultAnimationCustem isAnimationHide:NO];
        }
        
        BOOL con0 = (self.defaultAnimation & TFPopupDefaultAnimationPopBoardAlpha) == TFPopupDefaultAnimationPopBoardAlpha;
        BOOL con1 = (self.defaultAnimation & TFPopupDefaultAnimationPopBoardFrame) == TFPopupDefaultAnimationPopBoardFrame;
        BOOL con2 = (self.defaultAnimation & TFPopupDefaultAnimationCustem) == TFPopupDefaultAnimationCustem;
        if ((con0 || con1 || con2) == NO) {
            [self.popBoardView removeFromSuperview];
        }
    }
}

-(void)testxxx{
    NSLog(@"333");

}

-(void)reload{
    
    /* 执行顺序:0 返回【默认使用的动画方式,可叠加】 */
    if ([self.dataSource respondsToSelector:@selector(tf_popupManager_popDefaultAnimation:)]) {
        self.defaultAnimation = [self.dataSource tf_popupManager_popDefaultAnimation:self];
    }
    
    self.popForView = nil;
    if ([self.dataSource respondsToSelector:@selector(tf_popupManager_popForView:)]) {
        self.popForView = [self.dataSource tf_popupManager_popForView:self];
    }
    if (self.popForView == nil) {
        NSLog(@"****** %@%@ ******",[self class],@"popForView 不能为空！");
        return;
    }
    
    //设置背景view
    if (self.popForCoverView) {
        [self.popForCoverView removeFromSuperview];
        self.popForCoverView = nil;
    }
    if ([self.dataSource respondsToSelector:@selector(tf_popupManager_popForCoverView:)]) {
        self.popForCoverView = [self.dataSource tf_popupManager_popForCoverView:self];
        self.popForCoverView.alpha = 0;
        [self.popForView addSubview:self.popForCoverView];
    }
    self.popForCoverViewFrame = CGRectZero;
    if (self.popForCoverView && [self.dataSource respondsToSelector:@selector(tf_popupManager_popForCoverViewPosition:coverView:)]) {
        self.popForCoverViewFrame = [self.dataSource tf_popupManager_popForCoverViewPosition:self coverView:self.popForCoverView];
        self.popForCoverView.frame = self.popForCoverViewFrame;
    }
    
    //弹出框view
    if (self.popBoardView) {
        [self.popBoardView removeFromSuperview];
        self.popBoardView = nil;
    }
    if ([self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardView:)]) {
        self.popBoardView = [self.dataSource tf_popupManager_popBoardView:self];
        //在弹框被添加到显示之前先让它隐藏起来
        self.popBoardView.alpha = 0;
        [self.popForView addSubview:self.popBoardView];
    }
    //弹出框view - position
    if (self.popBoardView && [self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardViewBeginPosition:boardView:)]) {
        self.popBoardViewBeginFrame = [self.dataSource tf_popupManager_popBoardViewBeginPosition:self boardView:self.popBoardView];
        self.popBoardView.frame = self.popBoardViewBeginFrame;
        //因为初始位置已经有了,如果支持alpha动画,先把alpha = 0,否则应该把弹框显示出来
        if ((self.defaultAnimation & TFPopupDefaultAnimationPopBoardAlpha) == TFPopupDefaultAnimationPopBoardAlpha){
            self.popBoardView.alpha = 0;
        }else{
            self.popBoardView.alpha = 1;
        }
    }
    if (self.popBoardView && [self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardViewEndPosition:boardView:)]) {
        self.popBoardViewEndFrame = [self.dataSource tf_popupManager_popBoardViewEndPosition:self boardView:self.popBoardView];
    }
    
    
    self.popBoardItemCount = 0;
    if (self.popBoardView && [self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardItemCount:)]) {
        self.popBoardItemCount = [self.dataSource tf_popupManager_popBoardItemCount:self];
    }
    NSArray *itemViews = [NSArray arrayWithArray:self.popBoardItemViews];
    for (UIView *v in itemViews) {[v removeFromSuperview];}
    [self.popBoardItemViews removeAllObjects];
    [self.popBoardItemFrames removeAllObjects];
    
    for (NSInteger i = 0; i < self.popBoardItemCount; i++) {
        if ([self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardItemView:index:)]) {
            UIView *view = [self.dataSource tf_popupManager_popBoardItemView:self index:i];
            if (view && [self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardItemPersition:itemView:index:)]) {
                [self.popBoardView addSubview:view];
                CGRect frame = [self.dataSource tf_popupManager_popBoardItemPersition:self
                                                                             itemView:view
                                                                                index:i];
                view.frame = frame;
                [self.popBoardItemFrames addObject:NSStringFromCGRect(frame)];
                [self.popBoardItemViews addObject:view];
            }
        }
    }
    
    self.defaultAnimationDuration = 0.3;
    if ([self.dataSource respondsToSelector:@selector(tf_popupManager_popDefaultAnimationDuration:)]) {
        self.defaultAnimationDuration = [self.dataSource tf_popupManager_popDefaultAnimationDuration:self];
    }
}

-(NSMutableArray *)popBoardItemFrames{
    if (_popBoardItemFrames == nil) {
        _popBoardItemFrames = [[NSMutableArray alloc]init];
    }
    return _popBoardItemFrames;
}

-(NSMutableArray *)popBoardItemViews{
    if (_popBoardItemViews) {
        _popBoardItemViews = [[NSMutableArray alloc]init];
    }
    return _popBoardItemViews;
}


@end
