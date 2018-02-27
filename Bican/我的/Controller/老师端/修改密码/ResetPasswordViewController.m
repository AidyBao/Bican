//
//  ResetPasswordViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/30.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "AccountsViewController.h"
#import "MineLoginViewController.h"

@interface ResetPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *suggestLabel;
@property (nonatomic, strong) UILabel *PasswordLabel;
@property (nonatomic, strong) UILabel *PasswordAgainLabel;
@property (nonatomic, strong) UILabel *hintLabel;
@property (nonatomic, strong) UILabel *disaffinityLabel;

@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UITextField *passwordAgainText;
@property (nonatomic, strong) UIButton *sureButton;


@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重置密码";
    [self createSubViews];
}

- (void)createSubViews
{
    self.suggestLabel = [[UILabel alloc] init];
    self.suggestLabel.font = FONT(24);
    self.suggestLabel.textColor = ZTTextGrayColor;
    self.suggestLabel.text = @"建议密码由6~18位字母或数字组成";
    [self.view addSubview:self.suggestLabel];
    
    [self.suggestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(88));
        make.top.equalTo(self.view.mas_top).offset(GTH(54) + NAV_HEIGHT);
        make.height.mas_equalTo(GTH(24));
    }];
    
    self.PasswordLabel = [[UILabel alloc] init];
    self.PasswordLabel.textColor = ZTTextLightGrayColor;
    self.PasswordLabel.font = FONT(24);
    self.PasswordLabel.text = @"新密码";
    [self.view addSubview:self.PasswordLabel];
    
    [self.PasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(88));
        make.top.equalTo(self.suggestLabel.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(GTH(24));
    }];
    
    self.passwordText = [[UITextField alloc] init];
    self.passwordText.placeholder = @"请输入新密码";
    self.passwordText.borderStyle = UITextBorderStyleNone;
    self.passwordText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.passwordText.layer.borderWidth = 1.0f;
    self.passwordText.secureTextEntry = YES;
    self.passwordText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordText.delegate = self;
    self.passwordText.font = FONT(24);
    self.passwordText.textColor = ZTTitleColor;
    [self.passwordText setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordText setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.passwordText];
    
    [self.passwordText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(88));
        make.top.equalTo(self.PasswordLabel.mas_bottom).offset(GTH(34));
        make.size.mas_equalTo(CGSizeMake(GTW(546), GTH(78)));
    }];
    
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.textColor = ZTRedColor;
    self.hintLabel.font = FONT(24);
    self.hintLabel.hidden = YES;
    self.hintLabel.text = @"请输入6~18位，字母或数字组成的密码";
    [self.view addSubview:self.hintLabel];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(88));
        make.top.equalTo(self.passwordText.mas_bottom).offset(GTH(16));
        make.height.mas_equalTo(GTH(24));
    }];
    
    self.PasswordAgainLabel = [[UILabel alloc] init];
    self.PasswordAgainLabel.textColor = ZTTextLightGrayColor;
    self.PasswordAgainLabel.font = FONT(24);
    self.PasswordAgainLabel.text = @"再次输入新密码";
    [self.view addSubview:self.PasswordAgainLabel];
    
    [self.PasswordAgainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(88));
        make.top.equalTo(self.passwordText.mas_bottom).offset(GTH(70));
        make.height.mas_equalTo(GTH(24));
    }];
    
    self.passwordAgainText = [[UITextField alloc] init];
    self.passwordAgainText.placeholder = @"请再次输入新密码";
    self.passwordAgainText.borderStyle = UITextBorderStyleNone;
    self.passwordAgainText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.passwordAgainText.layer.borderWidth = 1.0f;
    self.passwordAgainText.secureTextEntry = YES;
    self.passwordAgainText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordAgainText.delegate = self;
    self.passwordAgainText.font = FONT(24);
    self.passwordAgainText.textColor = ZTTitleColor;
    [self.passwordAgainText setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordAgainText setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.passwordAgainText];
    
    [self.passwordAgainText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(88));
        make.top.equalTo(self.PasswordAgainLabel.mas_bottom).offset(GTH(34));
        make.size.mas_equalTo(CGSizeMake(GTW(546), GTH(78)));
    }];
    
    self.disaffinityLabel = [[UILabel alloc] init];
    self.disaffinityLabel.textColor = ZTRedColor;
    self.disaffinityLabel.font = FONT(24);
    self.disaffinityLabel.hidden = YES;
    self.disaffinityLabel.text = @"两次输入的密码不相同";
    [self.view addSubview:self.disaffinityLabel];
    
    [self.disaffinityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(88));
        make.top.equalTo(self.passwordAgainText.mas_bottom).offset(GTH(16));
        make.height.mas_equalTo(GTH(24));
    }];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:ZTTextLightGrayColor];
    self.sureButton.userInteractionEnabled = NO;
    self.sureButton.titleLabel.font = FONT(36);
    self.sureButton.layer.cornerRadius = GTH(10);
    [self.sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordAgainText.mas_bottom).offset(GTH(300));
        make.left.equalTo(self.view.mas_left).offset(GTW(34));
        make.right.equalTo(self.view.mas_right).offset(GTW(-34));
        make.height.mas_equalTo(GTH(88));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.passwordText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.passwordAgainText];
    
}


