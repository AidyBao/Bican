//
//  UIImage+Extension.h
//  ZAInvestProject
//
//  Created by 迟宸 on 2017/6/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

//判断图片是否为空
+ (BOOL)isImageNull:(UIImage *)image;

//压缩图片
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

@end
