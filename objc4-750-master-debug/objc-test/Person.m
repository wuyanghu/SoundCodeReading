//
//  Person.m
//  objc-test
//
//  Created by wupeng on 2019/11/11.
//

#import "Person.h"

@implementation Person
- (void)run
{
    NSLog(@"Person - run");
}

- (void)dealloc{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

@end
