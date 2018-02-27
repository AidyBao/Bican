//
//  AccountsTableViewCell.m
//  Bican
//
//  Created by bican on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "AccountsTableViewCell.h"

@interface AccountsTableViewCell ()

@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIImageView *pushImage;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation AccountsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createTableView];
    }
    return self;
}


- (void)createTableView
{
    self.headerLabel = [[UILabel alloc] init];
    self.headerLabel.textColor = ZTTitleColor;
    self.headerLabel.font = FONT(28);
    self.headerLabel.text = @"头像";
    [self.contentView addSubview:self.headerLabel];
    
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.height.equalTo(self.contentView);
    }];
    
    self.pushImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode-link-icon"]];
    [self.contentView addSubview:self.pushImage];
    
    [self.pushImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(50));
        make.size.mas_equalTo(CGSizeMake(GTW(20), GTH(30)));
    }];
    
    self.headerImage = [[UIImageView alloc] init];
    self.headerImage.image = [UIImage imageNamed:@"my_header"];
    self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImage.layer.cornerRadius = GTH(90) / 2;
    self.headerImage.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headerImage];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pushImage.mas_left).offset(GTW(-17));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(21));
        make.size.mas_equalTo(CGSizeMake(GTH(90), GTH(90)));
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
