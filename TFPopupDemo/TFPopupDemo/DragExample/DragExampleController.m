//
//  DragExampleController.m
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/9/4.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "DragExampleController.h"
#import "TFPopup.h"
#import "DragPercentView0.h"
#import "DragPercentView1.h"
@interface DragExampleController ()

@end

@implementation DragExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)navBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)percentDrag:(id)sender {
    
    UIImageView *imageView = [[DragPercentView1 alloc]initWithFrame:CGRectMake(0, 0, 350, 210)];
    
    TFPopupParam *param = [TFPopupParam new];
    param.dragEnable = YES;
    param.dragStyle = DragStyleToBottom;
    param.dragAutoDissmissMinDistance = 150;
    param.offset = CGPointMake(0, -200);
    [imageView tf_showSlide:self.view direction:PopupDirectionBottom popupParam:param];
}

- (IBAction)freeDrag:(id)sender {

    UIImageView *imageView = [[DragPercentView0 alloc]initWithFrame:CGRectMake(0, 0, 250, 260)];
    
    TFPopupParam *param = [TFPopupParam new];
    param.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    param.dragEnable = YES;
    param.dragStyle = DragStyleFree;
    [imageView tf_showScale:self.view offset:CGPointZero popupParam:param];
}

- (IBAction)showTop:(id)sender {
    
    UIImage *image = [UIImage imageNamed:@"popup-11"];
    CGRect bounds = [UIScreen mainScreen].bounds;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.width / (image.size.width / image.size.height))];
    imageView.userInteractionEnabled = YES;
    imageView.image = image;
    
    TFPopupParam *param = [TFPopupParam new];
    param.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    param.disuseShowPopupAlphaAnimation = YES;
    param.disuseHidePopupAlphaAnimation = YES;
    param.dragEnable = YES;
    param.dragBouncesEnable = YES;
    param.dragAutoDissmissMinDistance = 60;
    [imageView tf_showSlide:self.view direction:PopupDirectionTop popupParam:param];
}


- (IBAction)showBottom:(id)sender {
    UIImage *image = [UIImage imageNamed:@"popup-10"];

    CGRect bounds = [UIScreen mainScreen].bounds;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.width / (image.size.width / image.size.height))];
    imageView.userInteractionEnabled = YES;
    imageView.image = image;

    TFPopupParam *param = [TFPopupParam new];
    param.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    param.disuseShowPopupAlphaAnimation = YES;
    param.disuseHidePopupAlphaAnimation = YES;
    param.dragEnable = YES;
    param.dragBouncesEnable = YES;
    param.dragStyle = DragStyleToLeft | DragStyleToRight | DragStyleToBottom;
    param.dragAutoDissmissMinDistance = 150;
    [imageView tf_showSlide:self.view direction:PopupDirectionBottom popupParam:param];
}

@end
