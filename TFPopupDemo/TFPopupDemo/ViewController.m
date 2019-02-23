//
//  ViewController.m
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "ViewController.h"

#import "TFPopup.h"
#import "ListView.h"
#import "BlankView.h"
#import "AlertNormal.h"

#import "ExcempleAlert.h"
#import "ExcempleAction.h"
#import "ExcempleNotification.h"
#import "ExcempleSign.h"
#import "ExcempleUnfold.h"
#import "ExcempleBubble.h"
#import "ExcempleSliderBig.h"
#import "ExcempleSliderSmall.h"

#define kSize [UIScreen mainScreen].bounds.size
#define kAlertSize CGSizeMake(314, 170)

@interface ViewController ()<TFPopupDelegate>
    
@property (weak, nonatomic) IBOutlet UIButton *topButton0;
@property (weak, nonatomic) IBOutlet UIButton *topButton1;
@property (weak, nonatomic) IBOutlet UIButton *topButton2;
@property (weak, nonatomic) IBOutlet UIButton *topButton3;
@property (weak, nonatomic) IBOutlet UIButton *topButton4;
@property (weak, nonatomic) IBOutlet UIButton *topButton5;
@property (weak, nonatomic) IBOutlet UIButton *topButton6;

@property (weak, nonatomic) IBOutlet UIButton *midButton0;
@property (weak, nonatomic) IBOutlet UIButton *midButton1;
@property (weak, nonatomic) IBOutlet UIButton *midButton2;
@property (weak, nonatomic) IBOutlet UIButton *midButton3;
@property (weak, nonatomic) IBOutlet UIButton *midButton4;
@property (weak, nonatomic) IBOutlet UIButton *midButton5;

@property (weak, nonatomic) IBOutlet UIButton *botButton0;
@property (weak, nonatomic) IBOutlet UIButton *botButton1;
@property (weak, nonatomic) IBOutlet UIButton *botButton2;
@property (weak, nonatomic) IBOutlet UIButton *botButton3;
@property (weak, nonatomic) IBOutlet UIButton *botButton4;
@property (weak, nonatomic) IBOutlet UIButton *botButton5;
@property (weak, nonatomic) IBOutlet UIButton *botButton6;
@property (weak, nonatomic) IBOutlet UIButton *botButton7;
@property (weak, nonatomic) IBOutlet UIButton *botButton8;
@property (weak, nonatomic) IBOutlet UIButton *botButton9;

@property (weak, nonatomic) IBOutlet UIButton *cusButton0;
@property (weak, nonatomic) IBOutlet UIButton *cusButton1;
@property (weak, nonatomic) IBOutlet UIButton *cusButton2;
@property (weak, nonatomic) IBOutlet UIButton *cusButton3;
@property (weak, nonatomic) IBOutlet UIButton *cusButton4;
@property (weak, nonatomic) IBOutlet UIButton *cusButton5;

@property (weak, nonatomic) IBOutlet UIButton *excButton0;
@property (weak, nonatomic) IBOutlet UIButton *excButton1;
@property (weak, nonatomic) IBOutlet UIButton *excButton2;
@property (weak, nonatomic) IBOutlet UIButton *excButton3;
@property (weak, nonatomic) IBOutlet UIButton *excButton4;
@property (weak, nonatomic) IBOutlet UIButton *excButton5;
@property (weak, nonatomic) IBOutlet UIButton *excButton6;
@property (weak, nonatomic) IBOutlet UIButton *excButton7;

@property (weak, nonatomic) IBOutlet UITextField *textField0;
@property (weak, nonatomic) IBOutlet UITextField *textField1;

@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property(nonatomic,strong)NSArray *topButtons;
@property(nonatomic,strong)NSArray *midButtons;
@property(nonatomic,strong)NSArray *botButtons;
@property(nonatomic,strong)NSArray *cusButtons;
@property(nonatomic,strong)NSArray *excempleButtons;

@property(nonatomic,strong)TFPopupParam *param;
@property(nonatomic,  copy)NSString *animationType;
@property(nonatomic,assign)PopupDirection popupDirection;
@property(nonatomic,assign)NSInteger custemIndex;
@property (weak, nonatomic) IBOutlet UIView *redPoint;

//默认alpha = 0
@property (weak, nonatomic) IBOutlet UIButton *excempleCoverButton;

    @end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
    [self topClick:self.topButton5];
    [self botClick:self.botButton4];
    
}
    
    
    
