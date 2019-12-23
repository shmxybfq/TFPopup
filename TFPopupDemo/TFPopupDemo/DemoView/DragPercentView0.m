
//
//  DragPercentView0.m
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/12/23.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "DragPercentView0.h"
#import "TFPopup.h"
@implementation DragPercentView0

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"popup-1"];
        self.userInteractionEnabled = YES;
    }
    return self;
}

@end
