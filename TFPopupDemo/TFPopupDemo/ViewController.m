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
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //[self toast];
    
    [self show];
    
}
-(void)show{
    TFPopupParam *param = [TFPopupParam new];
    param.duration = 3;
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
    
    AlertNormal *alert = [[NSBundle mainBundle]loadNibNamed:@"AlertNormal"
                                                      owner:nil options:nil].firstObject;
    
    //[alert tf_show:self.view animated:YES];
    //[alert tf_show:self.view offset:CGPointMake(0, -100) animated:YES];
    //[alert tf_show:self.view offset:CGPointZero popupParam:param animated:YES];

    //[alert tf_showScale:self.view];
    //[alert tf_showScale:self.view offset:CGPointMake(100, -100)];
    
    alert.layer.anchorPoint = CGPointMake(0.5, 0);
    [alert tf_showScale:self.view offset:CGPointZero popupParam:param];
    
    //[alert tf_showSlide:self.view direction:PopupDirectionFromRight];

    //[alert tf_showFrame:self.view popupParam:param];
    
    //[alert tf_showCustemPart:self.view popupParam:param delegate:self];
 
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
