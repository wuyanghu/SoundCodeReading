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

- (void)walkInstance {
    NSLog(@"%s", __func__);
}

+ (void)walkClass{
    NSLog(@"%s", __func__);
}

//动态方法解析
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%s", __func__);
    if (sel == @selector(walkInstance)) {
        Method runMethod = class_getInstanceMethod(self, @selector(walkInstance));
        IMP runIMP = method_getImplementation(runMethod);
        const char* types = method_getTypeEncoding(runMethod);
        NSLog(@"%s", types);
        return class_addMethod(self, sel, runIMP, types);
    }
    
    return [super resolveInstanceMethod:sel];
}

+ (BOOL)resolveClassMethod:(SEL)sel {
    
    if (sel == @selector(walkClass)) {
        Method runMethod = class_getClassMethod(self, @selector(walkClass));
        IMP runIMP = method_getImplementation(runMethod);
        const char* types = method_getTypeEncoding(runMethod);
        NSLog(@"%s", types);
        return class_addMethod(object_getClass(self), sel, runIMP, types);
    }
    return [super resolveClassMethod:sel];
}

@end
