//
//  LoginViewController.m
//  Bican
//
//  Created by bican on 2018/1/3.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "RegisterViewController.h"
#import "EditPersonalDataViewController.h"

#import "MineWebViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UITextField *phoneNumberText;
@property (nonatomic, strong) UILabel *noPhoneLabel;

@property (nonatomic, strong) UILabel *verificationLabel;
@property (nonatomic, strong) UITextField *verificationText;
@property (nonatomic, strong) UILabel *noVerificationLabel;

@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UILabel *noPasswordLabel;

@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UILabel *agreeLabel;
@property (nonatomic, strong) UIButton *agreementButton;

@property (nonatomic, strong) UIButton *verificationButton;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, assign) NSInteger integerOfTime;//倒计时秒数
@property (nonatomic, strong) NSTimer *timer;//获取验证码倒计时
@property (nonatomic, strong) NSString *isSelectedGetCodeButton;//是否点击过获取验证码

@end

@implementation RegisterViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer setFireDate:[NSDate distantFuture]];
    [self.verificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.verificationButton.userInteractionEnabled = YES;
    [self.verificationButton setBackgroundColor:ZTOrangeColor];
    [self.phoneNumberText resignFirstResponder];
    [self.verificationText resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.verificationText setText:@""];
    [self.passwordTextField setText:@""];
    _timer = nil;
    self.isSelectedGetCodeButton = @"";
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"注册";
    
    //默认:没有点击过验证码
    self.isSelectedGetCodeButton = @"";
    
    [self createSubViews];
}

