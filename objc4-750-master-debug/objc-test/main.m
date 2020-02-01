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

void methodInit(void);//方法初始化
void printMethodNamesOfClass(Class cls);//打印类的所有分类
void associated(void);//关联对象
void weak(void);//weak
void messageSend(void);//消息发送
void strong(void);//strong源码分析

__weak NSString *weak_String;
__weak NSString *weak_StringAutorelease;
__weak NSArray * weak_arrayAutorelease;
void createString(void);//autoreleasepool
void autoreleasePool(void);

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        methodInit();
//        printMethodNamesOfClass([Person class]);
        associated();
        strong();
        weak();
        messageSend();
        
        autoreleasePool();
    }

    NSLog(@"------in the main()------");
    NSLog(@"%@", weak_String);
    NSLog(@"%@", weak_StringAutorelease);
    return 0;
}


void autoreleasePool(void){
    createString();
    NSLog(@"------超出作用区域------");
    NSLog(@"%@", weak_String);//alloc对象已经释放
    NSLog(@"%@\n\n", weak_StringAutorelease);//autorelease对象还存在
    NSLog(@"%@",weak_arrayAutorelease);
}

void createString(void) {
    
    NSString *string = [[NSString alloc] initWithFormat:@"Hello, World!"];    // 创建常规对象
    NSString *stringAutorelease = [NSString stringWithFormat:@"Hello, World! Autorelease"]; // 创建autorelease对象
    NSArray * arrayAutorelease = [NSArray arrayWithObject:@"1"];
    weak_String = string;
    weak_StringAutorelease = stringAutorelease;
    weak_arrayAutorelease = arrayAutorelease;
}

void methodInit(){
    Person * person = [[Person alloc] init];
    Person * person2 = [Person new];//[callAlloc(self, false/*checkNil*/) init] 与上面等价
    Person * person3 = [Person alloc];
    Person * person4 = [person3 init];
}

//消息发送
void messageSend(){
    [Student new];//子类与父类关系调用
    //消息发送
    MessageSend * send = [MessageSend new];
    [send message];
    [send message];
    [send baseMessage];
    
    Person * person = [[Person alloc] init];
    
    [person instanceMethodSelf];//实例方法中self代表什么
    [Person classMethodSelf];//类方法中self代表什么
    
    [person performSelector:@selector(run)];
    [person testExchangeInstanceMethod];//实例方法交换
    [Person testExchangeClassMethod];//静态方法交换
    
    [person addDynamicInstanceMethod];//动态添加实例方法
    [Person addDynamicClassMethod];//动态添加类方法
    
    Class metaClass = objc_getMetaClass("Person");//可以获取元类
    [Person classSendMessage];//验证类对象发送消息是通过isa找到元类
    [person instanceSendMessage];//验证实例对象发送消息是通过isa找到类
    
    [Person testExchangeClassMethod2];
    [person forwardingTargetMethod];//二次消息转发
    [person forwardInvocation];//三次处理
}

//strong源码分析
void strong(){
    Person * person = [[Person alloc] init];
    //指针地址指向指针
    Person *weakPerson = person;//相当于调了retain方法
//    NSLog(@"person指针:%p\nweakPerson指针:%p",person,weakPerson);
//    NSLog(@"person指针地址:%p\nweakPerson指针地址:%p",&person,&weakPerson);
}


//weak源码分析
void weak(){
    Person * person = [[Person alloc] init];

    //指针地址指向指针
    __weak Person *weakPerson = person;
    __weak Person *weakPerson2 = person;
    NSLog(@"person指针:%p\nweakPerson指针:%p",person,weakPerson);
    NSLog(@"person指针地址:%p\nweakPerson指针地址:%p",&person,&weakPerson);
}

//关联对象源码分析
void associated(){
    Person * obj = [[Person alloc] init];
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
