//
//  DragExampleController.m
//  TFPopupDemo
//
//  Created by zhutaofeng on 2019/9/4.
//  Copyright © 2019 ztf. All rights reserved.
//

#import "DragExampleController.h"

@interface DragExampleController ()

@end

@implementation DragExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)navBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
