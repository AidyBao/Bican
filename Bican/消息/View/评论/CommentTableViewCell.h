//
//  CommentTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell

- (void)setsetCommentCellWithHeadImage:(NSString *)headImage
                                 Title:(NSString *)title
                                  Date:(NSString *)date
                                  Name:(NSString *)name
                               Content:(NSString *)content;

//是否显示红点
- (void)setCommentCellIsShowWarning:(BOOL)isShowWarning;

@end
