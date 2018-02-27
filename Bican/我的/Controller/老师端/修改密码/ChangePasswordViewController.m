//
//  ChangePasswordViewController.m
//  Bican
//
//  Created by bican on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ResetPasswordViewController.h"

@interface ChangePasswordViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UITextField *phoneNumberText;
@property (nonatomic, strong) UILabel *noPhoneLabel;

@property (nonatomic, strong) UILabel *verificationLabel;
@property (nonatomic, strong) UITextField *verificationText;
@property (nonatomic, strong) UILabel *noVerificationLabel;

@property (nonatomic, strong) UIButton *verificationButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, assign) NSInteger integerOfTime;//倒计时秒数
@property (nonatomic, strong) NSTimer *timer;//获取验证码倒计时
@property (nonatomic, strong) NSString *isSelectedGetCodeButton;//是否点击过获取验证码

@end

@implementation ChangePasswordViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer setFireDate:[NSDate distantFuture]];
    [self.verificationButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.verificationButton.userInteractionEnabled = YES;
    [self.verificationButton setBackgroundColor:ZTOrangeColor];
    [self.phoneNumberText resignFirstResponder];
    [self.verificationText resignFirstResponder];
    [self.verificationText setText:@""];
    _timer = nil;
    self.isSelectedGetCodeButton = @"";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认:没有点击过验证码
    self.isSelectedGetCodeButton = @"";

    self.title = @"安全验证";
    [self createSubViews];
}

- (void)createSubViews
{
    self.phoneNumberLabel = [[UILabel alloc] init];
    self.phoneNumberLabel.textColor = ZTTextGrayColor;
    self.phoneNumberLabel.text = @"请填写需要找回的账号";
    self.phoneNumberLabel.font = FONT(24);
    [self.view addSubview:self.phoneNumberLabel];
    
    [self.phoneNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(88));
        make.top.equalTo(self.view.mas_top).offset(GTH(50) + NAV_HEIGHT);
        make.height.mas_equalTo(GTH(25));
    }];
    
    self.phoneNumberText = [[UITextField alloc] init];
    self.phoneNumberText.placeholder = @"请输入手机号";
    self.phoneNumberText.borderStyle = UITextBorderStyleNone;
    self.phoneNumberText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.phoneNumberText.layer.borderWidth = 1.0f;
    self.phoneNumberText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.phoneNumberText.keyboardType = UIKeyboardTypeNamePhonePad;
    self.phoneNumberText.delegate = self;
    self.phoneNumberText.font = FONT(24);
    self.phoneNumberText.textColor = ZTTitleColor;
    [self.phoneNumberText setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneNumberText setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.phoneNumberText];
    
    [self.phoneNumberText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(88));
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
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:ZTTextLightGrayColor];
    self.nextButton.userInteractionEnabled = NO;
    self.nextButton.titleLabel.font = FONT(36);
    self.nextButton.layer.cornerRadius = GTH(10);
    [self.nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.verificationText.mas_bottom).offset(GTH(362));
        make.left.equalTo(self.view.mas_left).offset(GTW(34));
        make.right.equalTo(self.view.mas_right).offset(GTW(-34));
        make.height.mas_equalTo(GTH(88));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.phoneNumberText];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.verificationText];

    
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
    if (textField == self.verificationText) {
        if (textField.text.length == 0) {
            [self.nextButton setBackgroundColor:ZTTextLightGrayColor];
            self.nextButton.userInteractionEnabled = NO;
        } else {
            [self.nextButton setBackgroundColor:ZTOrangeColor];
            self.nextButton.userInteractionEnabled = YES;
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
    //重新绑定-1，默认(注册&&忘记密码)-0
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
            [self pushToLoginVC];
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
    self.noPhoneLabel.hidden = YES;
    self.noVerificationLabel.hidden = YES;
    
    self.verificationText.layer.borderColor = ZTLineGrayColor.CGColor;
    self.phoneNumberText.layer.borderColor = ZTLineGrayColor.CGColor;
    
    self.nextButton.userInteractionEnabled = YES;
    [self.nextButton setBackgroundColor:ZTOrangeColor];
    
    //校验验证码
    [self checkAuthCode];
    

    
}

#pragma mark - 校验验证码接口
- (void)checkAuthCode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.phoneNumberText.text forKey:@"tel"];
    [params setValue:self.verificationText.text forKey:@"authCode"];
    [params setValue:@"-1" forKey:@"userId"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/checkAuthCode", BASE_URL];

    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {

        NSString *msg = [resultObject objectForKey:@"msg"];

        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //重置页面
        ResetPasswordViewController *resetPasswordVC = [[ResetPasswordViewController alloc] init];
        resetPasswordVC.telStr = self.phoneNumberText.text;
        resetPasswordVC.authCodeStr = self.verificationText.text;
        [self pushVC:resetPasswordVC animated:YES IsNeedLogin:NO];

    } errorHandler:^(NSError *error) {


    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
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




@end
