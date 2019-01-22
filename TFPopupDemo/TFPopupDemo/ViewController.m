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


#define kSize [UIScreen mainScreen].bounds.size

@interface ViewController ()<TFPopupDelegate>

@property(nonatomic,strong)UIView *subview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0, 100, self.view.bounds.size.width, 500);
    //frame = self.view.bounds;
    self.subview = [[UIView alloc]initWithFrame:frame];
    self.subview.backgroundColor = [UIColor brownColor];
    self.subview.clipsToBounds = YES;
    [self.view addSubview:self.subview];
    
    
    if (@available(iOS 9.0, *)) {
        CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
        //阻尼系数,阻止弹簧伸缩的系数,阻尼系数越大,停止越快,可以认为它是阻力系数
        spring.damping = 30;
        //刚度系数(劲度系数/弹性系数),刚度系数越大,形变产生的力就越大,运动越快
        spring.stiffness = 50;
        //质量,振幅和质量成反比
        spring.mass = 10;
        //初始速率,动画视图的初始速度大小速率为正数时,速度方向与运动方向一致,速率为负数时,速度方向与运动方向相反.
        spring.initialVelocity = 0;
        //结算时间,只读.返回弹簧动画到停止时的估算时间，根据当前的动画参数估算通常弹簧动画的时间使用结算时间比较准确
        //spring.duration = spring.settlingDuration;
        spring.duration = 0.5;
        spring.fromValue = @(self.subview.center.y);
        spring.toValue = @(self.subview.center.y + 100);
        spring.fillMode = kCAFillModeBoth;
        spring.removedOnCompletion = NO;
        [self.subview.layer addAnimation:spring forKey:nil];
    } else {
        // Fallback on earlier versions
    }
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //[self toast];
    
    [self show];
    
}
-(void)show{
    TFPopupParam *param = [TFPopupParam new];
    param.duration = 0.5;
    //param.noPopupAlphaAnimation = YES;
    //param.autoDissmissDuration = 1;
    //param.noCoverView = YES;
    //param.noCoverTouchHide = YES;
    //param.coverBackgroundColorClear = YES;
    //param.noCoverAlphaAnimation = YES;
    //param.noPopupAlphaAnimation = YES;
    //param.popupAreaRect = CGRectZero;
    
    //展开
    //param.popOriginFrame = CGRectMake(0, 100, kSize.width, 1);
    //param.popTargetFrame = CGRectMake(0, 100, kSize.width, 300);
    
    //气泡 左上->右下
    //param.popOriginFrame = CGRectMake(30, 100, 0, 0);
    //param.popTargetFrame = CGRectMake(30, 100, 314, 170);
    
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
    
//    param.maskShowFromPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(314 * 0.5,
//                                                                               170 * 0.5,
//                                                                               2, 2)];
//    param.maskShowToPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-314 * 0.5,
//                                                                             -170 * 0.5,
//                                                                             314 * 2,
//                                                                             170 * 2)];
    
    UIBezierPath *p0 = [UIBezierPath bezierPath];
    [p0 moveToPoint:CGPointMake(-200, 0)];
    [p0 addLineToPoint:CGPointMake(-100, 0)];
    [p0 addLineToPoint:CGPointMake(0, 170 * 0.5)];
    [p0 addLineToPoint:CGPointMake(-100, 170)];
    [p0 addLineToPoint:CGPointMake(-200, 170)];
    [p0 closePath];
    
    
    UIBezierPath *p1 = [UIBezierPath bezierPath];
    [p1 moveToPoint:CGPointMake(-200, 0)];
    [p1 addLineToPoint:CGPointMake(314, 0)];
    [p1 addLineToPoint:CGPointMake(314 + 100, 170 * 0.5)];
    [p1 addLineToPoint:CGPointMake(314, 170)];
    [p1 addLineToPoint:CGPointMake(-200, 170)];
    [p1 closePath];
    
    param.maskShowFromPath = p0;
    param.maskShowToPath = p1;
    
    AlertNormal *alert = [[NSBundle mainBundle]loadNibNamed:@"AlertNormal"
                                                      owner:nil options:nil].firstObject;
    //alert.popupDelegate = self;
    
    //[alert tf_show:self.view animated:YES];
    //[alert tf_show:self.view offset:CGPointMake(0, -100) animated:YES];
    //[alert tf_show:self.view offset:CGPointZero popupParam:param animated:YES];

    //[alert tf_showScale:self.view];
    //[alert tf_showScale:self.view offset:CGPointMake(100, -100)];
    
    //alert.layer.anchorPoint = CGPointMake(0.5, 0);
    //[alert tf_showScale:self.view offset:CGPointZero popupParam:param];
    
    //[alert tf_showSlide:self.view direction:PopupDirectionFromRight];

    //[alert tf_showFrame:self.view popupParam:param];
    
    //[alert tf_showCustemPart:self.view popupParam:param delegate:self];

    [alert tf_showMask:self.view popupParam:param];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"anchorPoint:%@",NSStringFromCGPoint(alert.layer.anchorPoint));
    });
}

