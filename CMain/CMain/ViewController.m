//
//  ViewController.m
//  CMain
//
//  Created by wupeng on 2019/10/26.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "ViewController.h"
#import "fishhook.h"

@interface ViewController ()

@end

@implementation ViewController
//0x3028+0x0000000102d82000

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"我还没被绑定");
    NSLog(@"我还是个老司机");
    
    struct rebinding nslog;
    nslog.name = "NSLog";
    nslog.replacement = myNslog;
    nslog.replaced = (void *)&sys_nslog;
    
    struct rebinding rebs[1] = {nslog};
    rebind_symbols(rebs, 1);
}

static void(*sys_nslog)(NSString * format,...);

void myNslog(NSString * format,...){
    format = [format stringByAppendingString:@"勾上了!\n"];
    sys_nslog(format);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了屏幕!!");
}

@end
