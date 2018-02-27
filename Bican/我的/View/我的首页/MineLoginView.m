//
//  MineLoginView.m
//  Bican
//
//  Created by bican on 2018/1/3.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MineLoginView.h"

@interface MineLoginView () <UITextFieldDelegate>

@end

@implementation MineLoginView

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
    self.userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_icon"]];
    [self addSubview:self.userImage];
    
    [self.userImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(28));
        make.top.equalTo(self.mas_top).offset(GTH(50));
        make.size.mas_equalTo(CGSizeMake(GTH(27), GTH(27)));
    }];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneTextField.placeholder = @"请输入手机号";
    self.phoneTextField.font = FONT(28);
    self.phoneTextField.textColor = ZTTitleColor;
    self.phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneTextField.delegate = self;
    [self.phoneTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneTextField setValue:FONT(28) forKeyPath:@"_placeholderLabel.font"];
    [self addSubview:self.phoneTextField];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImage.mas_right).offset(GTW(35));
        make.top.height.equalTo(self.userImage);
        make.right.equalTo(self.mas_right).offset(GTW(-28));
    }];
    
    self.phoneLineView = [[UIView alloc] init];
    self.phoneLineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.phoneLineView];
    
    [self.phoneLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(28));
        make.right.equalTo(self.mas_right).offset(GTW(-28));
        make.top.equalTo(self.userImage.mas_bottom).offset(GTH(28));
        make.height.mas_equalTo(1);
    }];
    
    self.passwordImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password_icon"]];
    [self addSubview:self.passwordImage];
    
    [self.passwordImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(28));
        make.top.equalTo(self.phoneLineView.mas_bottom).offset(GTH(50));
        make.size.mas_equalTo(CGSizeMake(GTH(27), GTH(27)));
    }];
    
    
    self.passwordLineView = [[UIView alloc] init];
    self.passwordLineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.passwordLineView];
    
    [self.passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(28));
        make.right.equalTo(self.mas_right).offset(GTW(-28));
        make.top.equalTo(self.passwordImage.mas_bottom).offset(GTH(28));
        make.height.mas_equalTo(1);
    }];
    
    self.visibleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.visibleButton setImage:[UIImage imageNamed:@"eye_close"] forState:UIControlStateNormal];
    [self.visibleButton setImage:[UIImage imageNamed:@"eye_open"] forState:UIControlStateSelected];
    [self.visibleButton addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    self.visibleButton.tag = 10001;
    [self addSubview:self.visibleButton];
    
    [self.visibleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(GTW(-40));
        make.top.equalTo(self.phoneLineView.mas_bottom).offset(GTH(45));
        make.size.mas_equalTo(CGSizeMake(GTH(40), GTH(40)));
    }];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"请输入登录密码";
    self.passwordTextField.font = FONT(28);
    self.passwordTextField.textColor = ZTTitleColor;
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.passwordTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:FONT(28) forKeyPath:@"_placeholderLabel.font"];
    self.passwordTextField.delegate = self;
    [self addSubview:self.passwordTextField];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordImage.mas_right).offset(GTW(35));
        make.top.equalTo(self.passwordImage);
        make.right.equalTo(self.visibleButton.mas_left).offset(GTW(-25));
    }];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:ZTTextLightGrayColor];
    self.loginButton.titleLabel.font = FONT(30);
    self.loginButton.layer.cornerRadius = GTH(20);
    self.loginButton.tag = 10003;
    self.loginButton.userInteractionEnabled = NO;
    [self.loginButton addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.loginButton];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(28));
        make.right.equalTo(self.mas_right).offset(GTW(-28));
        make.top.equalTo(self.passwordLineView.mas_bottom).offset(GTH(100));
        make.height.mas_equalTo(GTH(96));
    }];
    
    self.forgetPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetPasswordButton.titleLabel.font = FONT(24);
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    self.forgetPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.forgetPasswordButton setTitleColor:RGBA(207, 93, 39, 1) forState:UIControlStateNormal];
    self.forgetPasswordButton.tag = 10004;
    [self.forgetPasswordButton addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.forgetPasswordButton];
    
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(248));
        make.bottom.equalTo(self.mas_bottom).offset(GTH(-76));
        make.width.mas_equalTo(GTW(120));
    }];
    
    self.middleView = [[UIView alloc] init];
    self.middleView.backgroundColor = RGBA(207, 93, 39, 1);
    [self addSubview:self.middleView];
    
    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.forgetPasswordButton.mas_right).offset(GTW(4));
        make.centerY.equalTo(self.forgetPasswordButton);
        make.size.mas_equalTo(CGSizeMake(2, GTH(24)));
    }];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerButton setTitleColor:RGBA(207, 93, 39, 1) forState:UIControlStateNormal];
    self.registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    self.registerButton.titleLabel.font = FONT(24);
    [self.registerButton addTarget:self action:@selector(passwordAction:) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton.tag = 10005;
    [self addSubview:self.registerButton];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleView.mas_right).offset(GTW(4));
        make.width.mas_equalTo(GTW(120));
        make.bottom.equalTo(self.mas_bottom).offset(GTH(-76));
    }];
}

- (void)passwordAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(seePasswordAndPushWithTag:Button:)]) {
        [self.delegate seePasswordAndPushWithTag:button.tag Button:button];
    }
}

#pragma mark - UITextField的协议方法
//点击return键,取消键盘第一响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

    return YES;
}

//点击空白处,取消键盘第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
}

@end

