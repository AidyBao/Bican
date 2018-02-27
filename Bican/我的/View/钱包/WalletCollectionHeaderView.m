//
//  WalletCollectionHeaderView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/6.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "WalletCollectionHeaderView.h"

@interface WalletCollectionHeaderView ()

@property (nonatomic, strong) UIButton *returnButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *wenbiLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UIButton *rechargeButton;

@end

@implementation WalletCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setWenbiText:(NSString *)wenbiText
{
    self.wenbiLabel.text = wenbiText;
}

- (void)createSubViews
{
    self.returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.returnButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    self.returnButton.tag = 11222;
    [self.returnButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.returnButton];

    [self.returnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(28));
        make.top.equalTo(self.mas_top).offset(GTH(80));
        make.height.mas_equalTo(GTH(34));
    }];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = FONT(32);
    self.titleLabel.text = @"钱包";
    [self addSubview:self.titleLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.height.equalTo(self.returnButton);
    }];

    self.wenbiLabel = [[UILabel alloc] init];
    self.wenbiLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [self addSubview:self.wenbiLabel];

    [self.wenbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(56));
    }];

    self.balanceLabel = [[UILabel alloc] init];
    self.balanceLabel.textColor = ZTTitleColor;
    self.balanceLabel.font = FONT(28);
    self.balanceLabel.text = @"账户余额";
    [self addSubview:self.balanceLabel];

    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.titleLabel);
        make.top.equalTo(self.wenbiLabel.mas_bottom).offset(GTH(18));
    }];

    self.rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    [self.rechargeButton setTitle:@"去充值" forState:UIControlStateNormal];
    [self.rechargeButton setBackgroundColor:[UIColor whiteColor]];
    self.rechargeButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    self.rechargeButton.tag = 22111;
    self.rechargeButton.layer.cornerRadius = GTH(30);
    [self.rechargeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rechargeButton];

    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(260));
        make.right.equalTo(self.mas_right).offset(GTW(-260));
//        make.centerX.equalTo(self.titleLabel);
        make.top.equalTo(self.balanceLabel.mas_bottom).offset(GTH(42));
    }];
    
}

- (void)buttonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(pushToVCWithTag:)]) {
        [self.delegate pushToVCWithTag:button.tag];
    }
    
}

@end
