//
//  CollectTableViewCell.m
//  Bican
//
//  Created by bican on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "CollectTableViewCell.h"

@interface CollectTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *userLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CollectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createCollectCellWithCollectTitle:(NSString *)title
                                   School:(NSString *)school
                                     Type:(NSString *)type
                              BigTypeName:(NSString *)bigTypeName
                           MemberNickName:(NSString *)memberNickName
{
    self.titleLabel.text = title;
    self.schoolLabel.text = school;
    self.typeLabel.text = [NSString stringWithFormat:@"%@ | %@", bigTypeName, type];
    self.userLabel.text = memberNickName;
}





- (void)createSubViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = FONT(28);
    self.titleLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(28));
        make.size.mas_equalTo(CGSizeMake(GTW(400), GTH(36)));
    }];
    
    self.schoolLabel = [[UILabel alloc] init];
    self.schoolLabel.font = FONT(24);
    self.schoolLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.schoolLabel];
    
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(20));
        make.size.mas_equalTo(CGSizeMake(GTW(300), GTH(26)));
    }];

    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = ZTTextGrayColor;
    self.typeLabel.font = FONT(24);
    self.typeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(28));
        make.size.mas_equalTo(CGSizeMake(GTW(180), GTH(30)));
    }];

    
    self.userLabel = [[UILabel alloc] init];
    self.userLabel.textColor = ZTTextLightGrayColor;
    self.userLabel.font = FONT(24);
    self.userLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.userLabel];
    
    [self.userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.typeLabel.mas_bottom).offset(GTH(24));
    }];

    self.headerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"soucang_icon"]];
    [self.contentView addSubview:self.headerImage];

    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userLabel.mas_left).offset(GTW(-10));
        make.top.equalTo(self.typeLabel.mas_bottom).offset(GTH(28));
        make.size.mas_equalTo(CGSizeMake(GTH(20), GTH(20)));
    }];

 

    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];

    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}



@end
