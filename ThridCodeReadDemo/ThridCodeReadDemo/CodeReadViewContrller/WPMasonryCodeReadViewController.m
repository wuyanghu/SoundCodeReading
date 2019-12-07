//
//  MasonryCodeReadViewController.m
//  ThridCodeReadDemo
//
//  Created by wupeng on 2019/12/7.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import "WPMasonryCodeReadViewController.h"
#import "Masonry.h"
#import "WPBaseHeader.h"

@interface WPMasonryCodeReadViewController ()

@end

@implementation WPMasonryCodeReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView * bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(100);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(@(100));
    }];
    
}

#pragma mark - NSArray+MASAdditions

//分开执行mas_makeConstraints
- (void)arrayViewMasonry{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIView * view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view2];
    
    [@[view,view2] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo(ScreenWidth-20);
        make.height.mas_equalTo(200);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_bottom).offset(10);
    }];
}

#pragma mark - View+MASAdditions

- (void)viewSplitMasonry{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo(ScreenWidth-20);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

- (void)viewMasonry{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo(ScreenWidth-20);
        make.top.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
        
    }];
    
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(100);
        make.width.mas_equalTo(20);
    }];
}

//错误写法2
- (void)error2{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10).width.mas_equalTo(ScreenWidth-20);
        make.width.mas_equalTo(ScreenWidth-20);
        make.top.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}
//错误写法1
- (void)error1{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.width.mas_equalTo(ScreenWidth-20);
        make.top.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

@end
