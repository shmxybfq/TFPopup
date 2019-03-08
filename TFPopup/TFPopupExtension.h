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

@end


