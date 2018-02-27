//
//  UIImage+Extension.m
//  ZAInvestProject
//
//  Created by 迟宸 on 2017/6/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

+ (BOOL)isImageNull:(UIImage *)image
{
    CGImageRef cgref = [image CGImage];
    CIImage *cim = [image CIImage];
    
    if (cim == nil && cgref == NULL) {
        return YES;
    } else {
        return NO;
    }
}

//压缩图片
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0 , newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


@end
