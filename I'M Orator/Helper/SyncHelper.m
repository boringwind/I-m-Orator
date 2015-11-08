//
//  SyncHelper.m
//  让弹幕飞
//
//  Created by Wind on 15/10/24.
//  Copyright (c) 2015年 Wind. All rights reserved.
//

#import "SyncHelper.h"

#import "SVProgressHUD.h"
#import "AccountManager.h"

#import "AppDelegate.h"

#import <UIKit/UIKitDefines.h>

#import "NSArray+JSONSerialization.h"
#import "NSDictionary+JSONSerialization.h"

static SyncHelper *shareSyncHelper = nil;

@implementation SyncHelper

#pragma mark - Singleton

+ (void)initialize {
    if (self == [self class]) {
        shareSyncHelper = [[self alloc] init];
    }
}

+ (SyncHelper *)shareSyncHelper {
    return shareSyncHelper;
}

#pragma mark - Accessor Methods

- (NSString *)prefixSiteDomainToURLString:(NSString *)urlString {
    return [@"http://letshareba.com:8082" stringByAppendingString:urlString];
//    return [@"http://192.168.1.175:8082" stringByAppendingString:urlString];
}

- (NSDictionary *)customHttpHeader:(BOOL)withToken {
    NSMutableDictionary *httpHeader = [NSMutableDictionary dictionary];
    [httpHeader setValue:@"application/json;charset=UTF-8" forKey:@"content-type"];
    if (withToken) {
        [httpHeader setValue:[AccountManager shareAccountManager].token
                      forKey:@"token"];
    }
    return [httpHeader copy];
}

//#pragma mark - Register
//
//- (NSDictionary *)registerWithUsername:(NSString *)username
//                              password:(NSString *)password
//{
//    NSMutableURLRequest *request = [NSMutableURLRequest
//                                    requestWithURL:
//                                    [NSURL URLWithString:[self prefixSiteDomainToURLString:@"/register"]]];
//    [request setHTTPMethod:@"POST"];
//    [request setTimeoutInterval:30.f];
//    
//    NSDictionary *headersDictionary = [self customHeaderFormData];
//    [headersDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [request setValue:obj forHTTPHeaderField:key];
//    }];
//    
//    NSData *postData = [[@{
//                           @"username": username,
//                           @"password": password,
//                           } JSONSerializedString] dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:postData];
//    
//    NSHTTPURLResponse *response = nil;
//    NSError *error;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    
//    if (error) {
//        return nil;
//    }
//    else {
//        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//        if (error) {
//            return nil;
//        }
//        else {
//            return json;
//        }
//    }
//}

#pragma mark - Login

- (void)loginWithUsername:(NSString *)username
               completion:(void (^)(NSDictionary *resultDictionary))completion
                    error:(void (^)(NSError *error))errorBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[self prefixSiteDomainToURLString:@"/login"]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.f];

    NSDictionary *httpHeader = [self customHttpHeader:NO];
    [httpHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];

    NSData *postData = [[@{
                           @"user": username,
                           } JSONSerializedString] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    if (error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }
    else {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:0
                                                                             error:&error];
        if (error) {
            if (errorBlock) {
                errorBlock(error);
            }
        }
        else {
            
            NSDictionary *header = [response allHeaderFields];
            if ([header.allKeys containsObject:@"token"]) {
                [AccountManager shareAccountManager].token = header[@"token"];
            }
            if (completion) {
                completion(responseDictionary);
            }
        }
    }
}

#pragma mark - Rank

- (void)pullRanksCompletion:(void (^)(NSDictionary *resultDictionary))completion
                      error:(void (^)(NSError *error))errorBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[self prefixSiteDomainToURLString:@"/api/rank"]]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30.f];

    NSDictionary *httpHeader = [self customHttpHeader:YES];
    [httpHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   
                                   if (connectionError) {
                                       if (errorBlock) {
                                           errorBlock(connectionError);
                                       }
                                       return;
                                   }
                                   NSError *error = nil;
                                   NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                                                      options:NSJSONReadingAllowFragments
                                                                                                        error:&error];
                                   if (error) {
                                       if (errorBlock) {
                                           errorBlock(error);
                                       }
                                   }
                                   else {
                                       if (![self handleRequestResultDictionary:responseDictionary]) {
                                           if (completion) {
                                               completion(responseDictionary);
                                           }
                                       }
                                   }
                               });
     }];
}

