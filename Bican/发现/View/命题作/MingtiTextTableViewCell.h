//
//  MingtiTextTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/2.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MingtiTextTableViewCell : UITableViewCell

- (void)setMingtiTextCellWithFromUser:(NSString *)fromUser
                             FromTest:(NSString *)fromTest
                                 Type:(NSString *)type
                                Title:(NSString *)title
                              Content:(NSString *)content
                                Check:(NSString *)check
                                 Page:(NSString *)page;


@end
