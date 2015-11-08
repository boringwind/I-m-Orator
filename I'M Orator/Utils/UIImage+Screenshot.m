//
//  UIImage+Screenshot.m
//  TickTick
//
//  Created by 猪登登 on 15/4/14.
//  Copyright (c) 2015年 Appest. All rights reserved.
//

#import "UIImage+Screenshot.h"

@implementation UIImage (Screenshot)

+ (UIImage*)screenshotCapturedWithinView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return uiImage;
}

+ (UIImage*)screenshotCapturedWithinView:(UIView *)view size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 1);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return uiImage;
}

@end
