//
//  ZTBottomTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTBottomTableViewCell.h"

@implementation ZTBottomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setCellIsSelected:(BOOL)isSelected
{
    self.chooseButton.hidden = NO;
    if (isSelected) {
        self.chooseButton.selected = YES;
    } else {
        self.chooseButton.selected = NO;
    }

}

- (void)setRightLabelHidden:(BOOL)isHidden;
{
    if (isHidden) {
        //隐藏右侧label
        self.rithgtLabel.hidden = YES;
        self.chooseButton.hidden = NO;

    } else {
        //显示右侧label
        self.chooseButton.hidden = YES;
        self.rithgtLabel.hidden = NO;
    }
}

- (void)showDoAppeal:(BOOL)show IsHiddenRight:(BOOL)isHiddenRight
{
    self.chooseButton.hidden = show;
    self.rithgtLabel.hidden = isHiddenRight;
    if (show) {
        [self.chooseButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-GTW(30) * 2 - GTW(120));
        }];
    } else {
        [self.chooseButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        }];
    }
}

- (void)createSubViews
{
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseButton setImage:[UIImage imageNamed:@"duihuan_checkbox_a"] forState:UIControlStateSelected];
    [self.chooseButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    self.chooseButton.adjustsImageWhenHighlighted = NO;
    self.chooseButton.hidden = YES;
    [self.contentView addSubview:self.chooseButton];
    
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(GTH(38));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = FONT(28);
    self.titleLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.top.height.equalTo(self.contentView);
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2 - GTW(120));
    }];
    
    self.rithgtLabel = [[UILabel alloc] init];
    self.rithgtLabel.text = @"已有教师";
    self.rithgtLabel.font = FONT(28);
    self.rithgtLabel.textColor = ZTTextGrayColor;
    self.rithgtLabel.textAlignment = NSTextAlignmentRight;
    self.rithgtLabel.hidden = YES;
    [self.contentView addSubview:self.rithgtLabel];
    
    [self.rithgtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo (self.titleLabel);
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.width.mas_equalTo(GTW(120));
    }];
    
}



@end
