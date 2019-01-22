//
//  ViewController.m
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "ViewController.h"
#import "TFPopup.h"
#import "AlertNormal.h"
#import "BlankView.h"

#define kSize [UIScreen mainScreen].bounds.size

@interface ViewController ()<TFPopupDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //[self toast];
    
//    [self showAlert];
    
    [self showAction];
}

-(void)showAction{
    TFPopupParam *param = [TFPopupParam new];
    param.duration = 0.5;
    BlankView *alert = [[NSBundle mainBundle]loadNibNamed:@"BlankView"
                                                      owner:nil options:nil].firstObject;
    alert.popupDelegate = self;
    [alert tf_showSlide:self.view direction:PopupDirectionFromBottom];
}


-(void)showAlert{
    TFPopupParam *param = [TFPopupParam new];
    param.duration = 0.3;
    //param.noPopupAlphaAnimation = YES;
    //param.autoDissmissDuration = 1;
    //param.noCoverView = YES;
    //param.noCoverTouchHide = YES;
    //param.coverBackgroundColorClear = YES;
    //param.noCoverAlphaAnimation = YES;
    //param.noPopupAlphaAnimation = YES;
    //param.popupAreaRect = CGRectZero;
    
    //展开
//    param.popOriginFrame = CGRectMake(0, 100, kSize.width, 1);
//    param.popTargetFrame = CGRectMake(0, 100, kSize.width, 300);
    
    //气泡 左上->右下
//    param.popOriginFrame = CGRectMake(30, 100, 0, 0);
//    param.popTargetFrame = CGRectMake(30, 100, 314, 170);
    
    //气泡 右上->左下
    //param.popOriginFrame = CGRectMake(30 + 314, 100, 0, 0);
    //param.popTargetFrame = CGRectMake(30 , 100, 314, 170);
    
    //气泡 左下->右上
    //param.popOriginFrame = CGRectMake(30, 100 + 170, 0, 0);
    //param.popTargetFrame = CGRectMake(30 , 100, 314, 170);
    
    //气泡 右下->左上
    //param.popOriginFrame = CGRectMake(30 + 314, 100 + 170, 0, 0);
    //param.popTargetFrame = CGRectMake(30 , 100, 314, 170);
    
    //气泡 左梯形
    //param.popOriginFrame = CGRectMake(30 + 314, 100 + 170, 0, 0);
    //param.popTargetFrame = CGRectMake(30 , 100, 314, 170);
    
    //param.maskShowFromPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 340, 0)];
    //param.maskShowToPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 340, 170)];
    
    //mask 展开
//    param.maskShowFromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(314 * 0.5,
//                                                                               170 * 0.5,
//                                                                               2, 2)];
//    param.maskShowToPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-314 * 0.5,
//                                                                             -170 * 0.5,
//                                                                             314 * 2,
//                                                                             170 * 2)];
    
//    三角出来
//    UIBezierPath *p0 = [UIBezierPath bezierPath];
//    [p0 moveToPoint:CGPointMake(-200, 0)];
//    [p0 addLineToPoint:CGPointMake(-100, 0)];
//    [p0 addLineToPoint:CGPointMake(0, 170 * 0.5)];
//    [p0 addLineToPoint:CGPointMake(-100, 170)];
//    [p0 addLineToPoint:CGPointMake(-200, 170)];
//    [p0 closePath];
//    UIBezierPath *p1 = [UIBezierPath bezierPath];
//    [p1 moveToPoint:CGPointMake(-200, 0)];
//    [p1 addLineToPoint:CGPointMake(314, 0)];
//    [p1 addLineToPoint:CGPointMake(314 + 100, 170 * 0.5)];
//    [p1 addLineToPoint:CGPointMake(314, 170)];
//    [p1 addLineToPoint:CGPointMake(-200, 170)];
//    [p1 closePath];
//    param.maskShowFromPath = p0;
//    param.maskShowToPath = p1;
    
//    AlertNormal *alert = [[NSBundle mainBundle]loadNibNamed:@"AlertNormal"
//                                                      owner:nil options:nil].firstObject;
    //alert.backgroundColor = [UIColor clearColor];
    //alert.popupDelegate = self;
    
    //[alert tf_show:self.view animated:NO];
    //[alert tf_show:self.view offset:CGPointMake(0, -100) animated:YES];
    //[alert tf_show:self.view offset:CGPointZero popupParam:param animated:YES];

    //[alert tf_showScale:self.view];
    //[alert tf_showScale:self.view offset:CGPointMake(0, -100)];
    
    //alert.layer.anchorPoint = CGPointMake(0.5, 0);
    //[alert tf_showScale:self.view offset:CGPointZero popupParam:param];
    
    //[alert tf_showSlide:self.view direction:PopupDirectionFromRight];

    //[alert tf_showFrame:self.view popupParam:param];
    
//    [alert tf_showCustemPart:self.view popupParam:param delegate:self];

    //[alert tf_showMask:self.view popupParam:param];

}


