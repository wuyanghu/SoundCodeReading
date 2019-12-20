//
//  Student.m
//  objc-test
//
//  Created by wupeng on 2019/12/20.
//

#import "Student.h"

@implementation Student

- (instancetype)init{
    self = [super init];
    if (self) {
        /*
         [self class]与[super class]输出结果，这是一个继承关系，子类优先级最高，而非objc_sendMsg第一个接受者是self
         - (Class)class {
         return object_getClass(self);
         }
         */
        
        NSLog(@"%@",NSStringFromClass([self class]));//self.class调用了实例对象的isa指针，返回的是类对象
        NSLog(@"%@",NSStringFromClass([super class]));//super.class在子类有同样方法实现时，会调用子类方法，除非子类方法中实现[super method],否则不会调用父类的方法
    }
    return self;
}

@end
