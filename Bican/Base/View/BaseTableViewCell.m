//
//  BaseTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/23.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

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
