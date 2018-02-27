//
//  UILabel+Extension.m
//  ZAInvestProject
//
//  Created by 迟宸 on 2017/5/17.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (NSMutableAttributedString *)changeLabel:(UILabel *)label Color:(UIColor *)color Loc:(NSInteger)loc Len:(NSInteger)len Font:(UIFont *)font
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:label.text];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(loc, len)];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(loc, len)];
    
    return str;
}

+ (NSMutableAttributedString *)addAttributesLabel:(UILabel *)label BackgroundColor:(UIColor *)backgroundColor Loc:(NSInteger)loc Len:(NSInteger)len Font:(UIFont *)font
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:label.text];
    [str addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:NSMakeRange(loc, len)];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(loc, len)];
    
    return str;
}

+ (CAShapeLayer *)drawLineWithLabel:(UILabel *)label Width:(CGFloat)width Height:(CGFloat)height Color:(UIColor *)color
{
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    bezierPath.lineWidth = 1;
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(width, 0)];
    [bezierPath addLineToPoint:CGPointMake(width, height)];
    [bezierPath addLineToPoint:CGPointMake(width * 2 / 3, height)];
    [bezierPath addLineToPoint:CGPointMake(width / 2, height + GTH(12))];
    [bezierPath addLineToPoint:CGPointMake(width / 3, height)];
    [bezierPath addLineToPoint:CGPointMake(0, height)];
    [bezierPath closePath];
//    [bezierPath stroke];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = label.bounds;
    layer.path = bezierPath.CGPath;
    layer.lineCap = @"miter";
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth = 1;
    layer.strokeColor = color.CGColor;
    
//    UIGraphicsEndImageContext();

    return layer;
    
}

+ (NSAttributedString *)setLabelSpace:(UILabel *)label withValue:(NSString *)str withFont:(UIFont *)font
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //换行类型
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    //对齐方式
    paraStyle.alignment = NSTextAlignmentLeft;
    //设置行间距
    paraStyle.lineSpacing = 4.0f;
    //连字符属性
    paraStyle.hyphenationFactor = 1.0;
    //首行缩进
    paraStyle.firstLineHeadIndent = 0.0;
    //段落间距
    paraStyle.paragraphSpacingBefore = 0.0;
    //整段缩进
    paraStyle.headIndent = 0;
    //右侧缩进或显示宽度
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f};
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];

    return attributeStr;
}

+ (CAShapeLayer *)addRoundedWithCorners:(UIRectCorner)corners
                                  Radii:(CGSize)radii
                                   Rect:(CGRect)rect;
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    [maskLayer setPath:maskPath.CGPath];
    
    return maskLayer;

}

- (void)htmlStringToChangeWithLabel:(UILabel *)label String:(NSString *)string
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3; //设置行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//,NSParagraphStyleAttributeName:paragraphStyle
    label.attributedText = attributedString;    
    
}

#pragma mark - 获取文本高度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_width:(CGFloat)str_width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4; //设置行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(str_width, 8000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@1.5f} context:nil];
    
    return rect.size;
}

#pragma mark - 获取文本宽度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_height:(CGFloat)str_height
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4; //设置行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(8000, str_height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@1.5f} context:nil];
    
    return rect.size;
}



@end
