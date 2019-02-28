//
//  ExcempleSliderBig.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExcempleSliderBigBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExcempleSliderBig : UIView
@property(nonatomic,  copy)ExcempleSliderBigBlock block;

-(void)observerClick:(ExcempleSliderBigBlock)block;
@end

NS_ASSUME_NONNULL_END
