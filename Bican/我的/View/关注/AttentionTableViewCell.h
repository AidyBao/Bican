//
//  AttentionTableViewCell.h
//  Bican
//
//  Created by bican on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttentionTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *picImageView;

- (void)createAttentionTableViewWithAvatar:(NSString *)avatar
                                  NickName:(NSString *)nickName
                               TeacherName:(NSString *)teacherName
                                SchoolName:(NSString *)schoolName
                                  RoleType:(NSString *)roleType
                                  PicImage:(NSString *)picImage;

@end
