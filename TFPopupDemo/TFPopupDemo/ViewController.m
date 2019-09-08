//
//  ViewController.m
//  TFPopupDemo
//
//  Created by ztf on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "ViewController.h"

#import "TFPopup.h"
#import "ListView.h"
#import "BlankView.h"
#import "AlertNormal.h"

#import "ExampleAlert.h"
#import "ExampleAction.h"
#import "ExampleNotification.h"
#import "ExampleSign.h"
#import "ExampleUnfold.h"
#import "ExampleBubble.h"
#import "ExampleSliderBig.h"
#import "ExampleSliderSmall.h"
#import "ExampleSliderLogin.h"
#import "ExampleViewController.h"
#import "DragExampleController.h"
#import "TFPopupLoading.h"

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


@property (weak, nonatomic) IBOutlet UITextField *textField0;
@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;

@property (weak, nonatomic) IBOutlet UIButton *showButton;

@property(nonatomic,strong)NSArray *topButtons;
@property(nonatomic,strong)NSArray *midButtons;
@property(nonatomic,strong)NSArray *botButtons;
@property(nonatomic,strong)NSArray *cusButtons;
@property(nonatomic,strong)NSArray *ExampleButtons;
@property (weak, nonatomic) IBOutlet UIButton *watchExampleButton;
@property (weak, nonatomic) IBOutlet UIButton *dragExampleButton;

@property(nonatomic,strong)TFPopupParam *param;
@property(nonatomic,  copy)NSString *animationType;
@property(nonatomic,assign)PopupDirection popupDirection;
@property(nonatomic,assign)NSInteger customIndex;
@property (weak, nonatomic) IBOutlet UIView *redPoint;

//默认alpha = 0
@property (weak, nonatomic) IBOutlet UIButton *ExampleCoverButton;

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
    if ([self.textField0.text floatValue] != 0.3 && [self.textField0.text floatValue] > 0.0) {
        self.param.duration = [self.textField0.text floatValue];
    }
    if ([self.textField1.text floatValue] > 0.0) {
        self.param.autoDissmissDuration = [self.textField1.text floatValue];
    }
    if ([self.textField2.text floatValue] > 0.0) {
        self.param.showAnimationDelay = [self.textField2.text floatValue];
        self.param.hideAnimationDelay = [self.textField2.text floatValue];
    }
    
    if ([self.animationType isEqualToString:@"直接弹"]) {

        UIView *popup = [self getAlertView];

        [popup tf_showNormal:self.view animated:NO];
        //[popup tf_showNormal:self.view offset:CGPointMake(0, -100) animated:NO];

    }if ([self.animationType isEqualToString:@"渐隐"]) {

        UIView *popup = [self getAlertView];
        //[popup tf_showNormal:self.view animated:YES];
        //[popup tf_showNormal:self.view offset:CGPointMake(0, -100) animated:YES];
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
        self.param.dragEnable = YES;
        [popup tf_showSlide:self.view direction:self.popupDirection popupParam:self.param];

    }else if ([self.animationType isEqualToString:@"泡泡"]) {

        self.param.popupSize = CGSizeMake(150, 250);
//        self.param.duration = 2;
        UIView *popup = [self getListView];
        popup.layer.borderColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5].CGColor;
        popup.layer.borderWidth = 1;
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

    }else if ([self.animationType isEqualToString:@"折叠"]) {

        CGRect targetFrame = CGRectMake(0, 110, kSize.width, 200);
        UIView *popup = [self getListView];
        [popup tf_showFold:self.view
               targetFrame:targetFrame
                 direction:self.popupDirection
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
        self.param.disuseShowBackgroundAlphaAnimation = ins.selected;
        self.param.disuseHideBackgroundAlphaAnimation = ins.selected;
    }
    if ([title(ins) isEqualToString:@"不使用弹出渐隐动画"]) {
        self.param.disuseShowPopupAlphaAnimation = ins.selected;
        self.param.disuseHidePopupAlphaAnimation = ins.selected;
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

-(UIView *)getAlertView{
    AlertNormal *alert = (AlertNormal *)[self getViewName:@"AlertNormal"];
    __weak __typeof(alert) weakView = alert;
    [alert observerSure:^{
        [weakView tf_hide];
    }];
    return alert;
}


-(UIView *)getListView{
    ListView *list = (ListView *)[self getViewName:@"ListView"];
    __weak __typeof(list) weakView = list;
    [list observerSelected:^(NSString *data) {
        [weakView tf_hide];
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
    self.showButton.layer.cornerRadius = 20;
    [self.showButton addTarget:self
                        action:@selector(showClick:)
              forControlEvents:UIControlEventTouchUpInside];

    self.redPoint.layer.cornerRadius = 5;


    [self.watchExampleButton addTarget:self
                                 action:@selector(watchExampleButtonClick)
                       forControlEvents:UIControlEventTouchUpInside];
    
    [self.dragExampleButton addTarget:self
                                action:@selector(dragExampleButtonClick)
                      forControlEvents:UIControlEventTouchUpInside];
}

-(void)watchExampleButtonClick{
    ExampleViewController *con = [[ExampleViewController alloc]initWithNibName:@"ExampleViewController" bundle:nil];
    [self presentViewController:con animated:YES completion:nil];
}

-(void)dragExampleButtonClick{
    DragExampleController *con = [[DragExampleController alloc]initWithNibName:@"DragExampleController" bundle:nil];
    [self presentViewController:con animated:YES completion:nil];
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
