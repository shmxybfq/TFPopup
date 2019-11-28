//
//  TFPopupExtension.m
//  TFPopupDemo
//
//  Created by Time on 2019/3/4.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "TFPopupExtension.h"

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