- (void)textFieldChanged:(NSNotification *)notification
{
    self.hintLabel.hidden = YES;
    self.disaffinityLabel.hidden = YES;
    self.passwordText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.passwordAgainText.layer.borderColor = ZTLineGrayColor.CGColor;
    
    if (self.passwordText.text.length != 0 && self.passwordAgainText.text.length != 0) {
        [self.sureButton setBackgroundColor:ZTOrangeColor];
        self.sureButton.userInteractionEnabled = YES;
    } else {
        [self.sureButton setBackgroundColor:ZTTextLightGrayColor];
        self.sureButton.userInteractionEnabled = NO;
    }
    
    
}

- (void)sureButtonAction
{
    //判断密码是否为空
    if ([NSString isEmptyOrWhitespace:self.passwordText.text]) {
        self.hintLabel.hidden = NO;
        self.passwordText.layer.borderColor = ZTRedColor.CGColor;
        return;
    }
    //判断位数是否小于6位
    if (self.passwordText.text.length < 6 || self.passwordText.text.length > 18) {
        self.hintLabel.hidden = NO;
        self.passwordText.layer.borderColor = ZTRedColor.CGColor;
        return;
    }

    //验证密码是否相同
    if (self.passwordText.text != self.passwordAgainText.text) {
        self.disaffinityLabel.hidden = NO;
        self.passwordAgainText.layer.borderColor = ZTRedColor.CGColor;
        return;
    }
   
    self.hintLabel.hidden = YES;
    self.disaffinityLabel.hidden = YES;
    
    self.passwordText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.passwordAgainText.layer.borderColor = ZTLineGrayColor.CGColor;
    
    self.sureButton.userInteractionEnabled = YES;
    [self.sureButton setBackgroundColor:ZTOrangeColor];
    
    //重置密码
    [self findPwd];
    

}

#pragma mark - 重置密码
- (void)findPwd
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.telStr forKey:@"tel"];
    [params setValue:self.authCodeStr forKey:@"authCode"];
    [params setValue:self.passwordText.text forKey:@"password"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/findPwd", BASE_URL];

    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {

        NSString *msg = [resultObject objectForKey:@"msg"];

        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //跳转到账户页面
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[MineLoginViewController class]]) {
                [self popToVC:VC animated:YES];
                return;
            }
        }
        MineLoginViewController *accountsVC = [[MineLoginViewController alloc] init];
        [self pushVC:accountsVC animated:YES IsNeedLogin:YES];
        
    } errorHandler:^(NSError *error) {


    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    

}

#pragma mark - UITextField的协议方法
//点击return键,取消键盘第一响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.passwordText resignFirstResponder];
    [self.passwordAgainText resignFirstResponder];

    return YES;
}

//点击空白处,取消键盘第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.passwordText resignFirstResponder];
    [self.passwordAgainText resignFirstResponder];
    
}


@end
