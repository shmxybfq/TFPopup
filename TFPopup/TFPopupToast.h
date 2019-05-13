//
//  TFPopupToast.h
//  TFPopupDemo
//
//  Created by ztf on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPopupConst.h"

@class TFPopupToast;
typedef void(^TFPopupToastBlock)(TFPopupToast *toast);

@interface TFPopupToast : UIView

@property(nonatomic,assign)UIEdgeInsets edge;
@property(nonatomic,strong)UILabel  *msgLabel;

//注释同下
+(void)tf_show:(UIView *)inView msg:(NSString *)msg animationType:(TFAnimationType)animationType;

/* toast展示,默认黑底白字,底80%黑色不透明度
 * inView 容器视图
 * msg：弹出string
 * offset,弹框偏移,offset.x正为右移,offset.y正为下移
 * duration,自动消失时间，值为0时默认被设置为最低为1.5s,根据字数计算消失时间最大5s
 * animationType,动画方式，渐隐和缩放，默认渐隐
 * custemBlock,可在此回调内设置样式 */
+(void)tf_show:(UIView *)inView
           msg:(NSString *)msg
        offset:(CGPoint)offset
dissmissDuration:(NSTimeInterval)duration
 animationType:(TFAnimationType)animationType
   custemBlock:(TFPopupToastBlock)custemBlock;

@end


