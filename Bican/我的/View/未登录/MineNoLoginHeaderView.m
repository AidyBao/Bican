//
//  MineNoLoginHeaderView.m
//  Bican
//
//  Created by bican on 2018/1/2.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MineNoLoginHeaderView.h"

@interface MineNoLoginHeaderView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *loginLabel;
@property (nonatomic, strong) UIImageView *pushImage;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *corpusButton;
@property (nonatomic, strong) UILabel *corpusLabel;
@property (nonatomic, strong) UILabel *corpusCountLabel;

@property (nonatomic, strong) UIButton *draftButton;
@property (nonatomic, strong) UILabel *draftLabel;
@property (nonatomic, strong) UILabel *draftCountLabel;

@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UILabel *focusCountLabel;

@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *receivedButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MineNoLoginHeaderView

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
    self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode-bg"]];
    [self addSubview:self.backImageView];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(GTH(281));
    }];

    self.headerImage = [[UIImageView alloc] init];
    self.headerImage.image = [UIImage imageNamed:@"yaoqingguo_wode"];
    self.headerImage.layer.cornerRadius = GTH(120) / 2;
    self.headerImage.layer.masksToBounds = YES;
    [self addSubview:self.headerImage];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(28));
        make.centerY.equalTo(self.backImageView);
        make.size.mas_equalTo(CGSizeMake(GTH(120), GTH(120)));
    }];
    
    self.loginLabel = [[UILabel alloc] init];
    self.loginLabel.textColor = ZTTitleColor;
    self.loginLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(40)];
    self.loginLabel.text = @"立刻登录";
    [self addSubview:self.loginLabel];
    
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(GTW(28));
        make.centerY.equalTo(self.headerImage);
    }];
    
    self.pushImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode-link-icon"]];
    [self addSubview:self.pushImage];
    
    [self.pushImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(GTW(-28));
        make.centerY.equalTo(self.headerImage);
    }];
    
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = GTH(27);
    [self addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.headerImage.mas_bottom).offset(GTH(54));
        make.height.mas_equalTo(GTH(159));
    }];
    
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [topButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    topButton.tag = 1001;
    [self addSubview:topButton];

    [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.backImageView);
        make.bottom.equalTo(self.contentView.mas_top);
    }];
    
    //文集
    self.corpusCountLabel = [[UILabel alloc] init];
    self.corpusCountLabel.textColor = ZTTitleColor;
    self.corpusCountLabel.text = @"0";
    self.corpusCountLabel.textAlignment = NSTextAlignmentCenter;
    self.corpusCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(52)];
    [self addSubview:self.corpusCountLabel];

    [self.corpusCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top).offset(GTH(40));
        make.height.mas_equalTo(GTH(40));
        make.width.mas_equalTo(ScreenWidth / 3);
    }];

    self.corpusLabel = [[UILabel alloc] init];
    self.corpusLabel.textColor = ZTTextGrayColor;
    self.corpusLabel.text = @"文集";
    self.corpusLabel.textAlignment = NSTextAlignmentCenter;
    self.corpusLabel.font = FONT(26);
    [self addSubview:self.corpusLabel];

    [self.corpusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.corpusCountLabel.mas_bottom).offset(GTH(22));
        make.left.width.equalTo(self.corpusCountLabel);
        make.height.mas_equalTo(GTH(26));
    }];

    self.corpusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.corpusButton setTag:1002];
    [self.corpusButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.corpusButton];

    [self.corpusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.corpusCountLabel);
        make.top.equalTo(self.corpusCountLabel.mas_top);
        make.bottom.equalTo(self.corpusLabel);
    }];

    //草稿
    self.draftCountLabel = [[UILabel alloc] init];
    self.draftCountLabel.textColor = ZTTitleColor;
    self.draftCountLabel.text = @"0";
    self.draftCountLabel.textAlignment = NSTextAlignmentCenter;
    self.draftCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(52)];
    [self addSubview:self.draftCountLabel];

    [self.draftCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.corpusCountLabel.mas_right);
        make.top.height.width.equalTo(self.corpusCountLabel);
    }];

    self.draftLabel = [[UILabel alloc] init];
    self.draftLabel.textColor = ZTTextGrayColor;
    self.draftLabel.text = @"草稿";
    self.draftLabel.textAlignment = NSTextAlignmentCenter;
    self.draftLabel.font = FONT(26);
    [self addSubview:self.draftLabel];

    [self.draftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.corpusLabel);
        make.left.right.equalTo(self.draftCountLabel);
    }];

    self.draftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.draftButton setTag:1003];
    [self.draftButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.draftButton];

    [self.draftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.corpusButton.mas_right);
        make.top.height.width.equalTo(self.corpusButton);
    }];

    //关注
    self.focusCountLabel = [[UILabel alloc] init];
    self.focusCountLabel.textColor = ZTTitleColor;
    self.focusCountLabel.text = @"0";
    self.focusCountLabel.textAlignment = NSTextAlignmentCenter;
    self.focusCountLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(52)];
    [self addSubview:self.focusCountLabel];

    [self.focusCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.draftCountLabel);
        make.left.equalTo(self.draftCountLabel.mas_right);
    }];

    self.focusLabel = [[UILabel alloc] init];
    self.focusLabel.textColor = ZTTextGrayColor;
    self.focusLabel.text = @"关注";
    self.focusLabel.textAlignment = NSTextAlignmentCenter;
    self.focusLabel.font = FONT(26);
    [self addSubview:self.focusLabel];

    [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.draftLabel);
        make.left.right.equalTo(self.focusCountLabel);
    }];

    self.focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.focusButton setTag:1004];
    [self.focusButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.focusButton];
    
    [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.focusCountLabel);
        make.bottom.equalTo(self.focusLabel);
    }];

    CGFloat button_width = (ScreenWidth - GTW(30) * 3) / 2;
    
    //发出的邀请
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发出的邀请" forState:UIControlStateNormal];
    self.sendButton.layer.cornerRadius = GTH(20);
    [self.sendButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    [self.sendButton setBackgroundColor:RGBA(250, 250, 250, 1)];
    self.sendButton.adjustsImageWhenHighlighted = NO;
    self.sendButton.titleLabel.font = FONT(30);
    [self.sendButton setImage:[UIImage imageNamed:@"fachu-icon"] forState:UIControlStateNormal];
    [self.sendButton setTag:1005];
    self.sendButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.sendButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GTW(100)];
    [self.sendButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendButton];

    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.top.equalTo(self.contentView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(button_width, GTH(160)));
    }];

    //收到的邀请
    self.receivedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.receivedButton setTitle:@"收到的邀请" forState:UIControlStateNormal];
    [self.receivedButton setImage:[UIImage imageNamed:@"shoudao-icon"] forState:UIControlStateNormal];
    [self.receivedButton setTag:1006];
    self.receivedButton.layer.cornerRadius = GTH(20);
    self.receivedButton.titleLabel.font = FONT(30);
    [self.receivedButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    [self.receivedButton setBackgroundColor:RGBA(250, 250, 250, 1)];
    self.receivedButton.adjustsImageWhenHighlighted = NO;
    [self.receivedButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.receivedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.receivedButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GTW(100)];
    [self addSubview:self.receivedButton];

    [self.receivedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendButton.mas_right).offset(GTW(30));
        make.top.equalTo(self.sendButton);
        make.size.mas_equalTo(CGSizeMake(button_width, GTH(160)));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(28));
        make.width.mas_equalTo(ScreenWidth - GTW(28) * 2);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

- (void)buttonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(pushToVCWithTag:)]) {
        [self.delegate pushToVCWithTag:button.tag];
    }
    
}




@end
