//
//  MessageSend.h
//  objc-test
//
//  Created by wupeng on 2019/12/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseMessageSend : NSObject
- (void)baseMessage;
@end

@interface MessageSend : BaseMessageSend
- (void)message;
@end

NS_ASSUME_NONNULL_END
