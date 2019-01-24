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

@property (weak, nonatomic) IBOutlet UIButton *topButton0;
@property (weak, nonatomic) IBOutlet UIButton *topButton1;
@property (weak, nonatomic) IBOutlet UIButton *topButton2;
@property (weak, nonatomic) IBOutlet UIButton *topButton3;
@property (weak, nonatomic) IBOutlet UIButton *topButton4;
@property (weak, nonatomic) IBOutlet UIButton *topButton5;

@property (weak, nonatomic) IBOutlet UIButton *midButton0;
@property (weak, nonatomic) IBOutlet UIButton *midButton1;
@property (weak, nonatomic) IBOutlet UIButton *midButton2;
@property (weak, nonatomic) IBOutlet UIButton *midButton3;
@property (weak, nonatomic) IBOutlet UIButton *midButton4;
@property (weak, nonatomic) IBOutlet UIButton *midButton5;
@property (weak, nonatomic) IBOutlet UIButton *midButton6;
@property (weak, nonatomic) IBOutlet UIButton *midButton7;
@property (weak, nonatomic) IBOutlet UIButton *midButton8;

@property(nonatomic,strong)NSArray *topButtons;
@property(nonatomic,strong)NSArray *midButtons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
}

-(void)config{
    
    for (UIButton *bt in self.topButtons) {
        bt.backgroundColor = [UIColor clearColor];
        bt.layer.cornerRadius = 17;
        bt.layer.masksToBounds = YES;
        [bt setBackgroundImage:colorToImage(color(240, 240, 240)) forState:UIControlStateNormal];
        [bt setBackgroundImage:colorToImage(color(255, 142, 2)) forState:UIControlStateSelected];
        [bt setTitleColor:color(45, 45, 45) forState:UIControlStateNormal];
        [bt setTitleColor:color(255, 255, 255) forState:UIControlStateSelected];
        [bt addTarget:self action:@selector(topClick:)
     forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    for (UIButton *bt in self.midButtons) {
        bt.backgroundColor = [UIColor clearColor];
        bt.layer.cornerRadius = 17;
        bt.layer.masksToBounds = YES;
        [bt setBackgroundImage:colorToImage(color(240, 240, 240)) forState:UIControlStateNormal];
        [bt setBackgroundImage:colorToImage(color(255, 142, 2)) forState:UIControlStateSelected];
        [bt setTitleColor:color(45, 45, 45) forState:UIControlStateNormal];
        [bt setTitleColor:color(255, 255, 255) forState:UIControlStateSelected];
        [bt addTarget:self action:@selector(midClick:)
     forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)topClick:(UIButton *)ins{
    NSArray *tp = @[self.topButton0,self.topButton1,self.topButton2,
                    self.topButton3,self.topButton4,self.topButton5];
    for (UIButton *bt in tp) {
        bt.selected = bt == ins;
    }
}
-(void)midClick:(UIButton *)ins{
    ins.selected = !ins.selected;
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
    //param.disuseBackground = YES;
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
//            p.disuseBackground = YES;
//            [view tf_showScale:popup offset:CGPointZero popupParam:p];

            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
            [animation setFromValue:@(view.frame.origin.y)];//设置起始值
            [animation setToValue:@(view.frame.origin.y - 300)];//设置目标值
            [animation setDuration:0.25];//设置动画时间，单次动画时间
            [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [animation setAutoreverses:NO];
            [animation setFillMode:kCAFillModeBoth];
            [view.layer addAnimation:animation forKey:NSStringFromClass([self class])];
        });

    }
    return NO;
}


-(BOOL)tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup{
  
    
    NSArray *bts = [((BlankView *)popup) buttons];
    for (NSInteger i = bts.count - 1; i >=0 ; i--) {

        UIView *view = [bts objectAtIndex:i];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(((7-i) * 0.05) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
            [animation setFromValue:@(view.frame.origin.y)];//设置起始值
            [animation setToValue:@(view.frame.origin.y + 300)];//设置目标值
            [animation setDuration:3];//设置动画时间，单次动画时间
            [animation setRemovedOnCompletion:NO];//默认为YES,设置为NO时setFillMode有效
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [animation setAutoreverses:NO];
            [animation setFillMode:kCAFillModeBoth];
            [view.layer addAnimation:animation forKey:NSStringFromClass([self class])];
        });
        if (i == 7 ) {
            break;
        }

    }
    return YES;
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



static inline UIImage *colorToImage(UIColor *color){
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

static inline UIColor *color(float r,float g,float b){
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}


-(NSArray *)topButtons{
    NSArray *tp = @[self.topButton0,self.topButton1,self.topButton2,
                    self.topButton3,self.topButton4,self.topButton5];
    return tp;
}
-(NSArray *)midButtons{
    NSArray *mp = @[self.midButton0,self.midButton1,self.midButton2,self.midButton3,self.midButton4,
                    self.midButton5,self.midButton6,self.midButton7,self.midButton8];
    return mp;
}

@end
