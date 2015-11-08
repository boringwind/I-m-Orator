//
//  TTCacheImageEngine.m
//  TickTick
//
//  Created by Wind on 9/25/14.
//  Copyright (c) 2014 Appest. All rights reserved.
//

#import "TTCacheImageEngine.h"

static TTCacheImageEngine * cacheImageEngine = nil;

@implementation TTCacheImageEngine

+ (void)initialize
{
    if (self == [self class]) {
        cacheImageEngine = [[self alloc] init];
        [cacheImageEngine useCache];
    }
}

+ (TTCacheImageEngine *)shareCacheImageEngine
{
    return cacheImageEngine;
}

- (void)emptyCache
{
    [super emptyCache];
}

@end
