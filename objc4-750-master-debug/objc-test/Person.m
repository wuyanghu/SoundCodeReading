//
//  Person.m
//  objc-test
//
//  Created by wupeng on 2019/11/11.
//

#import "Person.h"
#import <objc/runtime.h>
#import "MessageSend.h"
#import "MethodSignature.h"

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

#pragma mark - 标准消息转发
//3.最后一步，返回方法签名
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSLog(@"3---%@",NSStringFromSelector(aSelector));
    NSLog(@"3---%@",NSStringFromSelector(_cmd));
    if ([NSStringFromSelector(aSelector) isEqualToString:@"forwardInvocation"]) {
        return [[MethodSignature new] methodSignatureForSelector:aSelector];
    }
    return [super methodSignatureForSelector:aSelector];
}
//3.1处理返回的方法签名
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    if ([NSStringFromSelector(anInvocation.selector) isEqualToString:@"forwardInvocation"]) {
        [anInvocation invokeWithTarget:[MethodSignature new]];
    }else{
        [super forwardInvocation:anInvocation];
    }
}
//触发崩溃
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"还不处理就崩溃了");
}

#pragma mark - 快速消息转发
//给其他对象执行
-(id)forwardingTargetForSelector:(SEL)aSelector{
    if ([NSStringFromSelector(aSelector) isEqualToString:@"forwardingTargetMethod"]) {
        return [MessageSend new];//返回的对象必须实现forwardingTargetMethod
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - 动态添加方法

//动态方法解析;当前类添加方法
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
    [self exchangeMethod];
    [self exchangeMethod2];
}

#pragma mark 第二种写法
+ (void)exchangeMethod2{
    
    Class class = object_getClass((id)self);//元类
    
    SEL originalSelector = @selector(testExchangeClassMethod2);
    SEL swizzledSelector = @selector(testExchangeClassMethodAfter2);

    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    
    //class_addMethod:查询originalSelector是否存在
    //存在为NO;不存在为YES,并且会当前类动态添加originalSelector
    //后两个参数没有用到
    BOOL isAddOriginalMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    //class_addMethod为类添加了未实现的方法，但是originalMethod仍然是空
    //重新获取就有值
    Method originalMethod1 = class_getClassMethod(self, originalSelector);

    if (isAddOriginalMethod) {
        //动态添加originalMethod,并把imp指针赋值给swizzledSelector达到交换
        //直接替换也没有毛病
        //相当于调用了class_addMethod方法，会检测swizzledSelector是否存在
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        //如果originalMethod未实现，可以重新获取originalMethod1
        method_exchangeImplementations(originalMethod1, swizzledMethod);//有一个方法为空，不会交换
//        method_exchangeImplementations(originalMethod, swizzledMethod);//有一个方法为空，不会交换
    }
    
    
    /*
     总结:
     1.如果两个方法都明确确定存在,使用method_exchangeImplementations即可
     2.如果原方法不确定是否存在，可用class_addMethod判断
     3.如果交换后的方法不确定是否存在，可用class_replaceMethod
     4.如果原方法与交换后的方法都不确定是否存在，可用class_addMethod与
     class_replaceMethod结合，不过这种应用场景不明确。
     */
    
}

//+ (void)testExchangeClassMethod2{
//    NSLog(@"类方法交换前2");
//}

+ (void)testExchangeClassMethodAfter2{
    NSLog(@"类方法交换后2");
}

#pragma mark 第一种写法
+ (void)exchangeMethod{
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
