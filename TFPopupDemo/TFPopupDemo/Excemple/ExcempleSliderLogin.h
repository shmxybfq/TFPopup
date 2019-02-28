//
//  ExcempleSliderLogin.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/23.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ExcempleSliderLoginBlock)(void);
@interface ExcempleSliderLogin : UIView
@property(nonatomic,  copy)ExcempleSliderLoginBlock block;
-(void)observerClick:(ExcempleSliderLoginBlock)block;

@end

NS_ASSUME_NONNULL_END


