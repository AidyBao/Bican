//
//  UserIntroTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserIntroTableViewCell;
@protocol UserIntroTableViewCellDelegate <NSObject>

- (void)attentionButtonWithCell:(UserIntroTableViewCell *)cell;

@end

@interface UserIntroTableViewCell : UITableViewCell

- (void)setCellWithHeadImage:(NSString *)headImage
                    NickName:(NSString *)nickName
                  SchoolName:(NSString *)schoolName
                       Grade:(NSString *)grade
                     Comment:(NSString *)comment
                      Invite:(NSString *)invite
                 IsAttention:(NSString *)isAttention
                      UserId:(NSString *)userId;

//设置星星
- (void)setUserIntroCellStar:(NSString *)star;

- (void)changeButtonWithTitle:(NSString *)title Color:(UIColor *)color;

@property (nonatomic, assign) id <UserIntroTableViewCellDelegate> delegate;

@end
