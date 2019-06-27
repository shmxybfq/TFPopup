//
//  ExampleSliderLogin.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/23.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ExampleSliderLoginBlock)(void);
@interface ExampleSliderLogin : UIView
@property(nonatomic,  copy)ExampleSliderLoginBlock block;
-(void)observerClick:(ExampleSliderLoginBlock)block;

@end

NS_ASSUME_NONNULL_END


