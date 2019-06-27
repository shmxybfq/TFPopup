//
//  ExampleSliderBig.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExampleSliderBigBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExampleSliderBig : UIView
@property(nonatomic,  copy)ExampleSliderBigBlock block;

-(void)observerClick:(ExampleSliderBigBlock)block;
@end

NS_ASSUME_NONNULL_END
