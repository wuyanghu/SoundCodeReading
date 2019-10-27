//
//  ViewController+HOOKTest.m
//  CMain
//
//  Created by wupeng on 2019/10/27.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "ViewController+HOOKTest.h"
#import <objc/runtime.h>

@implementation ViewController (HOOKTest)

+ (void)load{
    Method viewDidAppear = class_getInstanceMethod(self, @selector(viewDidAppear:));
    Method my_viewDidAppear = class_getInstanceMethod(self, @selector(my_viewDidAppear:));
    method_exchangeImplementations(viewDidAppear, my_viewDidAppear);
}

- (void)my_viewDidAppear:(BOOL)animated{
    NSLog(@"我是假的 ~ 老弟 你来了啊");
    [self my_viewDidAppear:animated];
}

@end
