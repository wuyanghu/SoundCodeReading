//
//  main.m
//  objc-test
//
//  Created by GongCF on 2018/12/16.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"
#import "Person+Test.h"
#import "Person+Test2.h"
#import "NSObject+AddParams.h"

void printMethodNamesOfClass(Class cls);//打印类的所有分类
void associated(Person * obj);//关联对象
void weak(Person *person);//weak

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        Class newClass = objc_allocateClassPair(objc_getClass("NSObject"), "newClass", 0);
                objc_registerClassPair(newClass);
        id newObject = [[newClass alloc]init];
        NSLog(@"%@",newObject);
        
        Person * person = [[Person alloc] init];
        [person test];
        
        printMethodNamesOfClass([Person class]);
        associated(person);
        
        weak(person);
        
    }
    return 0;
}
//weak源码分析
void weak(Person *person){
    __weak Person *weakPerson = person;
    __weak Person *weakPerson2 = person;
    NSLog(@"person指针:%p\nweakPerson指针:%p",person,weakPerson);
    NSLog(@"person指针地址:%p\nweakPerson指针地址:%p",&person,&weakPerson);
}

//关联对象源码分析
void associated(Person * obj){
    [obj setParams:@{@"key1":@"value1"}];//第一次关联对象
    [obj setParams:@{@"key2":@"valu2"}];//第二次关联对象
    
    [obj params];//获取关联对象
    
    [obj setParams:nil];//释放关联对象
    [obj setParams:@{@"key3":@"valu3"}];//验证关联对象是否释放
    
    [obj removeParams];//释放关联对象
    [obj setParams:@{@"key4":@"valu4"}];//验证关联对象是否释放
}

//打印类的所有分类
void printMethodNamesOfClass(Class cls){
    unsigned int count;
    // 获得方法数组
    Method *methodList = class_copyMethodList(cls, &count);
    // 存储方法名
    NSMutableString *methodNames = [NSMutableString string];
    // 遍历所有的方法
    for (int i = 0; i < count; i++) {
        // 获得方法
        Method method = methodList[i];
        // 获得方法名
        NSString *methodName = NSStringFromSelector(method_getName(method));
        // 拼接方法名
        [methodNames appendString:methodName];
        [methodNames appendString:@", "];
    }
    // 释放
    free(methodList);
    // 打印方法名
    NSLog(@"%@ - %@", cls, methodNames);
}
