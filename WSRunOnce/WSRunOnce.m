//
//  WSRunOnce.m
//  Example
//
//  Created by 王顺 on 15/6/18.
//  Copyright © 2015年 wangshun. All rights reserved.
//

#import "WSRunOnce.h"

#define kWSRunOnceKey       @"kWSRunOnceKey"
#define kWSVersion          @"CFBundleShortVersionString"
#define kWSBuild            @"CFBundleVersion"
#define kWSRunOnceString    @"kWSRunOnceString"

typedef enum {
    WSRunOnceMethodVersion = 0,
    WSRunOnceMethodBuild = 1
} WSRunOnceMethod;

@interface WSRunOnce ()

@property (nonatomic, strong) NSMutableDictionary *versionStringDict;
@property (nonatomic, strong) NSArray *methodArray;

@end

@implementation WSRunOnce

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.methodArray = @[kWSVersion, kWSBuild];
        self.versionStringDict = [NSMutableDictionary new];
        for (NSString *method in self.methodArray) {
            [self.versionStringDict setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:method] forKey:method];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *identifier = [kWSRunOnceKey stringByAppendingString:method];
            NSString *versionString = self.versionStringDict[method];
            NSDictionary *runOnceData = [userDefaults objectForKey:identifier];
            
            if (runOnceData == nil) {
                [userDefaults setObject:@{kWSRunOnceString: versionString} forKey:identifier];
            }
            else {
                if (![versionString isEqualToString:[runOnceData objectForKey:kWSRunOnceString]]) {
                    [userDefaults setObject:@{kWSRunOnceString: versionString} forKey:identifier];
                }
            }
            [userDefaults synchronize];
        }
        
    }
    return self;
}

- (BOOL)actionAlreadyRunInMethod:(WSRunOnceMethod)method withKey:(NSString *)key
{
    BOOL ret = NO;
    @synchronized(self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *identifier = [kWSRunOnceKey stringByAppendingString:self.methodArray[method]];
        NSDictionary *runOnceData = [userDefaults objectForKey:identifier];
        
        if ([runOnceData objectForKey:key] == nil)
            ret = NO;
        else
            ret = YES;
    }
    return ret;
}

- (void)saveActionStateInMethod:(WSRunOnceMethod)method withKey:(NSString *)key
{
    @synchronized(self) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *identifier = [kWSRunOnceKey stringByAppendingString:self.methodArray[method]];
        NSDictionary *runOnceData = [userDefaults objectForKey:identifier];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:runOnceData];
        [dict setObject:[NSNumber numberWithBool:YES] forKey:key];
        [userDefaults setObject:dict forKey:identifier];
        [userDefaults synchronize];
    }
}

- (void)runInMethod:(WSRunOnceMethod)method withKey:(NSString *)key action:(BOOL (^)(NSString *version))action
{
    if ([self actionAlreadyRunInMethod:method withKey:key]) {
        return;
    }
    
    if (action(self.versionStringDict[self.methodArray[method]])) {
        [self saveActionStateInMethod:method withKey:key];
    }
}



+ (id)sharedInstance {
    static WSRunOnce *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WSRunOnce alloc] init];
    });
    return sharedInstance;
}

+ (void)runOnceByVersionWithKey:(NSString *)key action:(BOOL (^)(NSString *))action
{
    WSRunOnce *run = [WSRunOnce sharedInstance];
    [run runInMethod:WSRunOnceMethodVersion withKey:key action:action];
}

+ (void)runOnceAsyncByVersionWithKey:(NSString *)key action:(BOOL (^)(NSString *))action
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WSRunOnce runOnceByVersionWithKey:key action:action];
    });
}


+ (void)runOnceByBuildWithKey:(NSString *)key action:(BOOL (^)(NSString *))action {
    WSRunOnce *run = [WSRunOnce sharedInstance];
    [run runInMethod:WSRunOnceMethodBuild withKey:key action:action];
}

+ (void)runOnceAsyncByBuildWithKey:(NSString *)key action:(BOOL (^)(NSString *))action {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WSRunOnce runOnceByBuildWithKey:key action:action];
    });
    
}

+ (void)runOnceWithKey:(NSString *)key action:(void (^)(void))action {
    NSString *newKey = [key stringByAppendingString:kWSRunOnceKey];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:newKey])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:newKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        action();
    }
}

+ (void)runOnceAsyncWithKey:(NSString *)key action:(void (^)(void))action {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WSRunOnce runOnceAsyncWithKey:key action:action];
    });
}

@end
