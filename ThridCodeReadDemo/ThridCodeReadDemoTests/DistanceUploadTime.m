//
//  DistanceUploadTime.m
//  ThridCodeReadDemoTests
//
//  Created by wupeng on 2019/12/14.
//  Copyright © 2019 wupeng. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DistanceUploadTime : XCTestCase

@end

@implementation DistanceUploadTime

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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    //    [self measureBlock:^{
    //        // Put the code you want to measure the time of here.
    //    }];
}

- (void)test59SecondsAgo{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2019-12-14 10:59:01"];
    NSAssert([timeString isEqualToString:@"59秒前"], @"");
}

- (void)test1MinutesAgo{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2019-12-14 10:59:00"];
    NSAssert([timeString isEqualToString:@"1分钟前"], @"");
}

- (void)test24MinutesAgo{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2019-12-14 10:36:00"];
    NSAssert([timeString isEqualToString:@"24分钟前"], @"");
}

- (void)test1HoursAgo{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2019-12-14 09:36:00"];
    NSAssert([timeString isEqualToString:@"1小时前"], @"");
}

- (void)test1DayAgo{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2019-12-13 09:36:00"];
    NSAssert([timeString isEqualToString:@"1天前"], @"");
}

//整一天前,边界
- (void)test1DayAgo2{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2019-12-13 11:00:00"];
    NSAssert([timeString isEqualToString:@"1天前"], @"");
}

//整一月前,边界
- (void)test1MonthAgo{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2019-11-14 11:00:00"];
    NSAssert([timeString isEqualToString:@"1月前"], @"");
}

- (void)test1MonthAgo2{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2019-11-13 11:00:00"];
    NSAssert([timeString isEqualToString:@"1月前"], @"");
}

- (void)test3MonthAgo{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2019-09-13 11:00:00"];
    NSAssert([timeString isEqualToString:@"3月前"], @"");
}

//整一年前,边界
- (void)test1YearsAgo{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2018-11-14 11:00:00"];
    NSAssert([timeString isEqualToString:@"1年前"], @"");
}

- (void)test1YearsAgo2{
    NSString * timeString = [self distanceUpLoadTimeWith:@"2018-11-13 11:00:00"];
    NSAssert([timeString isEqualToString:@"1年前"], @"");
}

- (NSString *)distanceUpLoadTimeWith:(NSString *)timeString{
//    NSDate *nowDate = [NSDate date];
    //模拟一个固定的时间点
    NSDate *nowDate = [self dateFromString:@"2019-12-14 11:00:00"];
    NSDate * upLoadTime = [self dateFromString:timeString];
    
    NSTimeInterval interval = [nowDate timeIntervalSinceDate:upLoadTime];

    NSAssert(interval>0, @"时间必须是正的");
    
    NSInteger y = interval/(60*60*24*30*12);
    NSInteger months = interval/(60*60*24*30);
    NSInteger d = interval/(60*60*24);
    NSInteger h = interval/(60*60);
    NSInteger minutes = interval/60;
    NSInteger s = (long long)interval%60;
    
    NSString * distanceString;
    if (y>0) {
        distanceString = [NSString stringWithFormat:@"%ld年前",(long)y];
    }else if (months>0) {
        distanceString = [NSString stringWithFormat:@"%ld月前",(long)months];
    }else if (d>0) {
        distanceString = [NSString stringWithFormat:@"%ld天前",(long)d];
    }else if (h>0) {
        distanceString = [NSString stringWithFormat:@"%ld小时前",(long)h];
    }else if (minutes>0) {
        distanceString = [NSString stringWithFormat:@"%ld分钟前",(long)minutes];
    }else{
        distanceString = [NSString stringWithFormat:@"%ld秒前",(long)s];
    }
    
    return distanceString;
}

- (NSDate *)dateFromString:(NSString *)dateString{
    
    if (!dateString) {
        return nil;
    }
    NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    }
    
    return [dateFormatter dateFromString:dateString];
}

@end
