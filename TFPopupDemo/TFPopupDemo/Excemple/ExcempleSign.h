//
//  ExcempleSign.h
//  TFPopupDemo
//
//  Created by ztf on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExcempleSignBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExcempleSign : UIView
@property(nonatomic,  copy)ExcempleSignBlock block;

-(void)observerClick:(ExcempleSignBlock)block;
@end

NS_ASSUME_NONNULL_END
