//
//  ExcempleViewController.m
//  TFPopupDemo
//
//  Created by Time on 2019/2/25.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "ExcempleViewController.h"
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
#import "ExcempleSliderLogin.h"

#define kSize [UIScreen mainScreen].bounds.size
#define kAlertSize CGSizeMake(314, 170)

@interface ExcempleViewController ()<TFPopupDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cusButton0;
@property (weak, nonatomic) IBOutlet UIButton *cusButton1;
@property (weak, nonatomic) IBOutlet UIButton *cusButton2;
@property (weak, nonatomic) IBOutlet UIButton *cusButton3;

@property (weak, nonatomic) IBOutlet UIButton *excButton0;
@property (weak, nonatomic) IBOutlet UIButton *excButton1;
@property (weak, nonatomic) IBOutlet UIButton *excButton2;
@property (weak, nonatomic) IBOutlet UIButton *excButton3;
@property (weak, nonatomic) IBOutlet UIButton *excButton4;
@property (weak, nonatomic) IBOutlet UIButton *excButton5;
@property (weak, nonatomic) IBOutlet UIButton *excButton6;

@property(nonatomic,  copy)NSString *selectedTitle;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ExcempleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self config];
}



-(void)config{
    
    
    NSMutableArray *all = [[NSMutableArray alloc]init];
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
    
  
    for (UIButton *bt in self.cusButtons) {
        [bt addTarget:self action:@selector(cusClick:)
     forControlEvents:UIControlEventTouchUpInside];
    }
    for (UIButton *bt in self.excempleButtons) {
        [bt addTarget:self action:@selector(excClick:)
     forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.backButton addTarget:self
                        action:@selector(backButtonClick)
              forControlEvents:UIControlEventTouchUpInside];
}

-(void)backButtonClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cusClick:(UIButton *)ins{
   
    self.selectedTitle = title(ins);
    
    TFPopupParam *param = [TFPopupParam new];

    if ([title(ins) isEqualToString:@"自定义1"]) {
        
        
        UIView *blank = [self getAlertView];
        blank.popupDelegate = self;
        [blank tf_showScale:self.view offset:CGPointZero popupParam:param];
        
    }else if([title(ins) isEqualToString:@"自定义2"]){
        
        UIView *blank = [self getBlankView];
        blank.popupDelegate = self;
        param.popupSize = CGSizeMake(kSize.width, 300);
        [blank tf_showSlide:self.view direction:PopupDirectionBottom popupParam:param];
        
    }else if([title(ins) isEqualToString:@"自定义3"]){
        
        UIView *view = [self getViewName:@"ExcempleAlert"];
        view.popupDelegate = self;
        [view tf_showNormal:self.view popupParam:param];
        
    }else if([title(ins) isEqualToString:@"自定义4"]){
        
        param.duration = 1;
        param.disuseBackgroundAlphaAnimation = YES;
        param.disusePopupAlphaAnimation = YES;
        param.popupSize = kAlertSize;
        UIView *view = [self getViewName:@"ExcempleAction"];
        
        view.popupDelegate = self;
        [view tf_showNormal:self.view popupParam:param];
    }
}



-(BOOL)tf_popupWillShow:(TFPopupManager *)manager popup:(UIView *)popup{
    
    if ([self.selectedTitle isEqualToString:@"自定义1"]) {
        
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
    }else if([self.selectedTitle isEqualToString:@"自定义2"]){
        
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
        
    }else if([self.selectedTitle isEqualToString:@"自定义3"]){
        
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
        
    }else if([self.selectedTitle isEqualToString:@"自定义4"]){
        
        popup.layer.masksToBounds = NO;
        popup.clipsToBounds = NO;
        
        CGFloat dur = popup.popupParam.duration;
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
        
    }
    return NO;
}

-(BOOL)tf_popupWillHide:(TFPopupManager *)manager popup:(UIView *)popup{
    if([self.selectedTitle isEqualToString:@"自定义1"]){
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
    }else if([self.selectedTitle isEqualToString:@"自定义2"]){
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
    }else if([self.selectedTitle isEqualToString:@"自定义3"]){
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
    }
    return NO;
}

-(BOOL)tf_popupBackgroundTouch:(TFPopupManager *)manager popup:(UIView *)popup{
    [self.view endEditing:YES];
    return NO;
}


-(void)excClick:(UIButton *)ins{
    if ([title(ins) isEqualToString:@"exc0"]) {
        UIView *view = [self getViewName:@"ExcempleAlert"];
        [view tf_showNormal:self.view animated:NO];
        [((ExcempleAlert *)view) observerClick:^{
            [view tf_hide];
        }];
    }
    if ([title(ins) isEqualToString:@"exc1"]) {
        UIView *view = [self getViewName:@"ExcempleAction"];
        
        TFPopupParam *param = [TFPopupParam new];
        param.offset = CGPointMake(0, -200);
        param.disuseBackgroundTouchHide = YES;
        param.disusePopupAlphaAnimation = YES;
        param.popupSize = CGSizeMake(360, 226);
        view.popupDelegate = self;
        [view tf_showSlide:self.view direction:PopupDirectionBottom popupParam:param];
        [((ExcempleAction *)view) observerClick:^{
            [view tf_hide];
        }];
    }
    
    if ([title(ins) isEqualToString:@"exc2"]) {
        UIView *view = [self getViewName:@"ExcempleNotification"];
        TFPopupParam *param = [TFPopupParam new];
        param.offset = CGPointMake(0, +30);
        param.popupSize = CGSizeMake(396, 78);
        param.autoDissmissDuration = 1;
        param.disusePopupAlphaAnimation = YES;
        [view tf_showSlide:self.view direction:PopupDirectionTop popupParam:param];
        [((ExcempleNotification *)view) observerClick:^{
            [view tf_hide];
        }];
    }
    if ([title(ins) isEqualToString:@"exc3"]) {
        UIView *view = [self getViewName:@"ExcempleSign"];
        TFPopupParam *param = [TFPopupParam new];
        [view tf_showScale:self.view offset:CGPointMake(0, -100) popupParam:param];
    }
    
    if ([title(ins) isEqualToString:@"exc4"]) {
        UIView *view = [self getViewName:@"ExcempleUnfold"];
        TFPopupParam *param = [TFPopupParam new];
        param.disusePopupAlphaAnimation = YES;
        param.popOriginFrame = CGRectMake(0, 104, kSize.width, 1);
        param.popTargetFrame = CGRectMake(0, 104, kSize.width, 320);
        [view tf_showFrame:self.view
                      from:param.popOriginFrame
                        to:param.popTargetFrame
                popupParam:param];
        [((ExcempleUnfold *)view) observerClick:^{
            [view tf_hide];
        }];
    }
    
    if ([title(ins) isEqualToString:@"exc5"]) {
        UIView *view = [self getViewName:@"ExcempleBubble"];
        TFPopupParam *param = [TFPopupParam new];
        param.popupSize = CGSizeMake(165, 165);
        param.offset = CGPointMake(10, 10);
        param.backgroundColorClear = NO;
        [view tf_showBubble:self.view
                  basePoint:CGPointMake([UIScreen mainScreen].bounds.size.width - 20, 40)
            bubbleDirection:PopupDirectionBottomLeft
                 popupParam:param];
        [((ExcempleBubble *)view) observerClick:^{
            [view tf_hide];
        }];
    }
    
    if ([title(ins) isEqualToString:@"exc6"]) {
        UIView *big = [self getViewName:@"ExcempleSliderBig"];
        TFPopupParam *paramBig = [TFPopupParam new];
        [big tf_showSlide:self.view direction:PopupDirectionRight popupParam:paramBig];
        [((ExcempleSliderBig *)big) observerClick:^{
            [big tf_hide];
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *small = [self getViewName:@"ExcempleSliderSmall"];
            TFPopupParam *paramSmall = [TFPopupParam new];
            [small tf_showSlide:self.view direction:PopupDirectionRight popupParam:paramSmall];
            [((ExcempleSliderSmall *)small) observerClick:^{
                [small tf_hide];
            }];
        });
    }
    if ([title(ins) isEqualToString:@"exc7"]) {
        UIView *big = [self getViewName:@"ExcempleSliderLogin"];
        TFPopupParam *param = [TFPopupParam new];
        param.popupSize = kSize;
        [big tf_showSlide:self.view direction:PopupDirectionBottom popupParam:param];
        [((ExcempleSliderLogin *)big) observerClick:^{
            [big tf_hide];
        }];
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


-(NSArray *)cusButtons{
    NSArray *cp = @[self.cusButton0,self.cusButton1,self.cusButton2,self.cusButton3];
    return cp;
}

-(NSArray *)excempleButtons{
    NSArray *cp = @[self.excButton0,self.excButton1,self.excButton2,
                    self.excButton3,self.excButton4,self.excButton5,
                    self.excButton6];
    return cp;
}

@end
