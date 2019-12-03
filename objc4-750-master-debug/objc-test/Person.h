//
//  Person.h
//  objc-test
//
//  Created by wupeng on 2019/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
{
    int _age;
}
- (void)run;

- (void)walkInstance;
+ (void)walkClass;
@end

NS_ASSUME_NONNULL_END
