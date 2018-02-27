//
//  AttentionTableViewCell.m
//  Bican
//
//  Created by bican on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AttentionTableViewCell.h"

@interface AttentionTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *schoolNameLabel;
@property (nonatomic, strong) UIButton *guanzhuButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation AttentionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createAttentionTableViewWithAvatar:(NSString *)avatar
                                  NickName:(NSString *)nickName
                               TeacherName:(NSString *)teacherName
                                SchoolName:(NSString *)schoolName
                                  RoleType:(NSString *)roleType
                                  PicImage:(NSString *)picImage
{
    if (avatar.length != 0) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"my_header"]];
    }
    self.picImageView.image = [UIImage imageNamed:picImage];
    if ([roleType isEqualToString:@"1"]) {
        self.nameLabel.text = nickName;
    }
    if ([roleType isEqualToString:@"2"]) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", nickName, teacherName];
    }
    self.schoolNameLabel.text = schoolName;
}

- (void)createSubViews
{
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = GTH(78) / 2;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.image = [UIImage imageNamed:@"my_header"];

    [self.contentView addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(28));
        make.size.mas_equalTo(CGSizeMake(GTH(78), GTH(78)));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = ZTTitleColor;
    self.nameLabel.font = FONT(28);
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(GTW(28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(35));
        make.height.mas_equalTo(GTH(30));
    }];
    
    self.picImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.picImageView];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_left);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(17));
        make.size.mas_equalTo(CGSizeMake(GTH(24), GTH(24)));
    }];
    
 
    self.schoolNameLabel = [[UILabel alloc] init];
    self.schoolNameLabel.textColor = ZTTextLightGrayColor;
    self.schoolNameLabel.font = FONT(24);
    [self.contentView addSubview:self.schoolNameLabel];
    
    [self.schoolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picImageView.mas_right).offset(GTW(10));
        make.top.equalTo(self.picImageView.mas_top);
        make.height.mas_equalTo(GTH(24));
    }];
    
    self.guanzhuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.guanzhuButton setImage:[UIImage imageNamed:@"guanzhu_btn"] forState:UIControlStateNormal];
    self.guanzhuButton.adjustsImageWhenHighlighted = NO;
    [self.guanzhuButton addTarget:self action:@selector(attentionButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.guanzhuButton];
    
    [self.guanzhuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(39));
        make.size.mas_equalTo(CGSizeMake(GTW(84), GTH(46)));
        
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(GTH(20));
        make.height.mas_equalTo(1);
    }];
    
}



- (void)attentionButtonAction
{
    
}


@end
