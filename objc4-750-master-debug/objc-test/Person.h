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

#pragma mark - 验证实例方法和类方法中self的区别
- (void)instanceMethodSelf;
+ (void)classMethodSelf;
#pragma mark - 消息发送验证:实例是通过isa找到类对象，类对象通过isa找到元类对象
- (void)instanceSendMessage;
+ (void)classSendMessage;
#pragma mark - 动态添加方法
- (void)addDynamicInstanceMethod;
+ (void)addDynamicClassMethod;
#pragma mark - 方法交换测试
- (void)testExchangeMethod;
+ (void)testExchangeMethod;
@end

NS_ASSUME_NONNULL_END
