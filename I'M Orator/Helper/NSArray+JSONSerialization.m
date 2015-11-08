//
//  NSArray+JSONSerialization.m
//  TickTick
//
//  Created by 猪登登 on 15/6/30.
//  Copyright (c) 2015年 Appest. All rights reserved.
//

#import "NSArray+JSONSerialization.h"

@implementation NSArray (JSONSerialization)

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
