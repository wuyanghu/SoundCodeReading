//
//  BaseSectionTableViewViewController.h
//  DataStructureDemo
//
//  Created by wupeng on 2019/9/18.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseSectionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseSectionTableViewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BaseSectionsModel * sectionsModel;
@end

NS_ASSUME_NONNULL_END
