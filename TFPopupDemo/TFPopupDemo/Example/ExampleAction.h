//
//  ExampleAction.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExampleActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExampleAction : UIView
@property(nonatomic,  copy)ExampleActionBlock block;

-(void)observerClick:(ExampleActionBlock)block;
@end

NS_ASSUME_NONNULL_END
