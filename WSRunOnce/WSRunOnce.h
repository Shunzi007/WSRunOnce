//
//  WSRunOnce.h
//  Example
//
//  Created by 王顺 on 15/6/18.
//  Copyright © 2015年 wangshun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSRunOnce : NSObject

+ (void)runOnceByVersionWithKey:(NSString *)key action:(BOOL (^)(NSString *version))action;
+ (void)runOnceAsyncByVersionWithKey:(NSString *)key action:(BOOL (^)(NSString *version))action;

+ (void)runOnceByBuildWithKey:(NSString *)key action:(BOOL (^)(NSString *build))action;
+ (void)runOnceAsyncByBuildWithKey:(NSString *)key action:(BOOL (^)(NSString *build))action;

+ (void)runOnceWithKey:(NSString *)key action:(void (^)(void))action;
+ (void)runOnceAsyncWithKey:(NSString *)key action:(void (^)(void))action;


@end

