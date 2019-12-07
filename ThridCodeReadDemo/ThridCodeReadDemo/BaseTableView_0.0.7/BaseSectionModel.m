//
//  BaseSectionModel.m
//  WPBase
//
//  Created by wupeng on 2019/11/11.
//

#import "BaseSectionModel.h"
#import "WPCommonMacros.h"

@implementation BaseSectionsModel

- (NSMutableArray<BaseSectionModel *> *)contentArray{
    if (!_contentArray) {
        _contentArray = [[NSMutableArray alloc] init];
    }
    return _contentArray;
}

- (NSString *)getTitleWithSection:(NSInteger)section{
    if (section<self.contentArray.count) {
        BaseSectionModel * sectionModel = self.contentArray[section];
        return sectionModel.sectionTitle;
    }
    return nil;
}

- (BaseRowModel *)getContentModelWithIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section>= self.contentArray.count) {
        return nil;
    }
    BaseSectionModel * sectionModel = self.contentArray[indexPath.section];
    if (indexPath.row >= sectionModel.rowArray.count) {
        return nil;
    }
    BaseRowModel * contentModel = sectionModel.rowArray[indexPath.row];
    return contentModel;
}

@end

@implementation BaseSectionModel

- (NSMutableArray<BaseRowModel *> *)rowArray{
    if (!_rowArray) {
        _rowArray = [[NSMutableArray alloc] init];
    }
    return _rowArray;
}

@end

@implementation BaseRowModel

- (BaseRowImageModel *)imageModel{
    if (!_imageModel) {
        _imageModel = [BaseRowImageModel new];
    }
    return _imageModel;
}

- (NSMutableDictionary *)params{
    if (!_params) {
        _params = [[NSMutableDictionary alloc] init];
    }
    return _params;
}

@end

@implementation BaseRowImageModel

- (CGSize)getImageSize{
    if (!_url) {
        return CGSizeZero;
    }
    CGFloat screenScale = [UIScreen mainScreen].scale;
    CGFloat imageMaxWidth = ScreenWidth-16*2;
    
    CGFloat width = [_width floatValue]/screenScale;
    CGFloat height = [_height floatValue]/screenScale;
    
    if (width<imageMaxWidth) {
        return CGSizeMake(width, height);
    }else{
        CGFloat scale = (imageMaxWidth)/width;
        return CGSizeMake(imageMaxWidth, height * scale);
    }
    
}

@end


