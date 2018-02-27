//
//  GuanzhuTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "GuanzhuTableViewCell.h"

@interface GuanzhuTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *redView;

@end

@implementation GuanzhuTableViewCell

- (void)createGuanzhuTableViewWithAvatar:(NSString *)avatar
                                 Nickname:(NSString *)nickname
                                  PubTime:(NSString *)pubTime
                                  Content:(NSString *)content
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"sousuo_xiaoxi"]];
    self.nameLabel.text = nickname;
    self.dateLabel.text = pubTime;
    self.contentLabel.text = content;
}

- (void)setGuanzhuCellIsShowWarning:(NSString *)isShowWarning
{
    if ([isShowWarning isEqualToString:@"YES"]) {
        self.redView.hidden = NO;
    } else {
        self.redView.hidden = YES;
    }
}

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
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.image = [UIImage imageNamed:@"my_header"];
    self.headImageView.layer.cornerRadius = GTH(78) / 2;
    self.headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headImageView];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(GTH(78));
    }];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = ZTTextLightGrayColor;
    self.dateLabel.font = FONT(24);
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.dateLabel];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(GTW(-30));
        make.top.equalTo(self.contentView).offset(GTH(20));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = FONT(26);
    self.nameLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(GTW(30));
        make.top.equalTo(self.contentView).offset(GTH(20));
        make.right.equalTo(self.dateLabel.mas_left).offset(GTW(-30));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = FONT(24);
    self.contentLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.dateLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView);
        make.right.equalTo(self.dateLabel);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
    }];
    
    self.redView = [[UIView alloc] init];
    self.redView.backgroundColor = ZTDarkRedColor;
    self.redView.layer.cornerRadius = GTH(30) / 2;
    [self.contentView addSubview:self.redView];
    
    [self.redView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(GTH(30));
        make.top.equalTo(self.headImageView.mas_top);
        make.centerX.equalTo(self.headImageView.mas_centerX).offset(GTH(30));
    }];
    
}

@end
