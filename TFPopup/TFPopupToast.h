//
//  TFPopupToast.h
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TFPopupToast;
typedef void(^TFPopupToastPrepareBlock)(TFPopupToast *toast);

@interface TFPopupToast : UIView

@property(nonatomic,  copy)NSString *msg;
@property(nonatomic,strong)UILabel  *msgLabel;
@property(nonatomic,assign)NSTimeInterval duration;

+(void)showToast:(UIView *)inview msg:(NSString *)msg;

+(void)showToast:(UIView *)inview
             msg:(NSString *)msg
      custemShow:(TFPopupToastPrepareBlock)custemShowBlock
      custemHide:(TFPopupToastPrepareBlock)custemHideBlock;
@end


