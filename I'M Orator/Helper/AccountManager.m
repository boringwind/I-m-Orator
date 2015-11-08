//
//  AccountManager.m
//  让弹幕飞
//
//  Created by Wind on 15/10/24.
//  Copyright (c) 2015年 Wind. All rights reserved.
//

#import "AccountManager.h"

static AccountManager *accountManager = nil;

@implementation AccountManager

+ (void)initialize {
    if (self == [self class]) {
        accountManager = [[self alloc] init];
    }
}

+ (AccountManager *)shareAccountManager {
    return accountManager;
}

#pragma mark - properties

- (NSString *)lastUserID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastUserID"];
}

- (void)setLastUserID:(NSString *)lastUserID {
    [[NSUserDefaults standardUserDefaults] setObject:lastUserID forKey:@"lastUserID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)lastPassword {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPassword"];
}

- (void)setLastPassword:(NSString *)lastPassword {
    [[NSUserDefaults standardUserDefaults] setObject:lastPassword forKey:@"lastPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)token {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
}

- (void)setToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
