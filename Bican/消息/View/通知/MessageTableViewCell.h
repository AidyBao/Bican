//
//  MessageTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewCell : UITableViewCell

- (void)setMessageCellWithImage:(NSString *)image
                          Title:(NSString *)title
                          Count:(NSString *)count
           CountBackgroundColor:(UIColor *)countBackgroundColor;

@end
