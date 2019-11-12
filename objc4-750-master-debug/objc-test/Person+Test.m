//
//  Person+Test.m
//  objc-test
//
//  Created by wupeng on 2019/11/11.
//

#import "Person+Test.h"

@implementation Person (Test)
- (void)test
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

+ (void)abc
{
}
- (void)setAge:(int)age
{
}
- (int)age
{
    return 10;
}
@end