-(void)showClick:(UIButton *)ins{
    
    self.param.duration = 0.3;
    
    if ([self.animationType isEqualToString:@"直接弹"]) {
        
        UIView *popup = [self getAlertView];
        
        [popup tf_showNormal:self.view animated:NO];
        //        [popup tf_showNormal:self.view
        //                      offset:CGPointMake(0, -100)
        //                    animated:NO];
        
    }if ([self.animationType isEqualToString:@"渐隐"]) {
        
        UIView *popup = [self getAlertView];
        
        //        [popup tf_showNormal:self.view animated:YES];
        //        [popup tf_showNormal:self.view
        //                      offset:CGPointMake(0, -100)
        //                    animated:YES];
        [popup tf_showNormal:self.view popupParam:self.param];
        
    }else if ([self.animationType isEqualToString:@"缩放"]) {
        
        UIView *popup = [self getAlertView];
        
        //[popup tf_showScale:self.view];
        //[popup tf_showScale:self.view offset:CGPointMake(0, -100)];
        [popup tf_showScale:self.view offset:CGPointZero popupParam:self.param];
        
    }else if ([self.animationType isEqualToString:@"滑动"]) {
        
        if (self.popupDirection == PopupDirectionLeft ||
            self.popupDirection == PopupDirectionRight) {
            self.param.popupSize = CGSizeMake(200, self.view.frame.size.height);
        }
        if (self.popupDirection == PopupDirectionBottom ||
            self.popupDirection == PopupDirectionTop) {
            self.param.popupSize = CGSizeMake(self.view.frame.size.width, 300);
        }
        UIView *popup = [self getListView];
        //self.param.offset = CGPointMake(-50, -100);
        //[popup tf_showSlide:self.view direction:self.popupDirection];
        [popup tf_showSlide:self.view direction:self.popupDirection popupParam:self.param];
        
    }else if ([self.animationType isEqualToString:@"泡泡"]) {
        
        self.param.popupSize = CGSizeMake(150, 250);
        
        UIView *popup = [self getListView];
        
        [popup tf_showBubble:self.view
                   basePoint:self.redPoint.center
             bubbleDirection:self.popupDirection
                  popupParam:self.param];
        
    }else if ([self.animationType isEqualToString:@"遮罩"]) {
        
        self.param.duration = 0.3;
        
        //三角出来
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
        
        
        self.param.maskShowFromPath = p0;
        self.param.maskShowToPath = p1;
        
        UIView *popup = [self getAlertView];
        [popup tf_showMask:self.view popupParam:self.param];
        
    }else if ([self.animationType isEqualToString:@"形变"]) {
        
        self.param.popOriginFrame = CGRectMake(0, 110, kSize.width, 0);
        self.param.popTargetFrame = CGRectMake(0, 110, kSize.width, 200);
        
        UIView *popup = [self getListView];
        
        [popup tf_showFrame:self.view
                       from:self.param.popOriginFrame
                         to:self.param.popTargetFrame
                 popupParam:self.param];
    }
}
    
    
    
-(void)topClick:(UIButton *)ins{
    
    [self config];
    [self botClick:self.botButton4];
    
    for (UIButton *bt in self.topButtons) {
        bt.selected = bt == ins;
    }
    self.animationType = title(ins);
}
    
    
    
-(void)midClick:(UIButton *)ins{
    
    ins.selected = !ins.selected;
    if ([title(ins) isEqualToString:@"不使用背景"]) {
        self.param.disuseBackground = ins.selected;
    }
    if ([title(ins) isEqualToString:@"点击背景不消失"]) {
        self.param.disuseBackgroundTouchHide = ins.selected;
    }
    if ([title(ins) isEqualToString:@"背景色透明"]) {
        self.param.backgroundColorClear = ins.selected;
    }
    if ([title(ins) isEqualToString:@"不使用背景渐隐动画"]) {
        self.param.disuseBackgroundAlphaAnimation = ins.selected;
    }
    if ([title(ins) isEqualToString:@"不使用弹出渐隐动画"]) {
        self.param.disusePopupAlphaAnimation = ins.selected;
    }
    if ([title(ins) isEqualToString:@"弹框偏移"]) {
        self.param.offset = ins.selected?CGPointMake(0, -150):CGPointZero;
    }
}
    
