//
//  ViewController.m
//  RoomManage
//
//  Created by 赵群涛 on 16/8/18.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "ViewController.h"
#import "QTManageViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btn:(id)sender {
    
    QTManageViewController *manageVC = [[QTManageViewController alloc] init];
    [self.navigationController pushViewController:manageVC animated:YES];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
