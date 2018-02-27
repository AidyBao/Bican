//
//  GuanzhuTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuanzhuTableViewCell : UITableViewCell

- (void)createGuanzhuTableViewWithAvatar:(NSString *)avatar
                                 Nickname:(NSString *)nickname
                                  PubTime:(NSString *)pubTime
                                  Content:(NSString *)content;

//是否显示红点
- (void)setGuanzhuCellIsShowWarning:(NSString *)isShowWarning;

@end
