//
//  ExcempleSliderLogin.m
//  TFPopupDemo
//
//  Created by ztf on 2019/2/23.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "ExcempleSliderLogin.h"

@implementation ExcempleSliderLogin

-(void)observerClick:(ExcempleSliderLoginBlock)block{
    self.block = block;
}

-(void)awakeFromNib{
    [super awakeFromNib];
//    self.layer.cornerRadius = 6;
//    self.layer.masksToBounds = YES;
    
    
}
- (IBAction)sure:(id)sender {
    if (self.block) {
        self.block();
    }
}
@end
