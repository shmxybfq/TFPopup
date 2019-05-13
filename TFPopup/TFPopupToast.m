//
//  TFPopupToast.m
//  TFPopupDemo
//
//  Created by ztf on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "TFPopupToast.h"
#import "UIView+TFPopup.h"

@interface TFPopupToast ()<TFPopupDelegate>

@property(nonatomic,assign)CGRect inViewFrame;
@property(nonatomic,  copy)NSString *msg;
@property(nonatomic,  copy)TFPopupToastBlock cusBlock;

@end

@implementation TFPopupToast


+(void)tf_show:(UIView *)inView msg:(NSString *)msg animationType:(TFAnimationType)animationType{
    [TFPopupToast tf_show:inView
                      msg:msg
                   offset:CGPointZero
         dissmissDuration:0
            animationType:animationType
              custemBlock:nil];
}

+(void)tf_show:(UIView *)inView
           msg:(NSString *)msg
        offset:(CGPoint)offset
dissmissDuration:(NSTimeInterval)duration
 animationType:(TFAnimationType)animationType
   custemBlock:(TFPopupToastBlock)custemBlock{
    if (inView == nil) {NSLog(@"****** %@ %@ ******",[self class],@"inView 不能为空！");return;}
    if (msg == nil) {NSLog(@"****** %@ %@ ******",[self class],@"msg 不能为空！");return;}
    
    TFPopupParam *param = [TFPopupParam new];
    param.disuseBackground = YES;
    param.offset = offset;
    if (duration == 0) {
        param.autoDissmissDuration = [TFPopupToast toastDuration:msg];
    }else{
        param.autoDissmissDuration = duration;
    }
    
    TFPopupToast *toast = [[TFPopupToast alloc]initWithFrame:CGRectZero];
    toast.inViewFrame = inView.bounds;
    toast.msg = msg;
    toast.cusBlock = custemBlock;
    
    switch (animationType) {
        case TFAnimationTypeFade:
            [toast tf_showNormal:inView popupParam:param];
            break;
        case TFAnimationTypeScale:
            [toast tf_showScale:inView offset:CGPointZero popupParam:param];
            break;
        default:
            break;
    }
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        self.userInteractionEnabled = NO;
        [self addSubview:self.msgLabel];
        
    }
    return self;
}

-(void)setMsg:(NSString *)msg{
    _msg = [msg copy];
    
    self.frame = [self toastFrame];
    self.msgLabel.frame = [self toastLabelFrame];
    self.msgLabel.text = msg;
}


+(NSTimeInterval)toastDuration:(NSString *)msg{
    NSTimeInterval dur = 0;
    if ([msg isKindOfClass:[NSString class]] && msg.length > 10) {
        dur = (msg.length - 10) / 10 + 1.5;
        if (dur > 5) {
            dur = 5;
        }
    }else{
        dur = 1.5;
    }
    return dur;
}

-(CGRect)toastFrame{
    
    CGRect frame = self.inViewFrame;
    CGSize constrantSize = CGSizeMake(frame.size.width - 60, frame.size.height - 60);
    NSDictionary *attr = @{NSFontAttributeName:self.msgLabel.font};
    NSString *msg = [NSString stringWithFormat:@"  %@  ",self.msg];
    CGSize size = [msg boundingRectWithSize:constrantSize
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attr
                                    context:nil].size;
    size = CGSizeMake(size.width + 30, size.height + 30);
    size = CGSizeMake(size.width < 60.0?60.0:size.width, size.height < 40.0?40.0:size.height);
    CGFloat x = 15 + (frame.size.width - 30 - size.width) * 0.5;
    CGFloat y = 15 + (frame.size.height - 30 - size.height) * 0.5;
    CGRect fr = CGRectMake(x ,y ,size.width ,size.height);
    return fr;
}

-(CGRect)toastLabelFrame{
    CGRect fr = CGRectMake(15, 15,self.frame.size.width - 15 * 2,self.frame.size.height - 15 * 2);
    return fr;
}

-(UILabel *)msgLabel{
    if (_msgLabel == nil) {
        _msgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _msgLabel.textColor = [UIColor whiteColor];
        _msgLabel.font = [UIFont systemFontOfSize:13];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        _msgLabel.backgroundColor = [UIColor clearColor];
        _msgLabel.numberOfLines = 0;
        _msgLabel.lineBreakMode = NSLineBreakByClipping;
        _msgLabel.clipsToBounds = NO;
    }
    return _msgLabel;
}



@end
