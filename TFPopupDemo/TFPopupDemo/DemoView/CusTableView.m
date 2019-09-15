//
//  CusTableView.m
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/8/15.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "CusTableView.h"

@implementation CusTableView
////1次
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//    NSLog(@"=====1:%d",[super gestureRecognizerShouldBegin:gestureRecognizer]);
////    NSLog(@"=====1:%@",gestureRecognizer.view);
//
//    SEL sel = NSSelectorFromString(@"tf_popupView:enableScrollViewGestureRecognizerWhenDrag:");
//
//    UIView *superView = gestureRecognizer.view;
//    while (superView) {
//        if ([superView respondsToSelector:sel] && superView) {
////            NSLog(@"：：：：命中:%@",superView);
//        }
//        superView = superView.superview;
//    }
//    return YES;
//}
//
////多次但有限
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    NSLog(@"=====2:");
////    NSLog(@"=====2:%@",gestureRecognizer.view);
//    return NO;
//}
//
////2次
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
//    NSLog(@"=====5:");
////    NSLog(@"=====5:%@",gestureRecognizer.view);
//    return YES;
//}

@end
