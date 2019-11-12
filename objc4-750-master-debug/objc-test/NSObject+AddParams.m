//
//  NSObject+AddParams.m
//  WPBase
//
//  Created by ruantong on 2019/9/24.
//

#import "NSObject+AddParams.h"
#import <objc/runtime.h>

@implementation NSObject (AddParams)

- (void)setParams:(NSDictionary *)params {
    objc_setAssociatedObject(self, @"params", params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)params {
    return objc_getAssociatedObject(self, @"params");
}

//不需要手动释放，在dealloc时会根据标志位手动释放关联对象
- (void)removeParams{
    objc_removeAssociatedObjects(self);
}

@end
