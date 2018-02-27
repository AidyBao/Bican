//
//  ZiyouReplyTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZiyouReplyTableViewCell.h"

@interface ZiyouReplyTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *tipView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *replyButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation ZiyouReplyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setZiyouReplyCellWithHeadImage:(NSString *)headImage
                                  Name:(NSString *)name
                                  Date:(NSString *)date
                               Content:(NSString *)content
                           ButtonTitle:(NSString *)buttonTitle
                                   Tip:(NSString *)tip
                             IsShowTip:(BOOL)IsShowTip
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLabel.text = name;
    self.dateLabel.text = date;
    self.contentLabel.text = content;
    [self.replyButton setTitle:buttonTitle forState:UIControlStateNormal];

    CGFloat width = ScreenWidth - GTW(30) * 2 - GTW(20) - GTW(50);
    if (content.length != 0) {
        CGSize contentSize = [self.contentLabel getSizeWithString:content font:FONT(26) str_width:width];
        [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentSize.height);
        }];

    }
    if (IsShowTip) {
        self.tipView.hidden = NO;
        self.tipLabel.hidden = NO;
        self.tipLabel.text = tip;
        if (tip.length != 0) {
            self.tipLabel.attributedText = [UILabel setLabelSpace:self.tipLabel withValue:self.tipLabel.text withFont:self.tipLabel.font];
            self.tipLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            CGSize tipSize = [self.tipLabel getSizeWithString:tip font:FONT(24) str_width:width - GTW(50) * 2];
            [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(tipSize.height);
            }];
            [self.tipView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(tipSize.height + GTH(30));
            }];
        }
        
    } else {
        self.tipView.hidden = YES;
        self.tipLabel.hidden = YES;

    }
    
}

- (void)createSubViews
{
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.layer.cornerRadius = GTH(50) / 2;
    self.headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headImageView];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.width.height.mas_equalTo(GTH(50));
        make.top.equalTo(self.contentView).offset(GTH(44));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = ZTTitleColor;
    self.nameLabel.font = FONT(28);
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(GTW(20));
        make.centerY.equalTo(self.headImageView);
    }];
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = ZTTextLightGrayColor;
    self.dateLabel.font = FONT(24);
    [self.contentView addSubview:self.dateLabel];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(GTW(24));
        make.centerY.equalTo(self.headImageView);
    }];
    
    self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.replyButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    self.replyButton.titleLabel.font = FONT(24);
    [self.replyButton addTarget:self action:@selector(replyButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.replyButton];
    
    [self.replyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.headImageView);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.font = FONT(26);
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(GTW(20));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(40));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(0);
    }];
    
    self.tipView = [[UIView alloc] init];
    self.tipView.backgroundColor = ZTNavColor;
    self.tipView.layer.cornerRadius = GTH(10);
    [self.contentView addSubview:self.tipView];
    
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel);
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(GTH(24));
        make.height.mas_equalTo(0);
    }];
    
    self.tipLabel = [[UILabel alloc] init];
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.textColor = ZTTextLightGrayColor;
    self.tipLabel.font = FONT(22);
    [self.contentView addSubview:self.tipLabel];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipView.mas_left).offset(GTW(50));
        make.right.equalTo(self.tipView.mas_right).offset(GTW(-50));
        make.height.mas_equalTo(0);
        make.top.equalTo(self.tipView.mas_top).offset(GTH(15));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.headImageView);
        make.right.equalTo(self.replyButton);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
    }];
    
}

- (void)replyButtonAction
{
    if ([self.delegate respondsToSelector:@selector(replyButtonWithCell:)]) {
        [self.delegate replyButtonWithCell:self];
    }
}



@end
