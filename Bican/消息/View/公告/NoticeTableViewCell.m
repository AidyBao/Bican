//
//  NoticeTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "NoticeTableViewCell.h"

@interface NoticeTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *picImageView;

@end

@implementation NoticeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)isShowPicImage:(BOOL)isShow Image:(NSString *)image
{
    if (isShow) {
        self.picImageView.hidden = NO;
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"my_header"]];
    } else {
        self.picImageView.hidden = YES;
    }
}

- (void)setNoticeCellWithHeadImage:(NSString *)headImge
                             Title:(NSString *)title
                              Desc:(NSString *)desc
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headImge] placeholderImage:[UIImage imageNamed:@"my_header"]];
    self.titleLabel.text = title;
    if (desc.length != 0) {
        self.descLabel.text = desc;
        self.descLabel.attributedText = [UILabel setLabelSpace:self.descLabel withValue:self.descLabel.text withFont:self.descLabel.font];
        self.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }


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
        make.top.equalTo(self.contentView).offset(GTH(20));
        make.width.height.mas_equalTo(GTH(78));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(28)];
    self.titleLabel.numberOfLines = 2;
    [self.contentView addSubview:self.titleLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(GTW(15));
        make.top.equalTo(self.headImageView);
        make.right.equalTo(self.contentView).offset(GTW(-30));
    }];

    self.descLabel = [[UILabel alloc] init];
    self.descLabel.textColor = ZTTextGrayColor;
    self.descLabel.numberOfLines = 2;
    self.descLabel.font = FONT(24);
    [self.contentView addSubview:self.descLabel];

    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(20));
    }];

    self.picImageView = [[UIImageView alloc] init];
    self.picImageView.layer.cornerRadius = GTH(10);
    self.picImageView.hidden = YES;
    [self.contentView addSubview:self.picImageView];

    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView);
        make.right.equalTo(self.titleLabel);
        make.top.equalTo(self.descLabel.mas_bottom).offset(GTH(20));
        make.height.mas_equalTo(GTH(180));
    }];

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.right.equalTo(self.contentView).offset(GTW(-30));
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    

}



@end
