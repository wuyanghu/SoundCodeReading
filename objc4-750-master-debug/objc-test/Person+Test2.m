//
//  Person+Test2.m
//  objc-test
//
//  Created by wupeng on 2019/11/11.
//

#import "Person+Test2.h"

@implementation Person (Test2)

+ (void)load{
    NSLog(@"test2 load");
}

- (void)run
{
    NSLog(@"Person (Test2) - run");
}
@end