////挨个弹出动画
-(BOOL)tf_popupWillShow:(TFPopupManager *)manager popup:(UIView *)popup{

    NSArray *bts = [((BlankView *)popup) buttons];
    for (NSInteger i = 0; i < bts.count; i++) {

        UIView *view = [bts objectAtIndex:i];
//        [view removeFromSuperview];
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + 300, 40, 40);


        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((0.25 + i * 0.05) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

//            TFPopupParam *p = [TFPopupParam new];
//            p.keepPopupOriginFrame = YES;
//            p.noCoverView = YES;
//            [view tf_showScale:popup offset:CGPointZero popupParam:p];

            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
            [animation setFromValue:@(view.frame.origin.y)];//设置起始值
            [animation setToValue:@(view.frame.origin.y - 300)];//设置目标值
            [animation setDuration:0.6];//设置动画时间，单次动画时间
            [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [animation setAutoreverses:NO];
            [animation setFillMode:kCAFillModeBoth];
            [view.layer addAnimation:animation forKey:NSStringFromClass([self class])];
        });

    }
    return NO;
}

//缩放动画
-(BOOL)tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup{

    return NO;
}


////旋转加缩放动画
//-(BOOL)tf_popupWillShow:(TFPopupManager *)manager popup:(UIView *)popup{
//
//    //旋转加缩放动画
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    [animation setFromValue:@(M_PI)];//设置起始值
//    [animation setToValue:@(M_PI * 2)];//设置目标值
//    [animation setDuration:popup.popupParam.duration];//设置动画时间，单次动画时间
//    [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [animation setAutoreverses:NO];
//    [animation setFillMode:kCAFillModeBoth];
//
//    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    [animation1 setFromValue:@0.0];//设置起始值
//    [animation1 setToValue:@(1)];//设置目标值
//    [animation1 setDuration:popup.popupParam.duration];//设置动画时间，单次动画时间
//    [animation1 setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
//    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [animation1 setAutoreverses:NO];
//    [animation1 setFillMode:kCAFillModeBoth];
//
//    CAAnimationGroup *group = [CAAnimationGroup animation];
//    [group setDuration:popup.popupParam.duration];
//    [group setAnimations:@[animation,animation1]];
//    [popup.layer addAnimation:group forKey:NSStringFromClass([self class])];
//
//    return NO;
//}
//
////缩放动画
//-(BOOL)tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup{
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
//    [animation setFromValue:@1.0];//设置起始值
//    [animation setToValue:@0.0];//设置目标值
//    [animation setDuration:popup.popupParam.duration];//设置动画时间，单次动画时间
//    [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    [animation setAutoreverses:NO];
//    [animation setFillMode:kCAFillModeBoth];
//    [popup.layer addAnimation:animation forKey:NSStringFromClass([self class])];
//    return NO;
//}

//-(void)toast{
//    NSMutableString *ss = [[NSMutableString alloc]init];
//    NSInteger count = arc4random_uniform(200);
//    for (NSInteger i = 0; i < count; i++) {
//        [ss appendFormat:@"好"];
//    }
//
//    [TFPopupToast showToast:self.view msg:ss custemShow:^(TFPopupToast *toast) {
//        //缩放
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        [animation setFromValue:@0.1];//设置起始值
//        [animation setToValue:@1.0];//设置目标值
//        [animation setDuration:0.3];//设置动画时间，单次动画时间
//        [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [animation setAutoreverses:NO];
//        [animation setFillMode:kCAFillModeBoth];
//        [toast.layer addAnimation:animation forKey:NSStringFromClass([self class])];
//
//    } custemHide:^(TFPopupToast *toast) {
//        //缩放
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        [animation setFromValue:@1.0];//设置起始值
//        [animation setToValue:@0.1];//设置目标值
//        [animation setDuration:0.3];//设置动画时间，单次动画时间
//        [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [animation setAutoreverses:NO];
//        [animation setFillMode:kCAFillModeBoth];
//        [toast.layer addAnimation:animation forKey:NSStringFromClass([self class])];
//
//    } animationFinish:^(TFPopupToast *toast) {
//
//    }];
//}


@end
