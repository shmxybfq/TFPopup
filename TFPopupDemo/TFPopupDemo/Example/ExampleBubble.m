//
//  ExampleBubble.m
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "ExampleBubble.h"

@implementation ExampleBubble
-(void)dealloc{
    NSLog(@"已释放====:%@",NSStringFromClass([self class]));
}
-(void)observerClick:(ExampleBubbleBlock)block{
    self.block = block;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
    
    
}
- (IBAction)sure:(id)sender {
    if (self.block) {
        self.block();
    }
}

@end
