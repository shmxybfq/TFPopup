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
    if ([self.delegate respondsToSelector:@selector(tf_popupManager_willShow:)]) {
        [self.delegate tf_popupManager_willShow:self];
    }
    if (self.didCustemAnimation == NO) {
        [UIView animateWithDuration:self.duration animations:^{
            if (weakself.popForCoverView)
                weakself.popForCoverView.alpha = 1;
            weakself.popBoardView.frame = weakself.popBoardViewEndFrame;
        } completion:^(BOOL finished) {
            if ([weakself.delegate respondsToSelector:@selector(tf_popupManager_didShow:)]) {
                [weakself.delegate tf_popupManager_didShow:weakself];
            }
        }];
    }
}

-(void)hide{
    [self performSelectorOnMainThread:@selector(excuteHide)
                           withObject:nil
                        waitUntilDone:YES];
}

-(void)excuteHide{
    x_weakSelf;
    if ([self.delegate respondsToSelector:@selector(tf_popupManager_willHide:)]) {
        [self.delegate tf_popupManager_willHide:self];
    }
    if (self.didCustemAnimation == NO) {
        [UIView animateWithDuration:self.duration animations:^{
            if (weakself.popForCoverView)
                weakself.popForCoverView.alpha = 0;
            weakself.popBoardView.frame = weakself.popBoardViewBeginFrame;
        } completion:^(BOOL finished) {
            if ([weakself.delegate respondsToSelector:@selector(tf_popupManager_didHide:)]) {
                [weakself.delegate tf_popupManager_didHide:weakself];
            }
            [weakself.popForCoverView removeFromSuperview];
            [weakself.popBoardView removeFromSuperview];
        }];
    }
}

-(void)reload{
    
    //默认非自定义动画
    self.didCustemAnimation = NO;
    if ([self.dataSource respondsToSelector:@selector(tf_popupManager_didCustemAnimation:)]) {
        self.didCustemAnimation = [self.dataSource tf_popupManager_didCustemAnimation:self];
    }
    
    self.popForView = nil;
    if ([self.dataSource respondsToSelector:@selector(tf_popupManager_popForView:)]) {
        self.popForView = [self.dataSource tf_popupManager_popForView:self];
    }
    if (self.popForView == nil) {
        NSLog(@"****** %@%@ ******",[self class],@"popForView 不能为空！");
        return;
    }
    
    
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
    
    
    if (self.popBoardView) {
        [self.popBoardView removeFromSuperview];
        self.popBoardView = nil;
    }
    if ([self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardView:)]) {
        self.popBoardView = [self.dataSource tf_popupManager_popBoardView:self];
        [self.popForView addSubview:self.popBoardView];
    }
    if (self.popBoardView && [self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardViewBeginPosition:boardView:)]) {
        self.popBoardViewBeginFrame = [self.dataSource tf_popupManager_popBoardViewBeginPosition:self boardView:self.popBoardView];
        self.popBoardView.frame = self.popBoardViewBeginFrame;
    }
    if (self.popBoardView && [self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardViewEndPosition:boardView:)]) {
        self.popBoardViewEndFrame = [self.dataSource tf_popupManager_popBoardViewEndPosition:self boardView:self.popBoardView];
    }
    
    
    self.popBoardItemCount = 0;
    if (self.popBoardView && [self.dataSource respondsToSelector:@selector(tf_popupManager_popBoardItemCount:)]) {
        self.popBoardItemCount = [self.dataSource tf_popupManager_popBoardItemCount:self];
    }
    NSArray *itemViews = [NSArray arrayWithArray:self.popBoardItemViews];
    for (UIView *view in itemViews) {[view removeFromSuperview];}
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
    
    self.duration = 0.3;
    if ([self.dataSource respondsToSelector:@selector(tf_popupManager_popDuration:)]) {
        self.duration = [self.dataSource tf_popupManager_popDuration:self];
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