-(void)botClick:(UIButton *)ins{
    for (UIButton *bt in self.botButtons) {
        bt.selected = bt == ins;
    }
    
    self.param.popOriginFrame = CGRectZero;
    self.param.popTargetFrame = CGRectZero;
    if ([title(ins) isEqualToString:@"上"]) self.popupDirection = PopupDirectionTop;
    if ([title(ins) isEqualToString:@"上右"]) self.popupDirection = PopupDirectionTopRight;
    if ([title(ins) isEqualToString:@"右"]) self.popupDirection = PopupDirectionRight;
    if ([title(ins) isEqualToString:@"右下"]) self.popupDirection = PopupDirectionRightBottom;
    if ([title(ins) isEqualToString:@"下"]) self.popupDirection = PopupDirectionBottom;
    if ([title(ins) isEqualToString:@"下左"]) self.popupDirection = PopupDirectionBottomLeft;
    if ([title(ins) isEqualToString:@"左"]) self.popupDirection = PopupDirectionLeft;
    if ([title(ins) isEqualToString:@"左上"]) self.popupDirection = PopupDirectionLeftTop;
    if ([title(ins) isEqualToString:@"中"]) self.popupDirection = PopupDirectionContainerCenter;
    if ([title(ins) isEqualToString:@"随意"]) {
        self.popupDirection = PopupDirectionFrame;
        self.param.popOriginFrame = CGRectMake(-200, 32, 200, self.view.frame.size.height - 32);
        self.param.popTargetFrame = CGRectMake(0, 32, 200, self.view.frame.size.height - 32);
    }
}
    
