//
//  ListView.h
//  TFPopupDemo
//
//  Created by ztf on 2019/1/23.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTableView.h"
typedef void(^SelectBlock)(NSString *data);
NS_ASSUME_NONNULL_BEGIN

@interface ListView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,  copy)SelectBlock block;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet CustomTableView *tableView;

-(void)reload:(NSArray <NSString *>*)data;

-(void)observerSelected:(SelectBlock)block;

@end

NS_ASSUME_NONNULL_END
