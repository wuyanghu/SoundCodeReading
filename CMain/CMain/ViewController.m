//
//  ViewController.m
//  CMain
//
//  Created by wupeng on 2019/10/26.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
//0x3028+0x0000000102d82000

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"这是正经的 viewDidAppear");
}

#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了屏幕!!");
    [self viewDidAppear:YES];
}

@end
