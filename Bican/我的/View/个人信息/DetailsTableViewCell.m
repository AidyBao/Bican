//
//  DetailsTableViewCell.m
//  Bican
//
//  Created by bican on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "DetailsTableViewCell.h"

@implementation DetailsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createTableView];
    }
    return self;
}

- (void)createTableView
{
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = ZTTextGrayColor;
    self.nameLabel.font = FONT(24);
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(39));
//        make.height.mas_equalTo(GTH(25));
    }];
    
    self.nameTextField = [[UITextField alloc] init];
    [self.nameTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTextField setValue:FONT(28) forKeyPath:@"_placeholderLabel.font"];
    self.nameTextField.textColor = ZTTitleColor;
    self.nameTextField.font = FONT(28);
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.contentView addSubview:self.nameTextField];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(16));
//        make.height.mas_equalTo(GTH(30));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(1);
    }];
}


@end
