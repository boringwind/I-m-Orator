//
//  UIImage+ImageEffects.h
//  TickTick
//
//  Created by Wind on 14/11/19.
//  Copyright (c) 2014年 Appest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>

@interface UIImage (ImageEffects)

+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage*)applyLightEffect;
- (UIImage*)applyExtraLightEffect;
- (UIImage*)applyDarkEffect;
- (UIImage*)applyTintEffectWithColor:(UIColor*)tintColor;
- (UIImage*)applyBlurWithRadius:(CGFloat)blurRadius
                      tintColor:(UIColor*)tintColor
          saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                      maskImage:(UIImage*)maskImage;

@end
