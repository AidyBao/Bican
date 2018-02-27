//
//  MissionTeacherTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissionTeacherTableViewCell : UITableViewCell

- (void)setMissionTeacherCellWithTypeText:(NSString *)typeText
                                TypeColor:(UIColor *)typeColor
                                 LeftText:(NSString *)leftText
                                RightText:(NSString *)rightText
                             RightAllText:(NSString *)rightAllText
                               RightColor:(UIColor *)rightColor;

@end
