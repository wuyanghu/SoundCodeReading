//
//  ViewController.m
//  RunTimeDebug
//
//  Created by wupeng on 2019/11/7.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

+ (void)load{
    NSLog(@"ViewController load");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * className = [NSString stringWithUTF8String:object_getClassName(self)];
    (void)className;
    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
