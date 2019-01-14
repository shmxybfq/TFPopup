//
//  UIView+TFPopup.m
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "UIView+TFPopup.h"
#import <objc/runtime.h>

@implementation UIView (TFPopup)
@dynamic inView,manager,style,position;

tf_synthesize_category_property_retain(inView, setInView);
tf_synthesize_category_property_retain(manager, setManager);

-(void)tf_show:(UIView *)inView
         style:(PopupStyle)style
      position:(PopupPosition)position
     popupSize:(CGSize)popupSize{
    
    if (inView == nil) {NSLog(@"****** %@ %@ ******",[self class],@"inView 不能为空！");return;}
    if (self.manager == nil) {
        self.manager = [TFPopupManager tf_popupManagerDataSource:self delegate:self];
    }
    
    self.inView = inView;
    self.style = style;
    self.position = position;
    self.popupSize = popupSize;
    
    [self.manager performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    [self.manager performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}


#pragma mark 代理 TFPopupManagerDataSource 方法
/* 执行顺序:0 返回【是否使用默认动画方式】 */
-(BOOL)tf_popupManager_didCustemAnimation:(TFPopupManager *)manager{
    return NO;
}

/* 执行顺序:1 返回【弹框的父视图】 */
-(UIView  *)tf_popupManager_popForView:(TFPopupManager *)manager{
    return self.inView;
}

/* 执行顺序:4 返回【弹出框view】 */
-(UIView  *)tf_popupManager_popBoardView:(TFPopupManager *)manager{
    return self;
}



@end