-(BOOL)tf_popupWillShow:(TFPopupManager *)manager popup:(UIView *)popup{
    

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    [animation setFromValue:@(M_PI)];//设置起始值
    [animation setToValue:@(M_PI * 2)];//设置目标值
    [animation setDuration:popup.popupParam.duration];//设置动画时间，单次动画时间
    [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setAutoreverses:NO];
    [animation setFillMode:kCAFillModeBoth];
    //[popup.layer addAnimation:animation forKey:NSStringFromClass([self class])];
    
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation1 setFromValue:@0.0];//设置起始值
    [animation1 setToValue:@(1)];//设置目标值
    [animation1 setDuration:popup.popupParam.duration];//设置动画时间，单次动画时间
    [animation1 setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
    [animation1 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation1 setAutoreverses:NO];
    [animation1 setFillMode:kCAFillModeBoth];
    //[popup.layer addAnimation:animation1 forKey:NSStringFromClass([self class])];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:popup.popupParam.duration];
    [group setAnimations:@[animation,animation1]];
    [popup.layer addAnimation:group forKey:NSStringFromClass([self class])];
    
    
    return NO;
}

-(BOOL)tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
    [animation setFromValue:@1.0];//设置起始值
    [animation setToValue:@0.0];//设置目标值
    [animation setDuration:popup.popupParam.duration];//设置动画时间，单次动画时间
    [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [animation setAutoreverses:NO];
    [animation setFillMode:kCAFillModeBoth];
    [popup.layer addAnimation:animation forKey:NSStringFromClass([self class])];
    return NO;
}

-(void)toast{
    NSMutableString *ss = [[NSMutableString alloc]init];
    NSInteger count = arc4random_uniform(200);
    for (NSInteger i = 0; i < count; i++) {
        [ss appendFormat:@"好"];
    }
    
    [TFPopupToast showToast:self.view msg:ss custemShow:^(TFPopupToast *toast) {
        //缩放
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:@0.1];//设置起始值
        [animation setToValue:@1.0];//设置目标值
        [animation setDuration:0.3];//设置动画时间，单次动画时间
        [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setAutoreverses:NO];
        [animation setFillMode:kCAFillModeBoth];
        [toast.layer addAnimation:animation forKey:NSStringFromClass([self class])];
        
    } custemHide:^(TFPopupToast *toast) {
        //缩放
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        [animation setFromValue:@1.0];//设置起始值
        [animation setToValue:@0.1];//设置目标值
        [animation setDuration:0.3];//设置动画时间，单次动画时间
        [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setAutoreverses:NO];
        [animation setFillMode:kCAFillModeBoth];
        [toast.layer addAnimation:animation forKey:NSStringFromClass([self class])];
        
    } animationFinish:^(TFPopupToast *toast) {
        
    }];
}


@end
