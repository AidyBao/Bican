//
//  UILabel+Extension.h
//  ZAInvestProject
//
//  Created by 迟宸 on 2017/5/17.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

//设置label的text, 字体颜色,位置,长度,字体大小
+ (NSMutableAttributedString *)changeLabel:(UILabel *)label Color:(UIColor *)color Loc:(NSInteger)loc Len:(NSInteger)len Font:(UIFont *)font;

//设置label的text, 背景颜色,位置,长度,字体大小
+ (NSMutableAttributedString *)addAttributesLabel:(UILabel *)label BackgroundColor:(UIColor *)backgroundColor Loc:(NSInteger)loc Len:(NSInteger)len Font:(UIFont *)font;

//为label画边框
+ (CAShapeLayer *)drawLineWithLabel:(UILabel *)label Width:(CGFloat)width Height:(CGFloat)height Color:(UIColor *)color;

//label的段落设置
+ (NSAttributedString *)setLabelSpace:(UILabel *)label withValue:(NSString *)str withFont:(UIFont *)font;

//label设置部分圆角
+ (CAShapeLayer *)addRoundedWithCorners:(UIRectCorner)corners
                                  Radii:(CGSize)radii
                                   Rect:(CGRect)rect;

//转换html字符串
- (void)htmlStringToChangeWithLabel:(UILabel *)label String:(NSString *)string;

- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_width:(CGFloat)str_width;

- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_height:(CGFloat)str_height;

@end
