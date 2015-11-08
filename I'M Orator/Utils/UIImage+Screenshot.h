//
//  UIImage+Screenshot.h
//  TickTick
//
//  Created by 猪登登 on 15/4/14.
//  Copyright (c) 2015年 Appest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Screenshot)

+ (UIImage*)screenshotCapturedWithinView:(UIView *)view;
+ (UIImage*)screenshotCapturedWithinView:(UIView *)view size:(CGSize)size;

@end
