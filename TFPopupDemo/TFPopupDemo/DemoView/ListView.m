//
//  ListView.m
//  TFPopupDemo
//
//  Created by Time on 2019/1/23.
//  Copyright © 2019年 ztf. All rights reserved.
//

#import "ListView.h"

@implementation ListView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self reload:@[@"我只是一个普通的列表",
                   @"我可以随便弹出来",
                   @"下拉列表框",
                   @"或者是气泡",
                   @"可以是直接弹出来",
                   @"或者滑动",
                   @"或者是你想要的任何方式",
                   @"我只是一个普通的列表",
                   @"我可以随便弹出来",
                   @"下拉列表框",
                   @"或者是气泡",
                   @"可以是直接弹出来",
                   @"或者滑动",
                   @"或者是你想要的任何方式"]];
}

-(void)reload:(NSArray <NSString *>*)data{
    [self.dataSource removeAllObjects];
    [self.dataSource addObjectsFromArray:data];
    [self.tableView reloadData];
}

-(void)observerSelected:(SelectBlock)block{
    self.block = block;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.block) {
        self.block([self.dataSource objectAtIndex:indexPath.row]);
    }
}

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

@end
