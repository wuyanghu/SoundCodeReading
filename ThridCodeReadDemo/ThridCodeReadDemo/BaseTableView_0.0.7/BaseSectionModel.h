//
//  BaseSectionModel.h
//  WPBase
//
//  Created by wupeng on 2019/11/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class BaseRowModel;
@class BaseRowImageModel;
@class BaseSectionModel;
NS_ASSUME_NONNULL_BEGIN

@interface BaseSectionsModel : NSObject
@property (nonatomic,copy) NSString * className;
@property (nonatomic,strong) NSMutableArray<BaseSectionModel *> * contentArray;
- (BaseRowModel *)getContentModelWithIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getTitleWithSection:(NSInteger)section;
@end

@interface BaseSectionModel : NSObject
@property (nonatomic,strong) NSString * sectionTitle;
@property (nonatomic,assign) BOOL expend;//展开与缩放
@property (nonatomic,strong) NSMutableArray<BaseRowModel *> * rowArray;
@end

@interface BaseRowModel : NSObject
@property (nonatomic,copy) NSString * title;
@property (nonatomic,copy) NSString * desc;
@property (nonatomic,strong) BaseRowImageModel * imageModel;

@property (nonatomic,copy) NSString * classname;
@property (nonatomic,copy) NSString * storyboardname;
@property (nonatomic,copy) NSString * method;
@property (nonatomic,strong) NSMutableDictionary * params;
@end

@interface BaseRowImageModel : NSObject
@property (nonatomic,copy) NSString * url;
@property (nonatomic,copy) NSString * width;
@property (nonatomic,copy) NSString * height;
- (CGSize)getImageSize;
@end

NS_ASSUME_NONNULL_END


