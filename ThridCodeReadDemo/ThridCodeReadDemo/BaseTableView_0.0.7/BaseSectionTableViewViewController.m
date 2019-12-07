//
//  BaseSectionTableViewViewController.m
//  DataStructureDemo
//
//  Created by wupeng on 2019/9/18.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "BaseSectionTableViewViewController.h"
#import "NSObject+AddParams.h"
#import "UITableViewCell+BaseCategory.h"
#import "UITableViewHeaderFooterView+WPBaseCategory.h"
#import "BaseSectionCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "BaseSectionModel.h"
#import "ParseVCJsonAPI.h"
#import "NSObject+Json.h"
#import "WPBaseHeader.h"
#import "WPTableViewPlaceHolderView.h"
#import "UITableView+Placeholder.h"
#import "CMPhotoBrowserViewController.h"
#import "WPBaseHeaderFooterView.h"
#import "MJRefresh.h"

@interface BaseSectionTableViewViewController ()

@end

@implementation BaseSectionTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vcJsonChanged) name:kVCJsonChangedNotification object:nil];
    [self requestDetailInfo:NO];
}

- (void)addSubView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    
    __weak typeof(self) _self = self;
    WPTableViewPlaceHolderView * placeHolderView = [[WPTableViewPlaceHolderView alloc] initWithFrame:self.view.frame refreshBlock:^{
        __strong typeof(_self) self = _self;
        [self requestDetailInfo:NO];
    }];
    [self.tableView setPlaceHolderView:placeHolderView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        __strong typeof(_self) self = _self;
        [self requestDetailInfo:YES];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 通知

- (void)vcJsonChanged{
    [self requestDetailInfo:NO];
}

#pragma mark - request

- (void)requestDetailInfo:(BOOL)isRefresh{
    id json = [self readJsonWithName:NSStringFromClass([self class])];
    self.sectionsModel =  [ParseVCJsonAPI parseLocalJsonToBaseSetcionModel:json];
    [self.tableView reloadData];
}

#pragma mark - 浏览图片

- (void)photoBrowser:(NSArray *)imageArray{
    CMPhotoBrowserViewController *photoVC = [[CMPhotoBrowserViewController alloc]init];
    photoVC.imageArray = imageArray;
    photoVC.indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    CMPhotoBrowserAnimator * animator = [[CMPhotoBrowserAnimator alloc] init];
    animator.index = 0;
    animator.animationDismissDelegate = photoVC;
    animator.animationPresentDelegate = self;
    photoVC.transitioningDelegate = animator;
    photoVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:photoVC animated:YES completion:nil];
}

#pragma mark - configcell

- (void)configureHeaderFooterView:(UITableViewHeaderFooterView *)view section:(NSInteger)section{
    if ([view isKindOfClass:[WPBaseHeaderFooterView class]]) {
        WPBaseHeaderFooterView * headerView = (WPBaseHeaderFooterView *)view;
        headerView.sectionModel = self.sectionsModel.contentArray[section];

        __weak typeof(self) _self = self;
        headerView.block = ^{

            __strong typeof(_self) self = _self;
            NSMutableArray *indexPaths = [NSMutableArray array];
            
            BaseSectionModel * sectionModel = self.sectionsModel.contentArray[section];
            for (int i = 0;i<sectionModel.rowArray.count;i++) {
                [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:section]];
            }
            if (sectionModel.expend) {
                [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            }
        };
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[BaseSectionCell class]]) {
        __weak typeof(self) _self = self;
        BaseSectionCell * sectionCell = (BaseSectionCell *)cell;
        sectionCell.sectionContentModel = [self.sectionsModel getContentModelWithIndexPath:indexPath];
        sectionCell.callBlock = ^(NSArray * imageArray) {
            __strong typeof(_self) self = _self;
            [self photoBrowser:imageArray];
        };
    }
}

#pragma mark - tableView

#pragma mark header
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WPBaseHeaderFooterView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WPBaseHeaderFooterView.cellIdentifier];
    [self configureHeaderFooterView:headerView section:section];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [tableView fd_heightForHeaderFooterViewWithIdentifier:WPBaseHeaderFooterView.cellIdentifier configuration:^(id headerFooterView) {
        [self configureHeaderFooterView:headerFooterView section:section];
    }];
}

#pragma mark content

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:BaseSectionCell.cellIdentifier cacheByIndexPath:indexPath configuration:^(UITableViewCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BaseSectionModel * sectionModel = self.sectionsModel.contentArray[section];
    if (sectionModel.expend) {
        return 0;
    }
    return sectionModel.rowArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionsModel.contentArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BaseSectionCell.cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseRowModel * contentModel = [self.sectionsModel getContentModelWithIndexPath:indexPath];
    NSString * className = contentModel.classname;
    NSString * storyBoardName = contentModel.storyboardname;
    
    id objClass = nil;
    if (storyBoardName && storyBoardName.length>0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:[NSBundle mainBundle]];
        objClass = [storyboard instantiateViewControllerWithIdentifier:className];
    }else{
        objClass = [NSClassFromString(className) new];
    }
    if (!objClass) {//对象是空直接return
        return;
    }
    
    if (contentModel.params) {
        [objClass setParams:contentModel.params];
    }
    
    if (!contentModel.method || contentModel.method.length == 0) {//没有指定方法，如果是viewController默认调push方法
        if ([objClass isKindOfClass:[UIViewController class]]) {
            [self.navigationController pushViewController:objClass animated:YES];
        }
    }else{
        SEL selector = NSSelectorFromString(contentModel.method);
        if ([objClass respondsToSelector:selector]) {
            [objClass performSelector:selector withObject:contentModel.params];
        }
    }
    
}

#pragma mark - getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [BaseSectionCell registerClassWithTableView:_tableView];
        [WPBaseHeaderFooterView registerHeaderFooterClassWithTableView:_tableView];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end



