//
//  UIScrollView+TFPopup.m
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/8/15.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "UIScrollView+TFPopup.h"

@implementation UIScrollView (TFPopup)

+(void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[self class] popup_instanceMethodExchange:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)
//                                           toClass:[self class]
//                                             toSel:@selector(popup_gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)];
//    });
}

- (BOOL)popup_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if (self.belongToPopupView && [self.belongToPopupView isKindOfClass:[UIView class]]) {
        return YES;
    }else if([self respondsToSelector:@selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:)]){
        return [self popup_gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    }else{
        return NO;
    }
}

#pragma mark -- 属性绑定
-(UIView *)belongToPopupView{
    id value = objc_getAssociatedObject(self, @selector(belongToPopupView));
    if (value && [value isKindOfClass:[UIView class]]) {
        return value;
    }
    return nil;
}
-(void)setBelongToPopupView:(UIView *)belongToPopupView{
    objc_setAssociatedObject(self, @selector(belongToPopupView), belongToPopupView, OBJC_ASSOCIATION_ASSIGN);
}



@end
