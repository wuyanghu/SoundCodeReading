//
//  ViewController+FishHook.m
//  CMain
//
//  Created by wupeng on 2019/10/27.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "ViewController+FishHook.h"
#import <objc/runtime.h>
#import "fishhook.h"

@implementation ViewController (FishHook)

+ (void)load{
    struct rebinding ex;
    ex.name = "method_exchangeImplementations";
    ex.replacement = myExchange;
    ex.replaced = (void *)&exchangP;
    
    struct rebinding rebs[1] = {ex};
    rebind_symbols(rebs, 1);
}

void(*exchangP)(Method m1,Method m2);

void myExchange(Method m1,Method m2){
    struct rebinding nslog;
    nslog.name = "NSLog";
    nslog.replacement = myNslog;
    nslog.replaced = (void *)&sys_nslog;
    
    struct rebinding rebs[1] = {nslog};
    rebind_symbols(rebs, 1);
    NSLog(@"想搞事情?");
}

#pragma mark - 交换NSLog

static void(*sys_nslog)(NSString * format,...);

void myNslog(NSString * format,...){
    format = [format stringByAppendingString:@"发现了非法操作!\n"];
    sys_nslog(format);
}

@end
