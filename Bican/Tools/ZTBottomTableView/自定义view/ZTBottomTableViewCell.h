//
//  ZTBottomTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTBottomTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) UILabel *rithgtLabel;
//设置cell被选中
- (void)setCellIsSelected:(BOOL)isSelected;
//显示"已有教师"
- (void)setRightLabelHidden:(BOOL)isHidden;
//申诉的选择
- (void)showDoAppeal:(BOOL)show IsHiddenRight:(BOOL)isHiddenRight;

@end
