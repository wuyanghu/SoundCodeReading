//
//  NSObject+AddParams.h
//  WPBase
//
//  Created by ruantong on 2019/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (AddParams)
@property (nonatomic,strong) NSDictionary * params;
- (void)removeParams;
@end

NS_ASSUME_NONNULL_END
