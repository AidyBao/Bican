//
//  ClearHistoryView.m
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ClearHistoryView.h"

@interface ClearHistoryView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@end

@implementation ClearHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = RGBA(0, 0, 0, 0.1);
    [self addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(ScreenHeight);
    }];
    
    self.centerView = [[UIView alloc] init];
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.layer.cornerRadius = GTH(20);
    [self addSubview:self.centerView];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(128));
        make.right.equalTo(self.mas_right).offset(GTW(-128));
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(GTH(210));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"清空历史记录 ?";
    self.titleLabel.font = FONT(28);
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(GTW(34));
        make.right.equalTo(self.centerView.mas_right).offset(GTW(-34));
        make.top.equalTo(self.centerView.mas_top).offset(GTH(50));
    }];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.leftButton setBackgroundColor:RGBA(221, 221, 221, 1)];
    self.leftButton.titleLabel.font = FONT(28);
    self.leftButton.layer.cornerRadius = GTH(10);
    [self.leftButton addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.leftButton];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(37));
        make.width.mas_equalTo((ScreenWidth - GTW(128) * 2 - GTW(34) * 2 - GTW(40)) / 2);
        make.height.mas_equalTo(GTH(65));
    }];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setBackgroundColor:ZTOrangeColor];
    self.rightButton.titleLabel.font = FONT(28);
    self.rightButton.layer.cornerRadius = GTH(10);
    [self.rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.rightButton];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.top.equalTo(self.leftButton);
        make.left.equalTo(self.leftButton.mas_right).offset(GTW(40));
    }];
    
}

- (void)leftButtonAction
{
    [self removeFromSuperview];
}

- (void)rightButtonAction
{
    if ([self.delegate respondsToSelector:@selector(toClearAllHistoryData)]) {
        [self.delegate toClearAllHistoryData];
    }
    [self removeFromSuperview];
}


@end