-(void)cusClick:(UIButton *)ins{
    for (UIButton *bt in self.botButtons) {
        bt.selected = bt == ins;
    }
    if ([title(ins) isEqualToString:@"自定义1"]) self.custemIndex = 1;
    if ([title(ins) isEqualToString:@"自定义2"]) self.custemIndex = 2;
    if ([title(ins) isEqualToString:@"自定义3"]) self.custemIndex = 3;
    if ([title(ins) isEqualToString:@"自定义4"]) self.custemIndex = 4;
    if ([title(ins) isEqualToString:@"自定义5"]) self.custemIndex = 5;
    if ([title(ins) isEqualToString:@"自定义6"]) self.custemIndex = 6;
    
    
    if (self.custemIndex == 1) {
        
        UIView *blank = [self getAlertView];
        blank.popupDelegate = self;
        [blank tf_showScale:self.view offset:CGPointZero popupParam:self.param];
        
    }else if(self.custemIndex == 2){
        
        UIView *blank = [self getBlankView];
        blank.popupDelegate = self;
        self.param.popupSize = CGSizeMake(kSize.width, 300);
        [blank tf_showSlide:self.view direction:PopupDirectionBottom popupParam:self.param];
        
    }else if(self.custemIndex == 3){
        
        UIView *blank = [self getAlertView];
        blank.popupDelegate = self;
        [blank tf_showNormal:self.view popupParam:self.param];
        
    }else if(self.custemIndex == 4){
        
        self.param.duration = 1;
        self.param.disuseBackgroundAlphaAnimation = YES;
        self.param.disusePopupAlphaAnimation = YES;
        UIView *blank = [self getAlertView];
        blank.popupDelegate = self;
        [blank tf_showNormal:self.view popupParam:self.param];
        
    }else if(self.custemIndex == 5){
        
    }else if(self.custemIndex == 6){
        
    }
}


    
-(BOOL)tf_popupWillShow:(TFPopupManager *)manager popup:(UIView *)popup{
    
    if (self.custemIndex == 1) {
        [self topClick:self.topButton1];
        CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        [ani setFromValue:@(-M_PI)];
        [ani setToValue:@(0)];
        [ani setDuration:0.3];
        [ani setRemovedOnCompletion:NO];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.35 :0.15 :0.35 :0.15]];
        [ani setAutoreverses:NO];
        [ani setFillMode:kCAFillModeBoth];
        [popup.layer addAnimation:ani forKey:@"rotation"];
        return NO;
    }else if(self.custemIndex == 2){
        
        [self topClick:self.topButton2];
        NSArray *bts = [((BlankView *)popup) buttons];
        CGFloat x = 30;
        CGFloat y = 300;
        NSMutableArray *fs = [NSMutableArray array];
        for (int i = 0; i < bts.count; i++) {
            UIView *bt = [bts objectAtIndex:i];
            bt.frame = CGRectMake(x , y, 40, 40);
            [fs addObject:NSStringFromCGRect(CGRectMake(x, y - 300 + 40, 40, 40))];
            x = x + 40 + (kSize.width - 40 * 4 - 30 * 2) / 3.0;
            if (i == 3) {
                x = 30;
                y = y + 40 + 30;
            }
        }
        for (int i = 0; i < bts.count; i++) {
            UIView *bt = [bts objectAtIndex:i];
            CGRect frame = CGRectFromString([fs objectAtIndex:i]);
            [UIView animateWithDuration:0.25 delay:(0.1+i*0.05) options:UIViewAnimationOptionCurveEaseInOut animations:^{
                bt.frame = frame;
            } completion:^(BOOL finished) {}];
        }
        return NO;
        
    }else if(self.custemIndex == 3){
        
        if (@available(iOS 9.0, *)) {
            CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
            spring.damping = 15;
            spring.stiffness = 100;
            spring.mass = 1.5;
            spring.initialVelocity = 0;
            spring.duration = spring.settlingDuration;
            spring.fromValue = @(-200);
            spring.toValue = @(self.view.center.y);
            spring.fillMode = kCAFillModeForwards;
            [popup.layer addAnimation:spring forKey:nil];
            __weak typeof(popup) weakPopup = popup;
            [spring observerAnimationDidStop:^(CAAnimation *anima, BOOL finished) {
                if (finished) {
                    weakPopup.center = CGPointMake(kSize.width * 0.5, kSize.height * 0.5);
                }
            }];
        } else {
            
        }
        return NO;
        
    }else if(self.custemIndex == 4){
        
        popup.layer.masksToBounds = NO;
        popup.clipsToBounds = NO;
        
        CGFloat dur = self.param.duration;
        CAShapeLayer *layer = [CAShapeLayer layer];
        CGSize ss = kAlertSize;
        UIBezierPath *prepp = nil;
        UIBezierPath *sufpp = nil;
        CAAnimationGroup *group = [CAAnimationGroup animation];
        NSMutableArray *ans = [NSMutableArray array];
        for (NSInteger i = 1; i <= 7; i++) {
            UIBezierPath *pp = [UIBezierPath bezierPath];
            [pp moveToPoint:CGPointMake(0, ss.height)];
            [pp addLineToPoint:CGPointMake(0, ss.height - ss.height * 0.2 * i)];
            CGPoint p0 = CGPointMake(ss.width * 0.33, ss.height - ss.height * 0.2 * i - 34);
            CGPoint p1 = CGPointMake(ss.width * 0.66, ss.height - ss.height * 0.2 * i + 34);
            [pp addCurveToPoint:CGPointMake(ss.width, ss.height - ss.height * 0.2 * i)
                  controlPoint1:(i % 2 == 0)?p0:p1
                  controlPoint2:(i % 2 == 0)?p1:p0];
            [pp addLineToPoint:CGPointMake(ss.width, ss.height)];
            [pp addLineToPoint:CGPointMake(0, ss.height)];
            [pp closePath];
            
            if (i == 1) {
                layer.path = pp.CGPath;
                popup.layer.mask = layer;
            }else if(i == 7){
                sufpp = pp;
            }else{
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
                animation.duration = dur / 7.0;
                animation.beginTime = dur / 7.0 * (i - 2);
                animation.fromValue = (__bridge id)prepp.CGPath;
                animation.toValue = (__bridge id)pp.CGPath;
                [ans addObject:animation];
            }
            prepp = pp;
        }
        layer.path = sufpp.CGPath;

        group.animations = ans;
        group.removedOnCompletion = NO;
        group.duration = ans.count * dur / 7.0;
        group.fillMode = kCAFillModeBoth;
        [group observerAnimationDidStop:^(CAAnimation *anima, BOOL finished) {
            NSLog(@">>>>>>>:%@",sufpp);
            layer.path = sufpp.CGPath;
        }];
        [layer addAnimation:group forKey:nil];
        
    }else if(self.custemIndex == 5){
        
    }else if(self.custemIndex == 6){
        
    }
    return NO;
}
    
