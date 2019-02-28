//
//  ExcempleAction.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExcempleActionBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExcempleAction : UIView
@property(nonatomic,  copy)ExcempleActionBlock block;

-(void)observerClick:(ExcempleActionBlock)block;
@end

NS_ASSUME_NONNULL_END
