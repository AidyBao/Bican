//
//  AddClassTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AddClassTableViewCell.h"

@implementation AddClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSbuViews];
    }
    return self;
}

- (void)createSbuViews
{
    self.rightImageView = [[UIImageView alloc] init];
    self.rightImageView.image = [UIImage imageNamed:@"xuanze_icon"];
    [self.contentView addSubview:self.rightImageView];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.bottom.equalTo(self.contentView).offset(GTH(-20));
        make.width.height.mas_equalTo(GTH(17));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTextLightGrayColor;
    self.titleLabel.font = FONT(28);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(GTH(66));
        make.bottom.equalTo(self.contentView).offset(GTH(-20));
        make.centerX.equalTo(self.contentView);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.right.equalTo(self.contentView).offset(GTW(-30));
    }];
    
}



@end
