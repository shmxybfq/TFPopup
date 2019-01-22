//
//  TFPopupParam.h
//  TFPopupDemo
//
//  Created by Time on 2019/1/18.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TFPopupParam : NSObject

//动画时间 默认0.3
@property(nonatomic,assign)NSTimeInterval duration;
//自动消失时间 默认0.3
@property(nonatomic,assign)NSTimeInterval autoDissmissDuration;
//是否使用 背景视图 (0.3-alpha的黑色视图)
@property(nonatomic,strong)UIView *coverView;
@property(nonatomic,assign)BOOL noCoverView;
@property(nonatomic,assign)BOOL noCoverTouchHide;
@property(nonatomic,assign)BOOL coverBackgroundColorClear;
//背景视图 是否 alpha 动画展示出来
@property(nonatomic,assign)BOOL noCoverAlphaAnimation;
//弹出框 是否 alpha 动画展示出来
@property(nonatomic,assign)BOOL noPopupAlphaAnimation;
//保持弹框原来的frame不重新计算
@property(nonatomic,assign)BOOL keepPopupOriginFrame;
//弹出框 弹出所在区域的大小【父视图的bounds】
@property(nonatomic,assign)CGRect popupAreaRect;


//只对 PopupStyleScale 有效 默认 transform.scale 更多keyPath 动画请使用自定动画方式
@property(nonatomic,  copy)NSString *scaleShowProperty;
//只对 PopupStyleScale 有效 默认 transform.scale 更多keyPath 动画请使用自定动画方式
@property(nonatomic,  copy)NSString *scaleHideProperty;

//只对 PopupStyleFrame 有效 弹出框初始尺寸,宽高为一起为 0 是点弹出,宽高单个为 0 是折叠展开弹出
@property(nonatomic,assign)CGRect popOriginFrame;
//只对 PopupStyleFrame 有效 弹出框目标尺寸,宽高为一起为 0 是点弹出,宽高单个为 0 是折叠展开弹出
@property(nonatomic,assign)CGRect popTargetFrame;

//只对 PopupStyleMask 有效
@property(nonatomic,strong)UIBezierPath *maskShowFromPath;
@property(nonatomic,strong)UIBezierPath *maskShowToPath;
@property(nonatomic,strong)UIBezierPath *maskHideFromPath;
@property(nonatomic,strong)UIBezierPath *maskHideToPath;

@end

