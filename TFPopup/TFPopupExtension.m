//
//  TFPopupExtension.m
//  TFPopupDemo
//
//  Created by Time on 2019/3/4.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "TFPopupExtension.h"
#import "UIView+TFPopup.h"
@implementation TFPopupExtension

-(NSMutableArray *)backgroundViewArray{
    if (_backgroundViewArray == nil) {
        _backgroundViewArray = [[NSMutableArray alloc]init];
    }
    return _backgroundViewArray;
}
-(NSMutableArray *)backgroundViewFrameArray{
    if (_backgroundViewFrameArray == nil) {
        _backgroundViewFrameArray = [[NSMutableArray alloc]init];
    }
    return _backgroundViewFrameArray;
}


@end


@implementation TFPopupPool

static TFPopupPool *_popupPool = nil;
+(instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _popupPool = [[TFPopupPool alloc]init];
    });
    return _popupPool;
}

+(void)refreshPool{
    [[TFPopupPool shareInstance]refreshPool];
}

-(void)refreshPool{
    NSMutableArray *newPool = [[NSMutableArray alloc]init];
    for (TFPopupPoolBridge *bridge in self.pool) {
        if (bridge.popupView != nil) {
            [newPool addObject:bridge];
        }
    }
    [self.pool removeAllObjects];
    [self.pool addObjectsFromArray:newPool];
}
+(void)addToPool:(UIView *)popupView{
    [[TFPopupPool shareInstance]addToPool:popupView];
}
-(void)addToPool:(UIView *)popupView{
    TFPopupPoolBridge *bridge = [[TFPopupPoolBridge alloc]init];
    bridge.popupView = popupView;
    [self.pool addObject:bridge];
}

+(UIView *)findPopup:(NSString *)identifier{
    return [[TFPopupPool shareInstance]findPopup:identifier];
}

-(UIView *)findPopup:(NSString *)identifier{
    for (TFPopupPoolBridge *bridge in self.pool) {
        if ([bridge.popupView.identifier isEqualToString:identifier]) {
            return bridge.popupView;
        }
    }
    return nil;
}
+(NSArray <UIView *>*)allPopup{
    return [[TFPopupPool shareInstance]allPopup];
}
-(NSArray <UIView *>*)allPopup{
    NSMutableArray *newPool = [[NSMutableArray alloc]init];
    for (TFPopupPoolBridge *bridge in self.pool) {
        if (bridge.popupView.superview != nil) {
            [newPool addObject:bridge];
        }
    }
    return newPool;
}
-(NSMutableArray *)pool{
    if (!_pool) {
        _pool = [[NSMutableArray alloc]init];
    }
    return _pool;
}

@end

@implementation TFPopupPoolBridge

@end
