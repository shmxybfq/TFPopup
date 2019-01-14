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

#ifndef tf_synthesize_category_property_assign
#define tf_synthesize_category_property_assign(getter,settter) tf_synthesize_category_property(getter,settter,OBJC_ASSOCIATION_ASSIGN,id)
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
    PopupStyleAlpha = 0,
    PopupStyleSlide,
    PopupStyleScale,
    PopupStyleFold,
};


@interface UIView (TFPopup)<TFPopupManagerDataSource,TFPopupManagerDelegate>

@property(nonatomic,strong)UIView *inView;
@property(nonatomic,strong)TFPopupManager *manager;

@property(nonatomic,assign)PopupStyle style;
@property(nonatomic,assign)PopupPosition position;
@property(nonatomic,assign)CGRect popupAreaRect;
@property(nonatomic,assign)CGSize popupSize;

-(void)tf_show:(UIView *)inView
         style:(PopupStyle)style
      position:(PopupPosition)position
 popupAreaRect:(CGRect)popupAreaRect
     popupSize:(CGSize)popupSize;


@end


