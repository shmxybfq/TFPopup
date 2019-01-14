//
//  TFPopupToast.h
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFPopupToast;
typedef void(^TFPopupToastBlock)(TFPopupToast *toast);

@interface TFPopupToast : UIView

@property(nonatomic,  copy)NSString *msg;
@property(nonatomic,strong)UILabel  *msgLabel;
@property(nonatomic,assign)NSTimeInterval animtionDuration;
@property(nonatomic,assign)NSTimeInterval autoDissDuration;


+(void)showToast:(UIView *)inView msg:(NSString *)msg;

+(void)showToast:(UIView *)inView
             msg:(NSString *)msg
 animationFinish:(TFPopupToastBlock)animationFinishBlock;

+(void)showToast:(UIView *)inView
             msg:(NSString *)msg
      custemShow:(TFPopupToastBlock)custemShowBlock
      custemHide:(TFPopupToastBlock)custemHideBlock
 animationFinish:(TFPopupToastBlock)animationFinishBlock;

@end


