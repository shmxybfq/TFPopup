//
//  UIScrollView+TFPopup.m
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/8/15.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "UIScrollView+TFPopup.h"

@implementation UIScrollView (TFPopup)
@dynamic faterPopupView;

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [self popExchangeShouldReceiveTouch];
//        [self popExchangeGestureRecognizerShouldBegin];
//        [self popExchangeShouldRecognizeSimultaneouslyWithGestureRecognizer];
    });
}


+(void)popExchangeShouldReceiveTouch{
    //scrollview默认实现此代理的此函数
    SEL selOrigin = @selector(gestureRecognizer:shouldReceiveTouch:);
    SEL selTarget = @selector(popup_gestureRecognizer:shouldReceiveTouch:);
    [[self class] popup_instanceMethodExchange:selOrigin
                                       toClass:[self class] toSel:selTarget];
    
}
//执行顺序10-次数多次但有限
-(BOOL)popup_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([self isKindOfClass:[UITableView class]]) {
        NSLog(@"==============ppp0");
     
    }
    
    NSLog(@"=====1:%@:%@",self.scrollEnabled?@"是":@"否",[self class]);
    if (self.faterPopupView && [self.faterPopupView isKindOfClass:[UIView class]]) {
        return YES;
    }else{
        
    }
    return YES;
   
}



+(void)popExchangeGestureRecognizerShouldBegin{
    //scrollview默认实现此代理的此函数
    SEL selOrigin = @selector(gestureRecognizerShouldBegin:);
    SEL selTarget = @selector(popup_gestureRecognizerShouldBegin:);
    [[self class] popup_instanceMethodExchange:selOrigin
                                       toClass:[self class] toSel:selTarget];
    
}
//执行顺序20-次数1,当scrollview的scrollenable为no时,此函数不被调用
- (BOOL)popup_gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([self isKindOfClass:[UITableView class]]) {
        NSLog(@"==============ppp1");
        
    }
    
    
    NSLog(@"=====2:%@:%@",self.scrollEnabled?@"是":@"否",[self class]);
    if (self.faterPopupView && [self.faterPopupView isKindOfClass:[UIView class]]) {
        return YES;
    }else{
        
    }
    return YES;
}



+(void)popExchangeShouldRecognizeSimultaneouslyWithGestureRecognizer{
    //scrollview默认没有实现此代理的此函数
    SEL selOrigin = @selector(gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
    SEL selTarget = @selector(popup_gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:);
    [[self class] popup_instanceMethodExchange:selOrigin
                                       toClass:[self class] toSel:selTarget];
    
}
//执行顺序30-次数多次但有限
- (BOOL)popup_gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    if ([self isKindOfClass:[UITableView class]]) {
        NSLog(@"==============ppp2");
        
    }
    
    
    NSLog(@"=====3:%@:%@",self.scrollEnabled?@"是":@"否",[self class]);
    if (self.faterPopupView && [self.faterPopupView isKindOfClass:[UIView class]]) {
        return YES;
    }
    return NO;
}


tf_synthesize_category_property_assign(faterPopupView, setFaterPopupView);


@end
