//
//  SyncHelper.h
//  让弹幕飞
//
//  Created by Wind on 15/10/24.
//  Copyright (c) 2015年 Wind. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncHelper : NSObject

+ (SyncHelper *)shareSyncHelper;

//#pragma mark - Register
//
//- (NSDictionary *)registerWithUsername:(NSString *)username
//                              password:(NSString *)password;

#pragma mark - Login

- (void)loginWithUsername:(NSString *)username
               completion:(void (^)(NSDictionary *resultDictionary))completion
                    error:(void (^)(NSError *error))errorBlock;

#pragma mark - Rank

- (void)pullRanksCompletion:(void (^)(NSDictionary *resultDictionary))completion
                      error:(void (^)(NSError *error))errorBlock;

// 废弃
//#pragma mark - To Who
//
//- (void)getRateToWhoCompletion:(void (^)(NSDictionary *resultDictionary))completion
//                         error:(void (^)(NSError *error))errorBlock;

#pragma mark - Save Score

- (void)postScoreWithPostDictionary:(NSDictionary *)postDictionary
                         completion:(void (^)(NSDictionary *resultDictionary))completion
                              error:(void (^)(NSError *error))errorBlock;

#pragma mark - Order

- (void)getOrderCompletion:(void (^)(NSDictionary *resultDictionary))completion
                     error:(void (^)(NSError *error))errorBlock;

@end
