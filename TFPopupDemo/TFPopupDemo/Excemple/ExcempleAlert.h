//
//  ExcempleAlert.h
//  TFPopupDemo
//
//  Created by Time on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExcempleAlertBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExcempleAlert : UIView
@property(nonatomic,  copy)ExcempleAlertBlock block;

-(void)observerClick:(ExcempleAlertBlock)block;
@end

NS_ASSUME_NONNULL_END
