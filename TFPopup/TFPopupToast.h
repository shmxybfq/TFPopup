//
//  TFPopupToast.h
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TFToastAnimationType) {
    TFToastAnimationTypeFade,
    TFToastAnimationTypeScale,
};

@class TFPopupToast;
typedef void(^TFPopupToastBlock)(TFPopupToast *toast);

@interface TFPopupToast : UIView

@property(nonatomic,strong)UILabel  *msgLabel;

+(void)tf_show:(UIView *)inView msg:(NSString *)msg animationType:(TFToastAnimationType)animationType;

+(void)tf_show:(UIView *)inView
           msg:(NSString *)msg
        offset:(CGPoint)offset
dissmissDuration:(NSTimeInterval)duration
 animationType:(TFToastAnimationType)animationType
   custemBlock:(TFPopupToastBlock)custemBlock;

@end


