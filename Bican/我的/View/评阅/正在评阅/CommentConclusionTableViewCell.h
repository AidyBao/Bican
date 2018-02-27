//
//  CommentConclusionTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/27.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface CommentConclusionTableViewCell : BaseTableViewCell

- (void)setCommentConclusionCellWithTeacherName:(NSString *)teacherName
                                       NickName:(NSString *)nickName
                                          Basic:(NSString *)basic
                                    Development:(NSString *)development
                                       Fraction:(NSString *)fraction;

@end
