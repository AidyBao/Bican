//
//  CommentConclusionTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/27.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CommentConclusionTableViewCell.h"

@interface CommentConclusionTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleLineView;

@property (nonatomic, strong) UILabel *basiceLabel;
@property (nonatomic, strong) UILabel *basiceContentLabel;
@property (nonatomic, strong) UIView *basiceLineView;

@property (nonatomic, strong) UILabel *developLabel;
@property (nonatomic, strong) UILabel *developContentLabel;
@property (nonatomic, strong) UIView *developLineView;

@property (nonatomic, strong) UILabel *fractionLabel;
@property (nonatomic, strong) UILabel *fractionCountLabel;

@end

@implementation CommentConclusionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setCommentConclusionCellWithTeacherName:(NSString *)teacherName
                                       NickName:(NSString *)nickName
                                          Basic:(NSString *)basic
                                    Development:(NSString *)development
                                       Fraction:(NSString *)fraction
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@(%@)的总评:", teacherName, nickName];
    self.basiceContentLabel.text = basic;
    self.developContentLabel.text = development;
    if (fraction.length != 0) {
        self.fractionCountLabel.text = [NSString stringWithFormat:@"%@分", fraction];
    }

}

- (void)createSubViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = FONT(28);
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        make.height.mas_equalTo(GTH(44));
        make.top.equalTo(self.contentView).offset(GTH(30));
    }];

    self.titleLineView = [[UIView alloc] init];
    self.titleLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.titleLineView];
    
    [self.titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(1);
    }];
    
    self.basiceLabel = [[UILabel alloc] init];
    self.basiceLabel.text = @"基础等级";
    self.basiceLabel.font = FONT(28);
    self.basiceLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.basiceLabel];
    
    [self.basiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.titleLineView);
        make.top.equalTo(self.titleLineView.mas_bottom).offset(GTH(30));
    }];
    
    self.basiceContentLabel = [[UILabel alloc] init];
    self.basiceContentLabel.font = FONT(24);
    self.basiceContentLabel.numberOfLines = 0;
    self.basiceContentLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.basiceContentLabel];
    
    [self.basiceContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.basiceLabel);
        make.top.equalTo(self.basiceLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.basiceLineView = [[UIView alloc] init];
    self.basiceLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.basiceLineView];
    
    [self.basiceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.width.equalTo(self.titleLineView);
        make.top.equalTo(self.basiceContentLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.developLabel = [[UILabel alloc] init];
    self.developLabel.text = @"发展等级";
    self.developLabel.font = FONT(28);
    self.developLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.developLabel];
    
    [self.developLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.basiceLineView);
        make.top.equalTo(self.basiceLineView.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(GTH(44));
    }];
    
    self.developContentLabel = [[UILabel alloc] init];
    self.developContentLabel.font = FONT(24);
    self.developContentLabel.numberOfLines = 0;
    self.developContentLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.developContentLabel];
    
    [self.developContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.developLabel);
        make.top.equalTo(self.developLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.developLineView = [[UIView alloc] init];
    self.developLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.developLineView];
    
    [self.developLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.left.width.equalTo(self.titleLineView);
        make.top.equalTo(self.developContentLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.fractionLabel = [[UILabel alloc] init];
    self.fractionLabel.text = @"评分";
    self.fractionLabel.font = FONT(28);
    self.fractionLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.fractionLabel];
    
    [self.fractionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLineView);
        make.height.mas_equalTo(GTH(44));
        make.top.equalTo(self.developLineView.mas_bottom).offset(GTH(30));
    }];
    
    self.fractionCountLabel = [[UILabel alloc] init];
    self.fractionCountLabel.font = FONT(28);
    self.fractionCountLabel.textColor = ZTOrangeColor;
    [self.contentView addSubview:self.fractionCountLabel];
    
    [self.fractionCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLineView);
        make.height.mas_equalTo(GTH(44));
        make.top.equalTo(self.developLineView.mas_bottom).offset(GTH(30));
    }];

}

@end
