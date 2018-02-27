//
//  NoticeTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeTableViewCell : UITableViewCell

- (void)setNoticeCellWithHeadImage:(NSString *)headImge
                             Title:(NSString *)title
                              Desc:(NSString *)desc;

- (void)isShowPicImage:(BOOL)isShow Image:(NSString *)image;

@end
