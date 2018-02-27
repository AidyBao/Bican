

//
//  BindPhoneViewController.m
//  Bican
//
//  Created by bican on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "BindNewPhoneViewController.h"

@interface BindPhoneViewController ()

@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UILabel *bindLabel;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UIButton *footerButton;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定手机号";
    [self createSubViews];
    
}

- (void)createSubViews
{
    UserInformation *user = [GetUserInfo getUserInfoModel];
    self.phoneNumberLabel = [[UILabel alloc] init];
    self.phoneNumberLabel.textColor = ZTTitleColor;
    NSString *mobile = [self formatPhoneNumber:user.mobile];
    self.phoneNumberLabel.text = mobile;
    self.phoneNumberLabel.font = FONT(28);
    [self.view addSubview:self.phoneNumberLabel];
    
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.top.equalTo(self.view.mas_top).offset(GTH(50) + NAV_HEIGHT);
        make.height.mas_equalTo(GTH(40));
    }];
    
    self.bindLabel = [[UILabel alloc] init];
    self.bindLabel.textColor = ZTTextGrayColor;
    self.bindLabel.text = @"已绑定手机号码";
    self.bindLabel.font = FONT(24);
    [self.view addSubview:self.bindLabel];

    [self.bindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(GTW(-28));
        make.top.equalTo(self.view.mas_top).offset(GTH(50) + NAV_HEIGHT);
        make.height.mas_equalTo(GTH(30));
    }];
    
    self.bottomLineView = [[UILabel alloc] init];
    self.bottomLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.bottomLineView];

    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumberLabel.mas_bottom).offset(GTH(50));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    self.footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footerButton setBackgroundColor:ZTOrangeColor];
    [self.footerButton setTitle:@"绑定新手机号" forState:UIControlStateNormal];
    self.footerButton.titleLabel.font = FONT(30);
    [self.footerButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.footerButton.adjustsImageWhenHighlighted = NO;
    [self.footerButton addTarget:self action:@selector(footerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footerButton];

    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(GTH(96));
    }];
}


- (void)footerButtonAction
{
    BindNewPhoneViewController *bindNewPhoneVC = [[BindNewPhoneViewController alloc] init];
    [self pushVC:bindNewPhoneVC animated:YES IsNeedLogin:YES];
}

@end
