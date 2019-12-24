//
//  Person.m
//  objc-test
//
//  Created by wupeng on 2019/11/11.
//

#import "Person.h"
#import <objc/runtime.h>
#import "MessageSend.h"
@implementation Person

#pragma mark - 对象释放

- (void)dealloc{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

#pragma mark - 验证实例方法和类方法中self的区别

/*
 问题:self.class与self在实例方法和类方法中有什么区别?
 结论:在实例方法中,self指的是当前的实例对象,self.class指的是当前的类对象.self.class是通过当前实例对象的isa指针找到当前的类对象。
     在类方法中,self与self.class都是当前的类对象,self.class多调用了一次+ (Class)class,返回的是当前类对象本身的self
 */

- (void)instanceMethodSelf {
    NSLog(@"%s", __func__);
    /*
     1.self.class:此时self是一个实例对象,self.class会通过实例的对象的isa查找对应的class类对象
     2.self.class walkClass 调用类对象的方法
     */
    [self.class classMethodSelf2];
}

+ (void)classMethodSelf{
    NSLog(@"%s", __func__);
    /*
     1.此时的self已经是一个class类对象,self.class返回的是类对象本身的self
     2.self.class与self是一个类对象,self.class相当于多了一次方法调用
     */
    [self.class classMethodSelf2];
    [self classMethodSelf2];
    [Person classMethodSelf2];
}

+ (void)classMethodSelf2{
    NSLog(@"%s", __func__);
}

#pragma mark - 消息发送验证:实例是通过isa找到类对象，类对象通过isa找到元类对象

- (void)instanceSendMessage{
    NSLog(@"实例对象发送消息");
}

+ (void)classSendMessage{
    NSLog(@"类对象发送消息");
}

#pragma mark - 二次消息转发

-(id)forwardingTargetForSelector:(SEL)aSelector{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"forwardingTargetMethod"]) {
        return [MessageSend new];
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (id)forwardingTarget{
    return [Person new];
}

#pragma mark - 动态添加方法

//动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(addDynamicInstanceMethod)) {
        Method addMethod = class_getInstanceMethod(self, @selector(addDynamicInstanceMethodAfter));//方法的二分查找,self当前类对象
        IMP runIMP = method_getImplementation(addMethod);
        const char* types = method_getTypeEncoding(addMethod);
        NSLog(@"%s", types);
        return class_addMethod(self, sel, runIMP, types);
    }
    
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    
    if (sel == @selector(addDynamicClassMethod)) {
        Method runMethod = class_getClassMethod(self, @selector(addDynamicClassMethodAfter));
        IMP runIMP = method_getImplementation(runMethod);
        const char* types = method_getTypeEncoding(runMethod);
        NSLog(@"%s", types);
        return class_addMethod(object_getClass(self), sel, runIMP, types);//类的isa指针?
    }
    return [super resolveClassMethod:sel];
}

- (void)addDynamicInstanceMethodAfter{
    NSLog(@"动态添加实例方法");
}

+ (void)addDynamicClassMethodAfter{
    NSLog(@"动态添加类方法");
}

#pragma mark - 方法交换
//方法交换
+ (void)load{
    //self是类对象，testExchangeInstanceMethod是实例方法，查询实例方法需要在类方法中查询，即可直接在类对象中查询
    Method instanceMethod = class_getInstanceMethod(self, @selector(testExchangeInstanceMethod));
    Method instanceMethodAfter = class_getInstanceMethod(self, @selector(testExchangeInstanceMethodAfter));
    method_exchangeImplementations(instanceMethod, instanceMethodAfter);
    
    //self是类对象,testExchangeClassMethod是类方法，查询类方法需要在元类中查询，该方法多了层cls->getMeta()
    Method classMethod = class_getClassMethod(self, @selector(testExchangeClassMethod));
    Method classMethodAfter = class_getClassMethod(self, @selector(testExchangeClassMethodAfter));
    method_exchangeImplementations(classMethod, classMethodAfter);
//    method_exchangeImplementations(classMethod, classMethodAfter);二次交换测试
}

- (void)testExchangeInstanceMethod{
    NSLog(@"实例方法交换前");
}

- (void)testExchangeInstanceMethodAfter{
    NSLog(@"实例方法交换后");
}

+ (void)testExchangeClassMethod{
    NSLog(@"类方法交换前");
}

+ (void)testExchangeClassMethodAfter{
    NSLog(@"类方法交换后");
}

@end
