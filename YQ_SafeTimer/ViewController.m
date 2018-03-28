//
//  ViewController.m
//  YQ_SafeTimer
//
//  Created by fyq on 2018/3/28.
//  Copyright © 2018年 future. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    UIButton *completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    completeBtn.bounds = CGRectMake(0, 0, 150, 150);
    completeBtn.center = self.view.center;
    [self.view addSubview:completeBtn];
    [completeBtn setTitle:@"Click here" forState:UIControlStateNormal];
    completeBtn.backgroundColor = [UIColor orangeColor];
    completeBtn.layer.cornerRadius = 50;
    completeBtn.layer.masksToBounds = YES;
    [completeBtn addTarget:self action:@selector(didTestYQTimer) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTestYQTimer {
    
    TestViewController *testVC = [[TestViewController alloc] init];
    testVC.view.backgroundColor = [UIColor purpleColor];
    [self.navigationController pushViewController:testVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
