//
//  MissionClassTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionClassTableViewCell : UITableViewCell

- (void)createMissionGradeTableViewWithFirstName:(NSString *)firstName
                                        LastName:(NSString *)lastName
                                       WordCount:(NSString *)wordCount
                                     InviteCount:(NSString *)inviteCount;

@end
