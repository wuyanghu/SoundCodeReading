//
//  WPLogManager.m
//  objc-test
//
//  Created by wupeng on 2020/1/25.
//

#import "WPLogManager.h"
#import "fishhook.h"

@implementation WPLogManager

static void (*orig_NSLog)(NSString *format, ...);
void(new_NSLog)(NSString *format, ...) {
    va_list args;
    if(format) {
        va_start(args, format);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
//        orig_NSLog(@"%@", message);
        va_end(args);
    }
}

+ (void)load{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        rebind_symbols((struct rebinding[1]){{
//            "NSLog", new_NSLog, (void *)&orig_NSLog}
//        }, 1);
//    });
}

+ (WPLogManager *)sharedManager
{
    static id sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end
