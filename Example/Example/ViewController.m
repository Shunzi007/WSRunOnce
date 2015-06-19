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
@property (strong, nonatomic) IBOutlet UILabel *versionLabel;
@property (strong, nonatomic) IBOutlet UILabel *buildLabel;
@property (strong, nonatomic) IBOutlet UILabel *onceLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)action:(UIButton *)sender {
    __weak typeof (self) weakself = self;
    self.versionLabel.text = @"";
    self.buildLabel.text = @"";
    self.onceLabel.text = @"";
    [WSRunOnce runOnceByVersionWithKey:@"version" action:^BOOL(NSString *version) {
        weakself.versionLabel.text = [NSString stringWithFormat:@"version = %@", version];
        return YES;
    }];
    [WSRunOnce runOnceByBuildWithKey:@"bulid" action:^BOOL(NSString *build) {
        weakself.buildLabel.text = [NSString stringWithFormat:@"build = %@", build];
        return YES;
    }];
    [WSRunOnce runOnceWithKey:@"key" action:^{
        weakself.onceLabel.text = @"runOnce";
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
