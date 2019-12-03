//
//  ViewController.m
//  CMain
//
//  Created by wupeng on 2019/10/26.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "ViewController.h"

NSString * const LMJName = @"wupeng hellor";

@interface ViewController ()

@end

@implementation ViewController
//0x3028+0x0000000102d82000

/*
 adrp    x8, _counter@PAGE //使用 adrp 命令计算出 _counter label 基于 PC 的偏移量的高 21 位，并存储在 x8 寄存器中，@PAGE 代表页偏移的高 21 位；
 ldr    w0, [x8, _counter@PAGEOFF]//通过 @PAGEOFF 代表页偏移的低 12 位；
 ret
 */

int counter = 1;
int getCount() {
    return counter;
}

void test(){
    int sum = 0;
    for (int i = 0; i<100; i++) {
        sum += i;
    }
    printf("sum:%d",sum);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    test();
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"这是正经的 viewDidAppear");
}

#pragma mark - 触摸事件

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了屏幕!!");
    [self viewDidAppear:YES];
    NSLog(@"%@",LMJName);
}

@end