- (void)createSubViews
{
    self.phoneNumberLabel = [[UILabel alloc] init];
    self.phoneNumberLabel.textColor = ZTTextGrayColor;
    self.phoneNumberLabel.text = @"手机号";
    self.phoneNumberLabel.font = FONT(24);
    [self.view addSubview:self.phoneNumberLabel];
    
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(70));
        make.top.equalTo(self.view.mas_top).offset(GTH(56) + NAV_HEIGHT);
        make.height.mas_equalTo(GTH(24));
    }];
    
    self.phoneNumberText = [[UITextField alloc] init];
    self.phoneNumberText.placeholder = @"可用于登录和找回密码";
    self.phoneNumberText.borderStyle = UITextBorderStyleNone;
    self.phoneNumberText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.phoneNumberText.layer.borderWidth = 1.0f;
    self.phoneNumberText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumberText.keyboardType = UIKeyboardTypeNamePhonePad;
    [self.phoneNumberText setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneNumberText setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    self.phoneNumberText.font = FONT(24);
    self.phoneNumberText.textColor = ZTTitleColor;
    self.phoneNumberText.delegate = self;
    [self.view addSubview:self.phoneNumberText];
    
    [self.phoneNumberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(70));
        make.top.equalTo(self.phoneNumberLabel.mas_bottom).offset(GTH(28));
        make.size.mas_equalTo(CGSizeMake(GTW(582), GTH(78)));
    }];
    

    self.noPhoneLabel = [[UILabel alloc] init];
    self.noPhoneLabel.textColor = ZTRedColor;
    self.noPhoneLabel.font = FONT(24);
    self.noPhoneLabel.hidden = YES;
    [self.view addSubview:self.noPhoneLabel];
    
    [self.noPhoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneNumberText.mas_bottom).offset(GTH(12));
        make.left.right.equalTo(self.phoneNumberText);
    }];
    
    self.verificationLabel = [[UILabel alloc] init];
    self.verificationLabel.textColor = ZTTextGrayColor;
    self.verificationLabel.font = FONT(24);
    self.verificationLabel.text = @"验证码";
    [self.view addSubview:self.verificationLabel];
    
    [self.verificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneNumberLabel.mas_left);
        make.top.equalTo(self.noPhoneLabel.mas_bottom).offset(GTH(24));
    }];
    
    self.verificationText = [[UITextField alloc] init];
    self.verificationText.placeholder = @"手机验证码";
    self.verificationText.keyboardType = UIKeyboardTypeNamePhonePad;
    self.verificationText.borderStyle = UITextBorderStyleNone;
    self.verificationText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verificationText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.verificationText.layer.borderWidth = 1.0f;
    self.verificationText.delegate = self;
    self.verificationText.font = FONT(24);
    self.verificationText.textColor = ZTTitleColor;
    [self.verificationText setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.verificationText setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.verificationText];
    
    [self.verificationText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneNumberText.mas_left);
        make.top.equalTo(self.verificationLabel.mas_bottom).offset(GTH(26));
        make.size.mas_equalTo(CGSizeMake(GTW(302), GTH(78)));
    }];
    
    self.noVerificationLabel = [[UILabel alloc] init];
    self.noVerificationLabel.textColor = ZTRedColor;
    self.noVerificationLabel.font = FONT(24);
    self.noVerificationLabel.hidden = YES;
    [self.view addSubview:self.noVerificationLabel];
    
    [self.noVerificationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationText.mas_bottom).offset(GTH(12));
        make.left.right.equalTo(self.verificationText);
    }];
    
    self.verificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.verificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.verificationButton.adjustsImageWhenHighlighted = NO;
    self.verificationButton.titleLabel.font = FONT(24);
    [self.verificationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.verificationButton setBackgroundColor:ZTTextLightGrayColor];
    self.verificationButton.layer.cornerRadius = GTH(10);
    [self.verificationButton addTarget:self action:@selector(getCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.verificationButton.userInteractionEnabled = NO;
    [self.view addSubview:self.verificationButton];
    
    [self.verificationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verificationText.mas_right).offset(GTW(28));
        make.top.height.equalTo(self.verificationText);
        make.width.mas_equalTo(GTW(174));
    }];
    
    self.passwordLabel = [[UILabel alloc] init];
    self.passwordLabel.text = @"密码";
    self.passwordLabel.textColor = ZTTextGrayColor;
    self.passwordLabel.font = FONT(24);
    [self.view addSubview:self.passwordLabel];
    
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(70));
        make.top.equalTo(self.verificationText.mas_bottom).offset(GTH(72));
        make.height.mas_offset(GTH(30));
    }];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.placeholder = @"请设置登录密码";
    self.passwordTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.layer.borderColor = ZTLineGrayColor.CGColor;
    self.passwordTextField.layer.borderWidth = 1.0f;
    self.passwordTextField.delegate = self;
    self.passwordTextField.textColor = ZTTitleColor;
    [self.passwordTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.passwordTextField setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];    self.passwordTextField.secureTextEntry = YES;
    [self.view addSubview:self.passwordTextField];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneNumberText.mas_left);
        make.top.equalTo(self.passwordLabel.mas_bottom).offset(GTH(26));
        make.size.mas_equalTo(CGSizeMake(GTW(582), GTH(78)));
    }];
    
    self.noPasswordLabel = [[UILabel alloc] init];
    self.noPasswordLabel.textColor = ZTRedColor;
    self.noPasswordLabel.font = FONT(24);
    self.noPasswordLabel.hidden = YES;
    [self.view addSubview:self.noPasswordLabel];
    
    [self.noPasswordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(GTH(12));
        make.left.right.equalTo(self.passwordTextField);
    }];
    
    self.agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreeButton setImage:[UIImage imageNamed:@"choice"] forState:UIControlStateNormal];
    [self.agreeButton setImage:[UIImage imageNamed:@"choice_a"] forState:UIControlStateSelected];
    [self.agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.agreeButton.selected = YES;
    [self.view addSubview:self.agreeButton];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(242));
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(GTH(78));
        make.size.mas_equalTo(CGSizeMake(GTH(26), GTH(26)));
    }];
    
    self.agreeLabel = [[UILabel alloc] init];
    self.agreeLabel.textColor = ZTTextGrayColor;
    self.agreeLabel.font = FONT(24);
    self.agreeLabel.text = @"同意";
    [self.view addSubview:self.agreeLabel];
    
    [self.agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeButton.mas_right).offset(GTW(20));
        make.height.top.bottom.equalTo(self.agreeButton);
    }];
    

    self.agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.agreementButton.titleLabel.font = FONT(24);
    [self.agreementButton setTitle:@"《用户协议》" forState:UIControlStateNormal];
    [self.agreementButton setTitleColor:RGBA(245, 166, 35, 1) forState:UIControlStateNormal];
    [self.agreementButton addTarget:self action:@selector(agreementButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.agreementButton];
    
    [self.agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeLabel.mas_right);
        make.top.height.bottom.equalTo(self.agreeButton);
    }];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerButton setBackgroundColor:ZTTextLightGrayColor];
    self.registerButton.titleLabel.font = FONT(36);
    self.registerButton.layer.cornerRadius = GTH(10);
    [self.registerButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.registerButton.userInteractionEnabled = NO;
    [self.view addSubview:self.registerButton];
    
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeButton.mas_bottom).offset(GTH(32));
        make.left.equalTo(self.view.mas_left).offset(GTW(34));
        make.right.equalTo(self.view.mas_right).offset(GTW(-34));
        make.height.mas_equalTo(GTH(88));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.phoneNumberText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.passwordTextField];

    
}

