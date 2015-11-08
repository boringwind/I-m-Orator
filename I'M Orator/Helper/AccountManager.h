//
//  AccountManager.h
//  让弹幕飞
//
//  Created by Wind on 15/10/24.
//  Copyright (c) 2015年 Wind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountManager : NSObject

@property (nonatomic, strong) NSString *lastUserID;
//@property (nonatomic, strong) NSString *lastPassword;

@property (nonatomic, strong) NSString *token;

+ (AccountManager *)shareAccountManager;

@end
