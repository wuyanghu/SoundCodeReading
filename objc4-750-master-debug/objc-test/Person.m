//
//  Person.m
//  objc-test
//
//  Created by wupeng on 2019/11/11.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person
- (void)run
{
    NSLog(@"Person - run");
}

- (void)dealloc{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

/*
 问题:self.class与self在实例方法和类方法中有什么区别?
 结论:在实例方法中,self指的是当前的实例对象,self.class指的是当前的类对象.self.class是通过当前实例对象的isa指针找到当前的类对象。
     在类方法中,self与self.class都是当前的类对象,self.class多调用了一次+ (Class)class,返回的是当前类对象本身的self
 */

//- (void)walkInstance {
//    NSLog(@"%s", __func__);
//    /*
//     1.self.class:此时self是一个实例对象,self.class会通过实例的对象的isa查找对应的class类对象
//     2.self.class walkClass 调用类对象的方法
//     */
//    [self.class walkClass];
//}

- (void)addDynamicWalkInstance{
    NSLog(@"addDynamicWalkInstance");
}

+ (void)walkClass{
    NSLog(@"%s", __func__);
    /*
     1.此时的self已经是一个class类对象,self.class返回的是类对象本身的self
     2.self.class与self是一个类对象,self.class相当于多了一次方法调用
     */
    [self.class walkClass2];
    [self walkClass2];
    [Person walkClass2];
}

+ (void)walkClass2{
    NSLog(@"%s", __func__);
}

//动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%s", __func__);
    if (sel == @selector(walkInstance)) {
        Method runMethod = class_getInstanceMethod(self, @selector(addDynamicWalkInstance));//方法的二分查找
        IMP runIMP = method_getImplementation(runMethod);
        const char* types = method_getTypeEncoding(runMethod);
        NSLog(@"%s", types);
        return class_addMethod(self, sel, runIMP, types);
    }
    
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    
    if (sel == @selector(walkClass3)) {
        Method runMethod = class_getClassMethod(self, @selector(walkClass));
        IMP runIMP = method_getImplementation(runMethod);
        const char* types = method_getTypeEncoding(runMethod);
        NSLog(@"%s", types);
        return class_addMethod(object_getClass(self), sel, runIMP, types);//类的isa指针?
    }
    return [super resolveClassMethod:sel];
}

@end
