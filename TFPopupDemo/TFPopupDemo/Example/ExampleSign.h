//
//  ExampleSign.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExampleSignBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExampleSign : UIView
@property(nonatomic,  copy)ExampleSignBlock block;

-(void)observerClick:(ExampleSignBlock)block;
@end

NS_ASSUME_NONNULL_END
