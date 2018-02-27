
//
//  RecommendTableViewCell.m
//  Bican
//
//  Created by bican on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "RecommendTableViewCell.h"

@interface RecommendTableViewCell ()

@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation RecommendTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}


- (void)createRecommendTableViewWithNickname:(NSString *)nickname
                                 BigTypeName:(NSString *)bigTypeName
                               RecommendDate:(NSString *)recommendDate
                                ArticleTitle:(NSString *)articleTitle
{
    self.authorLabel.text = nickname;
    self.typeLabel.text = bigTypeName;
    self.dateLabel.text = [NSString stringWithFormat:@"%@ 推荐", recommendDate];
    self.titleLabel.text = [NSString stringWithFormat:@"《%@》", articleTitle];;
}

- (void)createSubViews
{
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.textColor = ZTTextLightGrayColor;
    self.authorLabel.font = FONT(24);
    [self.authorLabel sizeToFit];
    [self.contentView addSubview:self.authorLabel];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(24));
        make.height.mas_equalTo(GTH(26));
    }];
    
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = ZTTextLightGrayColor;
    self.typeLabel.font = FONT(24);
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.authorLabel.mas_right).offset(GTW(20));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(24));
        make.height.mas_equalTo(GTH(26));
    }];
    
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = FONT(28);
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(28));
        make.right.equalTo(self.contentView).offset(GTW(-80));
        make.top.equalTo(self.authorLabel.mas_bottom).offset(GTH(24));
        make.height.mas_equalTo(GTH(36));
    }];
    
    
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.textColor = ZTTextLightGrayColor;
    self.dateLabel.font = FONT(24);
    [self.contentView addSubview:self.dateLabel];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(24));
        make.height.mas_equalTo(GTH(26));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(1);
    }];
    
    
}


@end

