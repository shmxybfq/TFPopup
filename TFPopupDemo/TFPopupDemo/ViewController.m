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

@interface ViewController ()

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
    param.duration = 0.3;
    //param.noCoverView = YES;
    //param.noCoverAlphaAnimation = YES;
    param.noPopupAlphaAnimation = YES;
    param.popupSize = CGSizeMake(314, 170);
    param.foldOriginFrame = CGRectMake(0, 100, kSize.width, 1);
    param.foldTargetFrame = CGRectMake(0, 100, kSize.width, 300);
    AlertNormal *alert = [[NSBundle mainBundle]loadNibNamed:@"AlertNormal"
                                                      owner:nil options:nil].firstObject;
    [alert tf_show:self.view
        popupParam:param
             style:PopupStyleScale
          position:PopupPositionCenter
     popupAreaRect:self.view.bounds
          willShow:^(id inView) {
        
    }];

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