-(BOOL)tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup{
    if(self.custemIndex == 1){
        CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        [ani setFromValue:@(0)];
        [ani setToValue:@(-M_PI)];
        [ani setDuration:0.3];
        [ani setRemovedOnCompletion:NO];
        [ani setTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.35 :0.15 :0.35 :0.15]];
        [ani setAutoreverses:NO];
        [ani setFillMode:kCAFillModeBoth];
        [popup.layer addAnimation:ani forKey:@"rotation"];
        return NO;
    }else if(self.custemIndex == 2){
        NSArray *bts = [((BlankView *)popup) buttons];
        for (int i = 0; i < bts.count; i++) {
            UIView *bt = [bts objectAtIndex:i];
            CGRect f = bt.frame;
            [UIView animateWithDuration:0.25 delay:(0.1+i*0.05) options:UIViewAnimationOptionCurveEaseInOut animations:^{
                bt.frame = CGRectMake(f.origin.x, 300, 40, 40);
            } completion:^(BOOL finished) {}];
        }
        CGRect of = popup.frame;
        
        [UIView animateWithDuration:0.25
                              delay:(0.1+8*0.05)
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             popup.frame = CGRectMake(of.origin.x, kSize.height, of.size.width, of.size.height);
                         } completion:^(BOOL finished) {
                             
                         }];
        [UIView animateWithDuration:0.25
                              delay:(0.1+8*0.05)
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             popup.backgroundView.alpha = 0;
                         } completion:^(BOOL finished) {
                             [popup.backgroundView removeFromSuperview];
                         }];
        return YES;
    }else if(self.custemIndex == 3){
        if (@available(iOS 9.0, *)) {
            popup.center = CGPointMake(kSize.width * 0.5, -500);
            CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"position.y"];
            spring.damping = 15;
            spring.stiffness = 100;
            spring.mass = 1.5;
            spring.initialVelocity = 0;
            spring.duration = spring.settlingDuration;
            spring.fromValue = @(self.view.center.y);
            spring.toValue = @(-200);
            spring.fillMode = kCAFillModeForwards;
            [popup.layer addAnimation:spring forKey:nil];
            __weak typeof(popup) weakPopup = popup;
            [spring observerAnimationDidStop:^(CAAnimation *anima, BOOL finished) {
                if (finished) {
                    weakPopup.center = CGPointMake(kSize.width * 0.5, -200);
                }
            }];
        } else {
            
        }
        return NO;
    }else if(self.custemIndex == 4){
        
    }else if(self.custemIndex == 5){
        
    }else if(self.custemIndex == 6){
        
    }
    return NO;
}


-(void)excClick:(UIButton *)ins{
    if ([title(ins) isEqualToString:@"0"]) {
        UIView *view = [self getViewName:@"ExcempleAlert"];
        [view tf_showNormal:self.view animated:NO];
    }
    if ([title(ins) isEqualToString:@"1"]) {
        UIView *view = [self getViewName:@"ExcempleAction"];
        
        TFPopupParam *param = [TFPopupParam new];
        param.offset = CGPointMake(0, -60);
        param.popupSize = CGSizeMake(360, 226);
        [view tf_showSlide:self.view direction:PopupDirectionBottom popupParam:param];
    }
    
    if ([title(ins) isEqualToString:@"2"]) {
        UIView *view = [self getViewName:@"ExcempleNotification"];
        TFPopupParam *param = [TFPopupParam new];
        param.offset = CGPointMake(0, +30);
        param.popupSize = CGSizeMake(396, 78);
        param.autoDissmissDuration = 1;
        param.disusePopupAlphaAnimation = YES;
        [view tf_showSlide:self.view direction:PopupDirectionTop popupParam:param];
    }
    if ([title(ins) isEqualToString:@"3"]) {
        UIView *view = [self getViewName:@"ExcempleSign"];
        TFPopupParam *param = [TFPopupParam new];
        [view tf_showScale:self.view offset:CGPointMake(0, -100) popupParam:param];
    }
    
    if ([title(ins) isEqualToString:@"4"]) {
        UIView *view = [self getViewName:@"ExcempleUnfold"];
        //UIView *view = [self getViewName:@"ListView"];
        TFPopupParam *param = [TFPopupParam new];
        param.popOriginFrame = CGRectMake(0, 100, kSize.width, 1);
        param.popTargetFrame = CGRectMake(0, 100, kSize.width, 320);
        [view tf_showFrame:self.view
                      from:param.popOriginFrame
                        to:param.popTargetFrame
                popupParam:param];
    }
    
}
    
    
-(UIView *)getAlertView{
    AlertNormal *alert = (AlertNormal *)[self getViewName:@"AlertNormal"];
    [alert observerSure:^{
        [alert tf_hide];
    }];
    return alert;
}
    
    
-(UIView *)getListView{
    ListView *list = (ListView *)[self getViewName:@"ListView"];
    [list observerSelected:^(NSString *data) {
        [list tf_hide];
    }];
    return list;
}
    