// 废弃
//#pragma mark - To Who
//
//- (void)getRateToWhoCompletion:(void (^)(NSDictionary *resultDictionary))completion
//                         error:(void (^)(NSError *error))errorBlock {
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
//                                    [NSURL URLWithString:[self prefixSiteDomainToURLString:@"/api/toWho"]]];
//    [request setHTTPMethod:@"GET"];
//    [request setTimeoutInterval:30.f];
//    
//    NSDictionary *httpHeader = [self customHttpHeader:YES];
//    [httpHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        [request setValue:obj forHTTPHeaderField:key];
//    }];
//    
//    NSHTTPURLResponse *response = nil;
//    NSError *error;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request
//                                         returningResponse:&response
//                                                     error:&error];
//    
//    if (error) {
//        if (errorBlock) {
//            errorBlock(error);
//        }
//    }
//    else {
//        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
//                                                                           options:0
//                                                                             error:&error];
//        if (error) {
//            if (errorBlock) {
//                errorBlock(error);
//            }
//        }
//        else {
//            if (![self handleRequestResultDictionary:responseDictionary]) {
//                if (completion) {
//                    completion(responseDictionary);
//                }
//            }
//        }
//    }
//}

#pragma mark - Save Score

- (void)postScoreWithPostDictionary:(NSDictionary *)postDictionary
                         completion:(void (^)(NSDictionary *resultDictionary))completion
                              error:(void (^)(NSError *error))errorBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[self prefixSiteDomainToURLString:@"/api/saveScore"]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30.f];

    NSDictionary *httpHeader = [self customHttpHeader:YES];
    [httpHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];

    NSData *postData = [[postDictionary JSONSerializedString] dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               dispatch_async(dispatch_get_main_queue(), ^{
                                    if (connectionError) {
                                        errorBlock(connectionError);
                                        return ;
                                    }
                                    
                                    NSError *error = nil;
                                    NSDictionary *responseDictionary =
                                        [NSJSONSerialization JSONObjectWithData:data
                                                                        options:NSJSONReadingAllowFragments
                                                                          error:&error];
                                    if (error) {
                                        if (errorBlock) {
                                            errorBlock(error);
                                        }
                                        return;
                                    }
                                   if (![[SyncHelper shareSyncHelper] handleRequestResultDictionary:responseDictionary]) {
                                       if (completion) {
                                           completion(responseDictionary);
                                       }
                                   }
                               });
    }];
}

#pragma mark - Order

- (void)getOrderCompletion:(void (^)(NSDictionary *resultDictionary))completion
                     error:(void (^)(NSError *error))errorBlock {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:
                                    [NSURL URLWithString:[self prefixSiteDomainToURLString:@"/api/order"]]];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:30.f];
    
    NSDictionary *httpHeader = [self customHttpHeader:YES];
    [httpHeader enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [request setValue:obj forHTTPHeaderField:key];
    }];
    
    NSHTTPURLResponse *response = nil;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response
                                                     error:&error];
    
    if (error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }
    else {
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:0
                                                                             error:&error];
        if (error) {
            if (errorBlock) {
                errorBlock(error);
            }
        }
        else {
            if (![self handleRequestResultDictionary:responseDictionary]) {
                if (completion) {
                    completion(responseDictionary);
                }
            }
        }
    }
}

#pragma mark - 

- (BOOL)handleRequestResultDictionary:(NSDictionary *)resultDictionary {
    // 把没有登录的错误处理掉
    if ([resultDictionary.allKeys containsObject:@"code"]) {
        // 失败了
        NSNumber *code = resultDictionary[@"code"];
        if ([code integerValue] == 0) {
            if ([resultDictionary[@"msg"] isEqualToString:@"no login"]) {
                // 没有登录
                [SVProgressHUD showErrorWithStatus:@"登录已失效，请重新登录"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[AppDelegate getInstance] lognOut];
                });
                return YES;
            }
        }
    }
    return NO;
}

@end