- (void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textField = [notification object];
    if (textField == self.phoneNumberText) {
        //如果处于倒计时状态下
        if (_integerOfTime > 0) {
            return;
        }
        if (textField.text.length == 0) {
            [self.verificationButton setBackgroundColor:ZTTextLightGrayColor];
            self.verificationButton.userInteractionEnabled = NO;
        } else {
            [self.verificationButton setBackgroundColor:ZTOrangeColor];
            self.verificationButton.userInteractionEnabled = YES;
            self.noPhoneLabel.hidden = YES;
            self.phoneNumberText.layer.borderColor = ZTLineGrayColor.CGColor;
        }

    }
    if (textField == self.passwordTextField) {
        if (textField.text.length == 0) {
            [self.registerButton setBackgroundColor:ZTTextLightGrayColor];
            self.registerButton.userInteractionEnabled = NO;
        } else {
            [self.registerButton setBackgroundColor:ZTOrangeColor];
            self.registerButton.userInteractionEnabled = YES;
        }
    }
}



#pragma mark - 发送短信验证码
- (void)getCodeButtonAction
{
    //判断号码是否为空
    if ([NSString isEmptyOrWhitespace:self.phoneNumberText.text]) {
        self.noPhoneLabel.text = @"请输入手机号";
        self.noPhoneLabel.hidden = NO;
        self.phoneNumberText.layer.borderColor = ZTRedColor.CGColor;
        return;
    }
    if (![NSString isEmptyOrWhitespace:self.phoneNumberText.text]) {
        //验证是否为手机号码
        if (![NSString isValidatePhone:self.phoneNumberText.text]) {
            self.noPhoneLabel.text = @"手机号码不合法";
            self.noPhoneLabel.hidden = NO;
            self.phoneNumberText.layer.borderColor = ZTRedColor.CGColor;
            return;
        }
        
    }
    self.noPhoneLabel.hidden = YES;
    self.phoneNumberText.layer.borderColor = ZTLineGrayColor.CGColor;

    //发送验证码接口
    [self sendAuthCode];
    
}

#pragma mark - 发送验证码接口
- (void)sendAuthCode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.phoneNumberText.text forKey:@"tel"];
    //重新绑定-1，默认(注册)-0
    [params setValue:@"0" forKey:@"isReBind"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/user/sendAuthCode", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        _integerOfTime = 60; //倒计时起始值为60秒
        [self.timer setFireDate:[NSDate distantPast]];
        [MBHUDManager showBriefAlert:@"验证码发送成功"];
        self.verificationButton.userInteractionEnabled = NO;
        [self.verificationButton setBackgroundColor:ZTTextLightGrayColor];
        
    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self sendAuthCode];
        }
    }];
}

