//
//  TestViewController.m
//  YQ_SafeTimer
//
//  Created by fyq on 2018/3/28.
//  Copyright © 2018年 future. All rights reserved.
//

#import "TestViewController.h"
#import "YQ_TimerManager.h"

@interface TestViewController ()

@property (nonatomic, strong) YQ_TimerManager *timerManager;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIButton *resumePauseBtn;

@end

static NSString * const myTimer = @"MyTimer";
static NSUInteger n = 0;

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"timer running";
    
    UIButton *resumePauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resumePauseBtn.bounds = CGRectMake(0, 0, 150, 150);
    resumePauseBtn.center = self.view.center;
    [self.view addSubview:resumePauseBtn];
    [resumePauseBtn setTitle:@"Pause 暂停" forState:UIControlStateNormal];
    [resumePauseBtn setTitle:@"Resume 恢复" forState:UIControlStateSelected];
    resumePauseBtn.backgroundColor = [UIColor orangeColor];
    resumePauseBtn.layer.cornerRadius = 50;
    resumePauseBtn.layer.masksToBounds = YES;
    [resumePauseBtn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self testYQTimer];
}

- (void)didClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [[YQ_TimerManager sharedInstance] pauseTimerWithName:myTimer];
    }else {
        [[YQ_TimerManager sharedInstance] resumeTimerWithName:myTimer];
    }
}

- (void)dealloc {
    
    n = 0;
    NSLog(@"%@销毁了", [self class]);
    NSLog(@"%@", self.timer);
}

- (void)testSystemNSTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(doSomething)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)testYQTimer {
    __weak typeof(self) weakSelf = self;
    [[YQ_TimerManager sharedInstance] scheduledDispatchTimerWithName:myTimer
                                                        timeInterval:1.0
                                                               queue:nil
                                                             repeats:YES
                                                        actionOption:AbandonPreviousAction
                                                              action:^{
                                                                  [weakSelf doSomething];
                                                              }];
}

- (void)testSystemNSTimerAfteriOS10 {
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 repeats:YES
                                                   block:^(NSTimer * _Nonnull timer) {
                                                       [weakSelf doSomething];
                                                   }];
}

/* timer每次执行打印一条log记录，在执行到n==5的时候invalidate掉timer */
- (void)doSomething {
    __weak typeof(self) weakSelf = self;
    
    NSLog(@"myTimer runs %lu times!", (unsigned long)n++);
    
    if (n >= 5) {
        [self.timer invalidate];
        self.timer = nil;
        [[YQ_TimerManager sharedInstance] invalidateTimerWithName:myTimer];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
