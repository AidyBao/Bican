//
//  MingtiDetailTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/6.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MingtiDetailTableViewCell : UITableViewCell

- (void)setMingtiDetailCellWithHeaderImage:(NSString *)headerImage
                                  NickName:(NSString *)nickName
                                SchoolName:(NSString *)schoolName
                                     Title:(NSString *)title
                                   Content:(NSString *)content
                                ReadNumber:(NSString *)readNumber
                              PraiseNumber:(NSString *)praiseNumber
                          CollectionNumber:(NSString *)collectionNumber
                             CommentNumber:(NSString *)commentNumber;

@end
