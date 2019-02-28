//
//  ExcempleUnfold.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExcempleUnfoldBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExcempleUnfold : UIView
@property(nonatomic,  copy)ExcempleUnfoldBlock block;

-(void)observerClick:(ExcempleUnfoldBlock)block;
@end

NS_ASSUME_NONNULL_END
