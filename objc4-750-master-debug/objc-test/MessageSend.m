//
//  MessageSend.m
//  objc-test
//
//  Created by wupeng on 2019/12/12.
//

#import "MessageSend.h"

@implementation BaseMessageSend

- (void)baseMessage{
    NSLog(@"基类消息发送");
}

@end

@implementation MessageSend

- (void)message{
    NSLog(@"消息发送");
}

@end
