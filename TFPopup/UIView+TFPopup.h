//
//  UIView+TFPopup.h
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPopupManager.h"

#ifndef tf_synthesize_category_property
#define tf_synthesize_category_property(getter,settter,objc_AssociationPolicy,TYPE)\
- (TYPE)getter{return objc_getAssociatedObject(self, @selector(getter));}\
- (void)settter:(TYPE)obj{objc_setAssociatedObject(self, @selector(getter), obj, objc_AssociationPolicy);}
#endif


#ifndef tf_synthesize_category_property_retain
#define tf_synthesize_category_property_retain(getter,settter) tf_synthesize_category_property(getter,settter,OBJC_ASSOCIATION_RETAIN_NONATOMIC,id)
#endif


typedef NS_ENUM(NSInteger,PopupPosition) {
    PopupPositionCenter = 0,
    PopupPositionFromLeft,
    PopupPositionFromBottom,
    PopupPositionFromRight,
    PopupPositionFromTop,
};

typedef NS_ENUM(NSInteger,PopupStyle) {
    PopupStyleNone = 0,
    PopupStyleAlpha,
    PopupStyleScale,
    PopupStyleSlide,
    PopupStyleFold,
};

typedef void(^TFPopupBlock)(id inView);
@class TFPopupParam;
@interface UIView (TFPopup)<TFPopupManagerDataSource,TFPopupManagerDelegate>

@property(nonatomic,strong)UIView *inView;
@property(nonatomic,strong)TFPopupManager *manager;

@property(nonatomic,strong)TFPopupParam *popupParam;
@property(nonatomic,assign)PopupStyle style;
@property(nonatomic,assign)PopupPosition position;
@property(nonatomic,assign)CGRect popupAreaRect;
@property(nonatomic,assign)CGSize popupSize;


-(void)tf_show:(UIView *)inView
    popupParam:(TFPopupParam *)popupParam
         style:(PopupStyle)style
      position:(PopupPosition)position
 popupAreaRect:(CGRect)popupAreaRect
      willShow:(TFPopupBlock)willShow;

@end


@interface TFPopupParam : NSObject
//公有属性


//动画时间 默认0.3
@property(nonatomic,assign)NSTimeInterval duration;
//是否使用 背景视图 (0.3-alpha的黑色视图)
@property(nonatomic,assign)BOOL noCoverView;
//背景视图 是否 alpha 动画展示出来
@property(nonatomic,assign)BOOL noCoverAlphaAnimation;
//弹出框 是否 alpha 动画展示出来
@property(nonatomic,assign)BOOL noPopupAlphaAnimation;


//必传 PopupStyleNone,PopupStyleAlpha,PopupStyleSlide,PopupStyleScale 独有属性
//弹出框尺寸
@property(nonatomic,assign)CGSize popupSize;


//必传 PopupStyleFold 独有属性
//弹出框初始尺寸,宽高为一起为 0 是点弹出,宽高单个为 0 是线弹出
@property(nonatomic,assign)CGRect foldOriginFrame;
//弹出框目标尺寸,宽高为一起为 0 是点弹出,宽高单个为 0 是线弹出
@property(nonatomic,assign)CGRect foldTargetFrame;

@end
