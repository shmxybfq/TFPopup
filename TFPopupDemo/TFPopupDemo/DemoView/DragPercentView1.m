//
//  DragPercentView1.m
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/12/23.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "DragPercentView1.h"
#import "TFPopup.h"
@implementation DragPercentView1


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"popup-2"];
        self.userInteractionEnabled = YES;
    }
    return self;
}


#pragma mark - 重写背景方法-实现自定义背景
- (NSInteger)tf_popupBackgroundViewCount:(UIView *)popup{
    return 2;
}
- (UIView *)tf_popupView:(UIView *)popup backgroundViewAtIndex:(NSInteger)index{
    UIImageView *bg = [[UIImageView alloc]init];
    bg.contentMode = UIViewContentModeScaleAspectFill;
    bg.backgroundColor = [UIColor clearColor];
    if (index == 0) {
        bg.image = [UIImage imageNamed:@"lovers_left"];
    }else if (index == 1) {
        bg.image = [UIImage imageNamed:@"lovers_right"];
    }
    return bg;
}
- (CGRect)tf_popupView:(UIView *)popup backgroundViewFrameAtIndex:(NSInteger)index{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (index == 0) {
        return CGRectMake(-size.width, 0, size.width, size.height);
    }else if (index == 1) {
        return CGRectMake(size.width, 0, size.width, size.height);
    }
    return CGRectZero;
}



-(void)tf_popupViewDidShow:(UIView *)popup{
    UIView *bg0 =  [popup.extension.backgroundViewArray objectAtIndex:0];
    UIView *bg1 =  [popup.extension.backgroundViewArray objectAtIndex:1];
    [UIView animateWithDuration:0.3 animations:^{
        bg0.frame = [UIScreen mainScreen].bounds;
        bg1.frame = [UIScreen mainScreen].bounds;
    } completion:nil];
    [super tf_popupViewDidShow:popup];
}


- (BOOL)tf_popupViewDidDragSlide:(UIView *)popup distancePercent:(CGFloat)percent distance:(CGFloat)distance state:(UIGestureRecognizerState)state{
    CGSize size = [UIScreen mainScreen].bounds.size;
    UIView *bg0 =  [popup.extension.backgroundViewArray objectAtIndex:0];
    UIView *bg1 =  [popup.extension.backgroundViewArray objectAtIndex:1];
    if (state == UIGestureRecognizerStateChanged) {
        bg0.frame = CGRectMake(- (1 - percent) * size.width, 0, size.width, size.height);
        bg1.frame = CGRectMake((1 - percent) * size.width, 0, size.width, size.height);
    }else{
        if (distance < popup.popupParam.dragAutoDissmissMinDistance) {
            [UIView animateWithDuration:0.25 animations:^{
                bg0.frame = [UIScreen mainScreen].bounds;
                bg1.frame = [UIScreen mainScreen].bounds;
            }];
        }else{
            [UIView animateWithDuration:0.25 animations:^{
                bg0.frame = CGRectMake(-size.width, 0, size.width, size.height);
                bg1.frame = CGRectMake(size.width, 0, size.width, size.height);
            }];
        }
    }
    return YES;
}

@end
