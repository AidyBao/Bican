



//
//  InviteChooseTableViewCell.m
//  Bican
//
//  Created by chichen on 2018/1/10.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "InviteChooseTableViewCell.h"

@interface InviteChooseTableViewCell ()

@property (nonatomic, strong) UIButton *chooseButton;
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


@end


@implementation InviteChooseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createInviteChooseCellWithNickname:(NSString *)nickname
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


- (void)setCellIsSelected:(NSString *)isSelected
{
    if ([isSelected isEqualToString:@"NO"]) {
        self.chooseButton.selected = NO;
    } else {
        self.chooseButton.selected = YES;
    }
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
    
    
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self.chooseButton setImage:[UIImage imageNamed:@"checkbox_a"] forState:UIControlStateSelected];
    self.chooseButton.selected = NO;
    self.chooseButton.adjustsImageWhenHighlighted = NO;
    [self.chooseButton addTarget:self action:@selector(chooseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.chooseButton];
    
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(GTH(38), GTH(38)));
    }];
    
    
    self.titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_icon_big"]];
    [self.contentView addSubview:self.titleImageView];
    
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(96));
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
    self.nameLabel.text = @"齐天大圣";
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(GTW(30));
        make.top.equalTo(self.lineView.mas_top);
    }];
    
    
    self.schoolNameLabel = [[UILabel alloc] init];
    self.schoolNameLabel.textColor = ZTTextLightGrayColor;
    self.schoolNameLabel.font = FONT(24);
    self.schoolNameLabel.text = @"四川师范大学实验中学";
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
    self.reviewLabel.text = @"评阅作文:";
    [self.contentView addSubview:self.reviewLabel];
    
    [self.reviewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = FONT(28);
    self.titleLabel.text = @"速度快拉黑发就开发公司";
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
    self.giftLabel.text = @"并让分公司的风景更合适的发货速度哈啊客户说的我鄂温克令人绝望的十分关键是的反馈就是地方啊啥的了孃我看了天津玩儿去看了我就饿去打开进风口脸上的肌肤克里斯朵夫考虑到看风景了蒯圣诞节快乐圣诞节老师讲课了三等奖流口水的福克斯";
    [self.contentView addSubview:self.giftLabel];
    
    [self.giftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.giftImageView.mas_right).offset(GTW(10));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(30));
    }];
}


- (void)chooseButtonAction
{
    if ([self.delegate respondsToSelector:@selector(selecetedCell:)]) {
        [self.delegate selecetedCell:self];
    }
    
}



@end