-(UIView *)getBlankView{
    BlankView *blank = (BlankView *)[self getViewName:@"BlankView"];
    return blank;
}


-(UIView *)getViewName:(NSString *)name{
    UIView *view = [[NSBundle mainBundle]loadNibNamed:name
                                                    owner:nil
                                                  options:nil].firstObject;
    return view;
}
    
    
-(void)config{
    
    self.param = [TFPopupParam new];
    
    NSMutableArray *all = [[NSMutableArray alloc]init];
    [all addObjectsFromArray:self.topButtons];
    [all addObjectsFromArray:self.midButtons];
    [all addObjectsFromArray:self.botButtons];
    [all addObjectsFromArray:self.cusButtons];
    [all addObjectsFromArray:self.excempleButtons];
    for (UIButton *bt in all) {
        bt.backgroundColor = [UIColor clearColor];
        bt.layer.cornerRadius = 10;
        bt.layer.masksToBounds = YES;
        [bt setBackgroundImage:colorToImage(color(240, 240, 240)) forState:UIControlStateNormal];
        [bt setBackgroundImage:colorToImage(color(255, 142, 2)) forState:UIControlStateSelected];
        [bt setBackgroundImage:colorToImage(color(230, 230, 230)) forState:UIControlStateDisabled];
        [bt setTitleColor:color(45, 45, 45) forState:UIControlStateNormal];
        [bt setTitleColor:color(255, 255, 255) forState:UIControlStateSelected];
        [bt setTitleColor:color(60, 60, 60) forState:UIControlStateDisabled];
    }
    
    for (UIButton *bt in self.topButtons) {
        [bt addTarget:self action:@selector(topClick:)
     forControlEvents:UIControlEventTouchUpInside];
    }
    for (UIButton *bt in self.midButtons) {
        [bt addTarget:self action:@selector(midClick:)
     forControlEvents:UIControlEventTouchUpInside];
    }
    for (UIButton *bt in self.botButtons) {
        [bt addTarget:self action:@selector(botClick:)
     forControlEvents:UIControlEventTouchUpInside];
    }
    for (UIButton *bt in self.cusButtons) {
        [bt addTarget:self action:@selector(cusClick:)
     forControlEvents:UIControlEventTouchUpInside];
    }
    for (UIButton *bt in self.excempleButtons) {
        [bt addTarget:self action:@selector(excClick:)
     forControlEvents:UIControlEventTouchUpInside];
    }
    self.showButton.layer.cornerRadius = 20;
    [self.showButton addTarget:self
                        action:@selector(showClick:)
              forControlEvents:UIControlEventTouchUpInside];
    
    self.redPoint.layer.cornerRadius = 5;
    
}
    
-(NSArray *)topButtons{
    NSArray *tp = @[self.topButton0,self.topButton1,self.topButton2,
                        self.topButton3,self.topButton4,self.topButton5,
                        self.topButton6];
    return tp;
}
-(NSArray *)midButtons{
    NSArray *mp = @[self.midButton0,self.midButton1,self.midButton2,
                        self.midButton3,self.midButton4,self.midButton5];
    return mp;
}
    
-(NSArray *)botButtons{
    NSArray *bp = @[self.botButton0,self.botButton1,self.botButton2,
                        self.botButton3,self.botButton4,self.botButton5,
                        self.botButton6,self.botButton7,self.botButton8,self.botButton9];
    return bp;
}
    
-(NSArray *)cusButtons{
    NSArray *cp = @[self.cusButton0,self.cusButton1,self.cusButton2,
                        self.cusButton3,self.cusButton4,self.cusButton5];
    return cp;
}

-(NSArray *)excempleButtons{
    NSArray *cp = @[self.excButton0,self.excButton1,self.excButton2,
                    self.excButton3,self.excButton4,self.excButton5,
                    self.excButton6,self.excButton7];
    return cp;
}
    
-(TFPopupParam *)param{
    if (_param == nil) {
        _param = [TFPopupParam new];
    }
    return _param;
}
    
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

static inline NSString *title(UIButton *bt){
    return [bt titleForState:UIControlStateNormal];
}

@end
