//
//  Person+Test.h
//  objc-test
//
//  Created by wupeng on 2019/11/11.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (Test)
- (void)test;
+ (void)abc;
@property (assign, nonatomic) int age;
- (void)setAge:(int)age;
- (int)age;
@end

NS_ASSUME_NONNULL_END
