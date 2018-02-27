
//
//  InviteTableViewCell.m
//  Bican
//
//  Created by chichen on 2018/1/10.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "InviteTableViewCell.h"

@interface InviteTableViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *inviteLabelOne;
@property (nonatomic, strong) UILabel *inviteLabelTwo;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *schoolNameLabel;
@property (nonatomic, strong) UILabel *reviewLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *giftImageView;
@property (nonatomic, strong) UILabel *giftLabel;

@end

@implementation InviteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createInviteViewControllerWithNickname:(NSString *)nickname
                                    SchoolName:(NSString *)schoolName
                                         Title:(NSString *)title
                                     Frequency:(NSString *)frequency
                                        Status:(NSString *)status
                                        Flower:(NSString *)flower
{
    self.nameLabel.text = nickname;
    self.schoolNameLabel.text = schoolName;
    if (frequency.length != 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"《%@》(%@)", title, frequency];
    } else {
        self.titleLabel.text = [NSString stringWithFormat:@"《%@》", title];
    }
    self.giftLabel.text = flower;
        
}

- (void)createSubViews
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.shadowColor = ZTTextGrayColor.CGColor;
    self.backView.layer.shadowOpacity = 0.24f;
    self.backView.layer.shadowRadius = GTH(30);

    [self.contentView addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(GTH(30));
        make.bottom.equalTo(self.contentView.mas_bottom);
        
    }];
    
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_icon_big"]];
    [self.contentView addSubview:self.titleImageView];
    
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.top.equalTo(self.backView).offset(GTH(30));
        make.size.mas_equalTo(CGSizeMake(GTW(42), GTH(67)));
    }];
    
    self.inviteLabelOne = [[UILabel alloc] init];
    self.inviteLabelOne.textColor = ZTTitleColor;
    self.inviteLabelOne.font = FONT(32);
    self.inviteLabelOne.text = @"邀";
    [self.contentView addSubview:self.inviteLabelOne];
    
    [self.inviteLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageView.mas_left);
        make.top.equalTo(self.titleImageView.mas_bottom).offset(GTH(38));
    }];
    
    
    self.inviteLabelTwo = [[UILabel alloc] init];
    self.inviteLabelTwo.textColor = ZTTitleColor;
    self.inviteLabelTwo.font = FONT(32);
    self.inviteLabelTwo.text = @"请";
    [self.contentView addSubview:self.inviteLabelTwo];
    
    [self.inviteLabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inviteLabelOne);
        make.top.equalTo(self.inviteLabelOne.mas_bottom).offset(GTH(27));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleImageView.mas_right).offset(GTW(30));
        make.top.equalTo(self.titleImageView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(GTH(-30));
        make.width.mas_equalTo(1);
    }];
    
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = ZTTextGrayColor;
    self.nameLabel.font = FONT(28);
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(GTW(30));
        make.top.equalTo(self.lineView.mas_top);
    }];
    
    
    self.schoolNameLabel = [[UILabel alloc] init];
    self.schoolNameLabel.textColor = ZTTextLightGrayColor;
    self.schoolNameLabel.font = FONT(24);
    [self.contentView addSubview:self.schoolNameLabel];
    
    [self.schoolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.lineView.mas_top);
    }];
    
    self.userImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guanzhu_people"]];
    [self.contentView addSubview:self.userImageView];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.schoolNameLabel.mas_left).offset(GTW(-10));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(62));
    }];
    
    
    self.reviewLabel = [[UILabel alloc] init];
    self.reviewLabel.textColor = ZTTitleColor;
    self.reviewLabel.font = FONT(28);
    [self.contentView addSubview:self.reviewLabel];
    
    [self.reviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = FONT(28);
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.reviewLabel.mas_bottom).offset(GTH(30));
    }];
    
    
    self.giftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flower_zs"]];
    [self.contentView addSubview:self.giftImageView];
    
    [self.giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(32));
        make.size.mas_equalTo(CGSizeMake(GTW(20), GTH(23)));
    }];
    
    self.giftLabel = [[UILabel alloc] init];
    self.giftLabel.textColor = ZTTextLightGrayColor;
    self.giftLabel.font = FONT(24);
    self.giftLabel.numberOfLines = 0;
    [self.contentView addSubview:self.giftLabel];
    
    [self.giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.giftImageView.mas_right).offset(GTW(10));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(30));
    }];
}


@end
