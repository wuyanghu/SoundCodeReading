//
//  UnknownModel2.m
//  objc-test
//
//  Created by wupeng on 2019/12/24.
//

#import "MethodSignature.h"

@implementation MethodSignature

- (void)forwardInvocation{
    NSLog(@"多次转发");
}

@end
