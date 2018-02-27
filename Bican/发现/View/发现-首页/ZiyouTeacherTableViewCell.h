//
//  ZiyouTeacherTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZiyouTeacherTableViewCell : UITableViewCell

- (void)setZiyouTeacherCellWithTeachNickName:(NSString *)teachNickName
                              TeachFirstName:(NSString *)teachFirstName
                                      Basice:(NSString *)basice
                                 Development:(NSString *)development
                             ArticleFraction:(NSString *)articleFraction;

@end
