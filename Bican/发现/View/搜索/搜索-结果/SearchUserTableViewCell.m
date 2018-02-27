//
//  SearchUserTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "SearchUserTableViewCell.h"

@interface SearchUserTableViewCell ()

@end

@implementation SearchUserTableViewCell

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
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = GTH(76) / 2;
    self.headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(GTH(76));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    self.nameLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(GTW(40));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(60));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
    }];
    
    self.classLabel = [[UILabel alloc] init];
    self.classLabel.font = FONT(24);
    self.classLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.classLabel];

    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineLabel];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.nameLabel);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
    }];
    
}

#pragma mark - 关键字高亮
- (void)setKeyWord:(NSString *)keyWord
{
    if (keyWord.length == 0) {
        self.nameLabel.textColor = ZTTitleColor;
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.nameLabel.text];
    NSRange range = [self.nameLabel.text rangeOfString:keyWord];
    UIColor *highlightedColor = ZTOrangeColor;
    [attributedString addAttribute:NSForegroundColorAttributeName value:highlightedColor range:range];
    self.nameLabel.attributedText = attributedString;
}


@end
