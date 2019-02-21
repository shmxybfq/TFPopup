//
//  ExcempleSliderSmall.h
//  TFPopupDemo
//
//  Created by Time on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExcempleSliderSmallBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExcempleSliderSmall : UIView
@property(nonatomic,  copy)ExcempleSliderSmallBlock block;

-(void)observerClick:(ExcempleSliderSmallBlock)block;
@end

NS_ASSUME_NONNULL_END
