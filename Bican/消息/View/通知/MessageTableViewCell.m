//
//  MessageTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MessageTableViewCell.h"

@interface MessageTableViewCell ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setMessageCellWithImage:(NSString *)image
                          Title:(NSString *)title
                          Count:(NSString *)count
           CountBackgroundColor:(UIColor *)countBackgroundColor
{
    self.leftImageView.image = [UIImage imageNamed:image];
    self.titleLabel.text = title;
    if (count.length != 0) {
        if ([count isEqualToString:@"0"]) {
            self.countLabel.hidden = YES;
        } else {
            self.countLabel.hidden = NO;
            self.countLabel.text = count;
            self.countLabel.backgroundColor = countBackgroundColor;
        }
    } else {
        self.countLabel.hidden = YES;
    }
    
}

- (void)createSubViews
{
    self.leftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.leftImageView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.top.equalTo(self.contentView).offset(GTH(20));
        make.width.height.mas_equalTo(GTH(78));
    }];
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.font = FONT(18);
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.layer.cornerRadius = GTH(35) / 2;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:self.countLabel];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(GTW(-30));
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(GTH(35));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = FONT(28);
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftImageView.mas_right).offset(GTW(20));
        make.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-1);
        make.right.equalTo(self.countLabel.mas_left).offset(GTW(-20));
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
