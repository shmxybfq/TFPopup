//
//  ExampleUnfold.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExampleUnfoldBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExampleUnfold : UIView
@property(nonatomic,  copy)ExampleUnfoldBlock block;

-(void)observerClick:(ExampleUnfoldBlock)block;
@end

NS_ASSUME_NONNULL_END
