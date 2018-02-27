//
//  FindSearchTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "FindSearchTableViewCell.h"

@implementation FindSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.centerY.equalTo(self.contentView);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = @"就时代科技分开卡是点是";
    self.contentLabel.textColor = ZTTitleColor;
    self.contentLabel.font = FONT(28);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.cancelButton.mas_left).offset(GTW(-30));
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineLabel];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.cancelButton);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
    }];
    
}

- (void)cancelButtonAction
{
    if ([self.delegate respondsToSelector:@selector(toDeleteCell:)]) {
        [self.delegate toDeleteCell:self];
    }
}

@end
