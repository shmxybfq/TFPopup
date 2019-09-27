//
//  UIScrollView+TFPopup.m
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/8/15.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "UIScrollView+TFPopup.h"
#import "UIView+TFPopup.h"
@implementation UIScrollView (TFPopup)
@dynamic faterPopupView;

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self popExchangeShouldReceiveTouch];
        [self popExchangeGestureRecognizerShouldBegin];
        [self popExchangeShouldRecognizeSimultaneouslyWithGestureRecognizer];
    });
}


//+(void)popExchangeShouldReceiveTouch{
//    //scrollview默认实现此代理的此函数
//    SEL selOrigin = @selector(gestureRecognizer:shouldReceiveTouch:);
//    SEL selTarget = @selector(popup_gestureRecognizer:shouldReceiveTouch:);
//    [[self class] popup_instanceMethodExchange:selOrigin
//                                       toClass:[self class] toSel:selTarget];
//
//}
////执行顺序10,次数多次但有限,如返回NO则下面两个方法不执行
//-(BOOL)popup_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    NSLog(@"=====1:%@:%@",self.scrollEnabled?@"是":@"否",[self class]);
//    BOOL should = [self popup_gestureRecognizer:gestureRecognizer shouldReceiveTouch:touch];
//    if (should) {
//        self.executeShouldReceiveTouch = @(YES);
//    }
//    return should;
//}

+(void)popExchangeGestureRecognizerShouldBegin{
    //scrollview默认实现此代理的此函数
    SEL selOrigin = @selector(gestureRecognizerShouldBegin:);
    SEL selTarget = @selector(popup_gestureRecognizerShouldBegin:);
    [[self class] popup_instanceMethodExchange:selOrigin
                                       toClass:[self class] toSel:selTarget];
    
}
//执行顺序20,次数1,,如返回NO不影响上面和下面两个方法执行,但是将不能滚动
- (BOOL)popup_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    NSLog(@"=====2:%@:%@",self.scrollEnabled?@"是":@"否",[self class]);
    BOOL should = [self popup_gestureRecognizerShouldBegin:gestureRecognizer];
    if (self.faterPopupView) {
        self.faterPopupView.extension.currentDragScrollViewAllowScroll = should;
    }
    return should;
}

+(void)popExchangeShouldRecognizeSimultaneouslyWithGestureRecognizer{
    //scrollview默认没有实现此代理的此函数
    SEL selOrigin = @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
    SEL selTarget = @selector(popup_gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
    [[self class] popup_instanceMethodExchange:selOrigin
                                       toClass:[self class] toSel:selTarget];
    
}
//执行顺序30,次数多次但有限,如返回NO事件将不能透传
- (BOOL)popup_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    NSLog(@"=====3:%@:%@",self.scrollEnabled?@"是":@"否",[self class]);
    if (self.faterPopupView && [self.faterPopupView isKindOfClass:[UIView class]]) {
        if (self.faterPopupView.extension.currentDragScrollViewAllowScroll) {
            self.faterPopupView.extension.currentDragScrollView = self;
        }else{
            self.faterPopupView.extension.currentDragScrollView = nil;
        }
        return YES;
    }
    return NO;
    
}


tf_synthesize_category_property_assign(faterPopupView, setFaterPopupView);


@end
