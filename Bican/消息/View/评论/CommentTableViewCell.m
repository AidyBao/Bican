//
//  CommentTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *checkLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setCommentCellIsShowWarning:(BOOL)isShowWarning
{
    if (isShowWarning) {
        self.redView.hidden = NO;
    } else {
        self.redView.hidden = YES;
    }
}

- (void)setsetCommentCellWithHeadImage:(NSString *)headImage
                                 Title:(NSString *)title
                                  Date:(NSString *)date
                                  Name:(NSString *)name
                               Content:(NSString *)content
{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"sousuo_xiaoxi"]];
    self.titleLabel.text = title;
    self.dateLabel.text = date;
    self.nameLabel.text = name;
    self.contentLabel.text = content;
    
}

- (void)createSubViews
{
    CGFloat label_width = (ScreenWidth - GTW(30) * 4 - GTH(78)) / 2;
    
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.backgroundColor = ZTOrangeColor;
    self.headImageView.layer.cornerRadius = GTH(78) / 2;
    self.headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headImageView];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.top.equalTo(self.contentView).offset(GTH(20));
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
        make.width.mas_equalTo(label_width);
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = FONT(26);
    self.nameLabel.textColor = ZTTitleColor;
    self.nameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(label_width);
        make.top.equalTo(self.contentView).offset(GTH(20));
        make.left.equalTo(self.headImageView.mas_right).offset(GTW(30));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.font = FONT(24);
    self.contentLabel.numberOfLines = 3;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTextGrayColor;
    self.titleLabel.font = FONT(24);
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.equalTo(self.dateLabel);
        make.top.equalTo(self.contentLabel);
    }];
    
    self.checkLabel = [[UILabel alloc] init];
    self.checkLabel.text = @"查看详情";
    self.checkLabel.font = FONT(24);
    self.checkLabel.textColor = [UIColor colorWithRed:0.22 green:0.56 blue:0.98 alpha:1.00];
    [self.contentView addSubview:self.checkLabel];
    
    [self.checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(GTH(20));
        make.left.equalTo(self.contentLabel);
        make.height.mas_equalTo(GTH(30));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.headImageView);
        make.right.equalTo(self.dateLabel);
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
