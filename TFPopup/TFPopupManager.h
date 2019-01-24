//
//  TFPopupManager.h
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFPopupProtocol.h"

/*
 * 弱引用
 */
#ifndef x_weakSelf
#define x_weakSelf __weak typeof(self) weakself = self
#endif

@interface TFPopupManager : UIView

//从代理获取的属性
@property(nonatomic,strong)UIView *popForView;
@property(nonatomic,strong)UIView *popForBackgroundView;
@property(nonatomic,assign)CGRect  popForBackgroundViewFrame;
@property(nonatomic,strong)UIView *popBoardView;
@property(nonatomic,assign)CGRect  popBoardViewBeginFrame;
@property(nonatomic,assign)CGRect  popBoardViewEndFrame;
@property(nonatomic,assign)NSInteger popBoardItemCount;
@property(nonatomic,strong)NSMutableArray *popBoardItemViews;
@property(nonatomic,strong)NSMutableArray *popBoardItemFrames;
@property(nonatomic,assign)TFPopupDefaultAnimation defaultAnimation;
@property(nonatomic,assign)NSTimeInterval defaultAnimationDuration;
@property(nonatomic,assign)NSTimeInterval custemAnimationDuration;

+(TFPopupManager *)tf_popupManagerDataSource:(id<TFPopupManagerDataSource>)dataSource
                                    delegate:(id<TFPopupManagerDelegate>)delegate;
-(void)reload;
-(void)show;
-(void)hide;
-(void)remove;

@end

