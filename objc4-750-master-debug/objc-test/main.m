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
#import "MessageSend.h"
#import "Student.h"

void printMethodNamesOfClass(Class cls);//打印类的所有分类
void associated(Person * obj);//关联对象
void weak(Person *person);//weak
void messageSend(void);//消息发送
void strong(Person *person);//strong源码分析

int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        Class newClass = objc_allocateClassPair(objc_getClass("NSObject"), "newClass", 0);
//                objc_registerClassPair(newClass);
//        id newObject = [[newClass alloc]init];
//        NSLog(@"%@",newObject);
        
//        Person * person = [[Person alloc] init];
//        Person * person2 = [Person new];//[callAlloc(self, false/*checkNil*/) init] 与上面等价
//        Person * person2 = [Person alloc];
//        person2 = [person2 init];
//        [person test];
//        [person test];
//        
//        printMethodNamesOfClass([Person class]);
//        associated(person);
//
//        strong(person);
//        weak(person);
        
        messageSend();
        
//        [Student new];
    }
    return 0;
}
//消息发送
void messageSend(){
    MessageSend * send = [MessageSend new];
    [send message];
    [send message];
    [send baseMessage];
    
//    [[Person new] run];
//    [[Person new] walkInstance];//消息转发
//    [Person walkClass];
    [Person walkClass3];
}

//strong源码分析
void strong(Person *person){
    //指针地址指向指针
    Person *weakPerson = person;//相当于调了retain方法
    NSLog(@"person指针:%p\nweakPerson指针:%p",person,weakPerson);
    NSLog(@"person指针地址:%p\nweakPerson指针地址:%p",&person,&weakPerson);
}


//weak源码分析
void weak(Person *person){
    //指针地址指向指针
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
