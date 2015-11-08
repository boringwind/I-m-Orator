//
//  TTCacheImageEngine.h
//  TickTick
//
//  Created by Wind on 9/25/14.
//  Copyright (c) 2014 Appest. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface TTCacheImageEngine : MKNetworkEngine

+ (TTCacheImageEngine *)shareCacheImageEngine;

- (void)emptyCache;

@end
