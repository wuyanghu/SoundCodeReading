//
//  ParseVCJsonAPI.h
//  WPBase
//
//  Created by wupeng on 2019/11/17.
//

#import <Foundation/Foundation.h>
@class BaseSectionsModel;
NS_ASSUME_NONNULL_BEGIN

@interface ParseVCJsonAPI : NSObject
+ (BaseSectionsModel *)parseServerJsonToBaseSetcionModel:(NSDictionary *)jsonDict;
+ (BaseSectionsModel *)parseLocalJsonToBaseSetcionModel:(NSDictionary *)configDict;
@end

NS_ASSUME_NONNULL_END

