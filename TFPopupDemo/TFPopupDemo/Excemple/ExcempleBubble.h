//
//  ExcempleBubble.h
//  TFPopupDemo
//
//  Created by Time on 2019/2/21.
//  Copyright © 2019 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ExcempleBubbleBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface ExcempleBubble : UIView
@property(nonatomic,  copy)ExcempleBubbleBlock block;

-(void)observerClick:(ExcempleBubbleBlock)block;
@end

NS_ASSUME_NONNULL_END
