//
//  BrowsePhotoArray.m
//  DataStructureDemoTests
//
//  Created by wupeng on 2019/12/13.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BrowsePhotoArray : XCTestCase

@end

@implementation BrowsePhotoArray

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testArrayCount1Index0{
    NSArray * array = @[@(1)];
    [self indexprePostArrayWithArray:array index:0];
}

- (void)testArrayCount2Index0{
    NSArray * array = @[@(1),@(2)];
    [self indexprePostArrayWithArray:array index:0];
}

- (void)testArrayCount2Index1{
    NSArray * array = @[@(1),@(2)];
    [self indexprePostArrayWithArray:array index:1];
}

- (void)testArrayCount3Index0{
    NSArray * array = @[@(1),@(2),@(3)];
    [self indexprePostArrayWithArray:array index:0];
}

- (void)testArrayCount3Index1{
    NSArray * array = @[@(1),@(2),@(3)];
    [self indexprePostArrayWithArray:array index:1];
}

- (void)testArrayCount3Index2{
    NSArray * array = @[@(1),@(2),@(3)];
    [self indexprePostArrayWithArray:array index:2];
}

/*
 返回index前后narray
 怎么浏览三张,当前这张在中间;保证数组前后不能越界?
 如果是在第0个位置,数量够时,取0,1,2;如果是最后一个位置,取最后一个位置
 扩展:如果是4张，5张呢?算法的扩展性
 */
- (void)indexprePostArrayWithArray:(NSArray *)array index:(NSInteger)index{
    NSAssert(index>=0 && index<array.count, @"index应在数组范围内");
    NSInteger beign = index-1;
    NSInteger end = index+1;
    
    NSMutableArray * resultArray = [NSMutableArray arrayWithCapacity:3];
    
    if (beign<0) {
        end = end-beign;//减去负值
        beign = 0;
        if (end >= array.count) {
            end = array.count - 1;
        }
    }else if(end>=array.count){
        NSInteger absolute = end-(array.count-1);
        beign = beign-absolute;
        end = array.count-1;
        if (beign<0) {
            beign = 0;
        }
    }
    
    NSAssert(beign>=0, @"begin不会小于0");
    NSAssert(end<array.count, @"end不能大于等于count");
    
    for (NSInteger i = beign; i<=end; i++) {
        [resultArray addObject:array[i]];
    }
    if (array.count>=3) {
        NSAssert(resultArray.count == 3, @"应该有3个");
    }else{
        NSAssert(resultArray.count == array.count, @"与数组个数相等");
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
