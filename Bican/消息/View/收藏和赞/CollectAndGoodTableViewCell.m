//
//  CollectAndGoodTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CollectAndGoodTableViewCell.h"

@implementation CollectAndGoodTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setCollectAndGoodCellIsShowWarning:(NSString *)isShowWarning
{
    if ([isShowWarning isEqualToString:@"YES"]) {
        self.redView.hidden = NO;
    } else {
        self.redView.hidden = YES;
    }
}


- (void)createSubViews
{
    CGFloat label_width = (ScreenWidth - GTW(30) * 4 - GTH(78)) / 2;
    
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
    
    self.rightTopLabel = [[UILabel alloc] init];
    self.rightTopLabel.textColor = ZTTextLightGrayColor;
    self.rightTopLabel.font = FONT(24);
    self.rightTopLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightTopLabel];
    
    [self.rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(GTW(-30));
        make.top.equalTo(self.contentView).offset(GTH(20));
        make.width.mas_equalTo(label_width);
    }];
    
    self.leftTopLabel = [[UILabel alloc] init];
    self.leftTopLabel.font = FONT(28);
    self.leftTopLabel.textColor = ZTTitleColor;
    self.leftTopLabel.numberOfLines = 0;
    [self.contentView addSubview:self.leftTopLabel];
    
    [self.leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.rightTopLabel);
        make.top.equalTo(self.contentView).offset(GTH(20));
        make.right.equalTo(self.rightTopLabel.mas_left).offset(GTW(-30));
    }];
    
    self.leftBottomLabel = [[UILabel alloc] init];
    self.leftBottomLabel.textColor = ZTTextGrayColor;
    self.leftBottomLabel.font = FONT(24);
    self.leftBottomLabel.numberOfLines = 3;
    self.leftBottomLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.leftBottomLabel];
    
    [self.leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.leftTopLabel);
        make.top.equalTo(self.leftTopLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.rightBottomLabel = [[UILabel alloc] init];
    self.rightBottomLabel.textColor = ZTTextGrayColor;
    self.rightBottomLabel.font = FONT(24);
    self.rightBottomLabel.textAlignment = NSTextAlignmentRight;
    self.rightBottomLabel.numberOfLines = 0;
    self.rightBottomLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.rightBottomLabel];
    
    [self.rightBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.equalTo(self.rightTopLabel);
        make.top.equalTo(self.leftBottomLabel);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.left.equalTo(self.headImageView);
        make.right.equalTo(self.rightTopLabel);
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
