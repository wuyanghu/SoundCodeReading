//
//  BaseSectionCell.h
//  WPBase
//
//  Created by wupeng on 2019/11/10.
//

#import <UIKit/UIKit.h>
#import "UITableView+FDTemplateLayoutCell.h"

NS_ASSUME_NONNULL_BEGIN
@class BaseRowModel;

typedef void(^BaseSectionCellBlock)(NSArray *);

@interface BaseSectionCell : UITableViewCell
@property (nonatomic,strong) UILabel * titleLabel;
@property (strong, nonatomic) UILabel * contentLabel;
@property (nonatomic,strong) UIImageView * contentImageView;

@property (nonatomic,strong) BaseRowModel * sectionContentModel;
@property (nonatomic,copy) BaseSectionCellBlock callBlock;
@end

NS_ASSUME_NONNULL_END
