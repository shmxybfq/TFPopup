//
//  TFPopupToast.m
//  TFPopupDemo
//
//  Created by Time on 2019/1/14.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "TFPopupToast.h"
#import "TFPopupManager.h"


@interface TFPopupToast ()<TFPopupManagerDataSource,TFPopupManagerDelegate>

@property(nonatomic,strong)UIView *inview;
@property(nonatomic,strong)TFPopupManager *manager;

@property(nonatomic,assign)UIEdgeInsets defaultLabelEdge;

@property(nonatomic,  copy)TFPopupToastBlock animationFinishBlock;
@property(nonatomic,  copy)TFPopupToastBlock custemShowBlock;
@property(nonatomic,  copy)TFPopupToastBlock custemHideBlock;

@end

@implementation TFPopupToast

+(void)showToast:(UIView *)inView msg:(NSString *)msg{
    [self showToast:inView msg:msg animationFinish:nil];
}

+(void)showToast:(UIView *)inView
             msg:(NSString *)msg
 animationFinish:(TFPopupToastBlock)animationFinishBlock{
    
    [self showToast:inView msg:msg custemShow:^(TFPopupToast *toast) {
        CGRect frame = toast.frame;
        frame = CGRectMake(frame.origin.x, frame.origin.y * 0.618, frame.size.width, frame.size.height);
        toast.frame = frame;
    } custemHide:^(TFPopupToast *toast) {
        CGRect frame = toast.frame;
        frame = CGRectMake(frame.origin.x, frame.origin.y * 0.618, frame.size.width, frame.size.height);
        toast.frame = frame;
    } animationFinish:animationFinishBlock];
}

+(void)showToast:(UIView *)inView
             msg:(NSString *)msg
      custemShow:(TFPopupToastBlock)custemShowBlock
      custemHide:(TFPopupToastBlock)custemHideBlock
 animationFinish:(TFPopupToastBlock)animationFinishBlock{
    
    if (inView == nil) {NSLog(@"****** %@ %@ ******",[self class],@"inView 不能为空！");return;}
    if (msg == nil) {NSLog(@"****** %@ %@ ******",[self class],@"msg 不能为空！");return;}
    
    TFPopupToast *toast = [[TFPopupToast alloc]initWithFrame:CGRectZero];
    toast.inview = inView;
    toast.msg = msg;
    toast.animationFinishBlock = animationFinishBlock;
    toast.custemShowBlock = custemShowBlock;
    toast.custemHideBlock = custemHideBlock;
    
    toast.manager = [TFPopupManager tf_popupManagerDataSource:toast delegate:toast];
    [toast.manager performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    [toast.manager performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.alpha = 0.0;
        
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        self.userInteractionEnabled = NO;
        
        self.animtionDuration = 0.3;
        self.defaultLabelEdge = UIEdgeInsetsMake(5, 10, 5, 10);
        
        [self addSubview:self.msgLabel];
    }
    return self;
}

-(void)setMsg:(NSString *)msg{
    _msg = [msg copy];
    self.msgLabel.text = _msg;
}

/* 执行顺序:0 返回【是否使用默认动画方式】 */
-(BOOL)tf_popupManager_didCustemAnimation:(TFPopupToast *)manager{
    return YES;
}
/* 执行顺序:1 返回【弹框的父视图】 */
-(UIView  *)tf_popupManager_popForView:(TFPopupToast *)manager{
    return self.inview;
}
/* 执行顺序:4 返回【弹出框view】 */
-(UIView  *)tf_popupManager_popBoardView:(TFPopupToast *)manager{
    return self;
}

-(void)tf_popupManager_willShow:(TFPopupToast *)manager{
    x_weakSelf;
    
    [self prepareShow];
    
    if (self.custemShowBlock) {
        self.custemShowBlock(self);
    }
    
    if (self.animtionDuration > 0.0) {
        [UIView animateWithDuration:self.animtionDuration animations:^{
            weakself.alpha = 1.0;
        }completion:^(BOOL finished) {
            if (weakself.animationFinishBlock) {
                weakself.animationFinishBlock(weakself);
            }
        }];
    }else{
        self.alpha = 1;
        if (weakself.animationFinishBlock) {
            weakself.animationFinishBlock(weakself);
        }
    }
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.autoDissDuration * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [weakself.manager hide];
    });
}

-(void)tf_popupManager_willHide:(TFPopupToast *)manager{
    x_weakSelf;
    [self prepareShow];
    
    if (self.custemHideBlock) {
        self.custemHideBlock(self);
    }
    
    if (self.animtionDuration > 0.0) {
        [UIView animateWithDuration:self.animtionDuration animations:^{
            weakself.alpha = 0.0;
        }completion:^(BOOL finished) {
            if (weakself.animationFinishBlock) {
                weakself.animationFinishBlock(weakself);
            }
            [weakself removeFromSuperview];
        }];
    }else{
        self.alpha = 0;
        if (weakself.animationFinishBlock) {
            weakself.animationFinishBlock(weakself);
        }
        [self removeFromSuperview];
    }
}

-(void)prepareShow{
    
    if ([self.msg isKindOfClass:[NSString class]] && self.msg.length > 10) {
        self.autoDissDuration = (self.msg.length - 10) / 10 + 1.5;
        if (self.autoDissDuration > 5) {
            self.autoDissDuration = 5;
        }
    }else{
        self.autoDissDuration = 1.5;
    }
    
    CGRect frame = self.inview.frame;
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
    self.frame = CGRectMake(x ,y ,size.width ,size.height);
    self.msgLabel.frame = CGRectMake(15, 15,
                                     self.frame.size.width - 15 * 2,
                                     self.frame.size.height - 15 * 2);
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