#pragma mark - 下一步按钮
- (void)nextButtonAction
{
    //判断号码是否为空
    if ([NSString isEmptyOrWhitespace:self.phoneNumberText.text]) {
        self.noPhoneLabel.text = @"请输入手机号";
        self.noPhoneLabel.hidden = NO;
        self.phoneNumberText.layer.borderColor = ZTRedColor.CGColor;
        return;
    }
    //验证是否为手机号码
    if (![NSString isValidatePhone:self.phoneNumberText.text]) {
        self.noPhoneLabel.text = @"请输入正确的手机号码";
        self.noPhoneLabel.hidden = NO;
        self.phoneNumberText.layer.borderColor = ZTRedColor.CGColor;
        return;
    }
    //判断 - 是否点击获取验证码按钮
    if (self.isSelectedGetCodeButton.length == 0) {
        [MBHUDManager showBriefAlert:@"请先发送验证码 !"];
        return;
    }
    //判断手机验证码是否为空
    if ([NSString isEmptyOrWhitespace:self.verificationText.text]) {
        self.noVerificationLabel.hidden = NO;
        self.noVerificationLabel.text = @"请输入验证码";
        self.verificationText.layer.borderColor = ZTRedColor.CGColor;
        return;
    }
    //判断密码是否为空
    if ([NSString isEmptyOrWhitespace:self.passwordTextField.text]) {
        self.noPasswordLabel.hidden = NO;
        self.noPasswordLabel.text = @"请输入登录密码";
        self.passwordTextField.layer.borderColor = ZTRedColor.CGColor;
        return;
    }
    //是否同意用户协议
    if (!self.agreeButton.selected) {
        self.registerButton.userInteractionEnabled = NO;
        [self.registerButton setBackgroundColor:ZTTextLightGrayColor];
    }
    self.noPhoneLabel.hidden = YES;
    self.noVerificationLabel.hidden = YES;
    self.noPasswordLabel.hidden = YES;
    
    self.verificationText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.phoneNumberText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.passwordTextField.layer.borderColor = ZTLineGrayColor.CGColor;
    
    self.registerButton.userInteractionEnabled = YES;
    [self.registerButton setBackgroundColor:ZTOrangeColor];
    
    //调用注册接口
    [self gotoRegister];
    
}

#pragma mark - 注册接口验证
- (void)gotoRegister
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.phoneNumberText.text forKey:@"tel"];
    [params setValue:self.passwordTextField.text forKey:@"password"];
    [params setValue:self.verificationText.text forKey:@"authCode"];
    [params setValue:@"-1" forKey:@"userId"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/register", BASE_URL];

    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {

        NSString *msg = [resultObject objectForKey:@"msg"];

        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //注册成功之后-跳转编辑个人信息页面(选择身份页面暂时隐藏!!!!!!)
        EditPersonalDataViewController *editPersonalDataVC = [[EditPersonalDataViewController alloc] init];
        [self pushVC:editPersonalDataVC animated:YES IsNeedLogin:YES];
        
    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {

    }];
}

- (void)dealloc
{
    _timer = nil;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countdownForGetValidateCode) userInfo:nil repeats:YES];
    }
    return _timer;
}

#pragma mark - 验证码获取倒计时
- (void)countdownForGetValidateCode
{
    _integerOfTime -= 1;
    
    if (_integerOfTime == 0) {
        self.isSelectedGetCodeButton = @"";
        [self.timer setFireDate:[NSDate distantFuture]];
        self.verificationButton.userInteractionEnabled = YES;
        [self.verificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.verificationButton setBackgroundColor:ZTOrangeColor];
    }
    else {
        self.isSelectedGetCodeButton = @"1";
        self.verificationButton.userInteractionEnabled = NO;
        [self.verificationButton setTitle:[NSString stringWithFormat:@"已发送(%lds)",(long)_integerOfTime] forState:UIControlStateNormal];
        [self.verificationButton setBackgroundColor:ZTTextLightGrayColor];
    }
}

#pragma mark - UITextField的协议方法
//点击return键,取消键盘第一响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneNumberText resignFirstResponder];
    [self.verificationText resignFirstResponder];
    
    return YES;
}

//点击空白处,取消键盘第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumberText resignFirstResponder];
    [self.verificationText resignFirstResponder];
    
}


- (void)agreeButtonAction:(UIButton *)button
{
    if (button.selected) {
        button.selected = NO;
        [self.registerButton setBackgroundColor:ZTTextLightGrayColor];
        self.registerButton.userInteractionEnabled = NO;
    } else {
        button.selected = YES;
        [self.registerButton setBackgroundColor:ZTOrangeColor];
        self.registerButton.userInteractionEnabled = YES;
    }
}

#pragma mark - 跳转到webview
-(void)agreementButtonAction
{
    MineWebViewController *webVC = [[MineWebViewController alloc] init];
    webVC.navTitle = @"用户协议";
    webVC.pathStr = @"user_protocol.html";
    [self pushVC:webVC animated:YES IsNeedLogin:NO];
}

@end
