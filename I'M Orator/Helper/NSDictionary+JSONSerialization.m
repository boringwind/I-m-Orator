//
//  NSDictionary+JSONSerialization.m
//  TickTick
//
//  Created by 猪登登 on 14/10/21.
//  Copyright (c) 2014年 Appest. All rights reserved.
//

#import "NSDictionary+JSONSerialization.h"

@implementation NSDictionary (JSONSerialization)

- (NSString *)JSONSerializedString
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    if (error) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
