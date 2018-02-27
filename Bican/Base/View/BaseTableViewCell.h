//
//  BaseTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/23.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

#pragma mark - 获取文本高度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_width:(CGFloat)str_width;

#pragma mark - 获取文本宽度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_height:(CGFloat)str_height;

@end
