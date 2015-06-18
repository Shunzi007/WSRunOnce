//
//  ViewController.m
//  Example
//
//  Created by 王顺 on 15/6/18.
//  Copyright © 2015年 wangshun. All rights reserved.
//

#import "ViewController.h"
#import "WSRunOnce.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)action:(UIButton *)sender {
    [WSRunOnce runOnceByVersionWithKey:@"version" action:^BOOL(NSString *version) {
        NSLog(@"version = %@", version);
        return YES;
    }];
    [WSRunOnce runOnceByBuildWithKey:@"bulid" action:^BOOL(NSString *build) {
        NSLog(@"build = %@", build);
        return YES;
    }];
    [WSRunOnce runOnceWithKey:@"key" action:^{
        NSLog(@"runOnce");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
