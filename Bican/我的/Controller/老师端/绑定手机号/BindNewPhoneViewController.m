



//
//  BindNewPhoneViewController.m
//  Bican
//
//  Created by bican on 2018/1/6.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "BindNewPhoneViewController.h"
#import "AccountsViewController.h"

@interface BindNewPhoneViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) UIView *currentView;
@property (nonatomic, strong) UIView *currentLineView;

@property (nonatomic, strong) UITextField *nowPhoneNumberTextField;
@property (nonatomic, strong) UIView *nowPhoneNumberView;
@property (nonatomic, strong) UIView *nowPhoneNumberLineView;

@property (nonatomic, strong) UITextField *verificationTextField;
@property (nonatomic, strong) UIView *verificationView;
@property (nonatomic, strong) UIView *verificationLineView;

@property (nonatomic, strong) UIButton *obtainButton;

@property (nonatomic, strong) UIButton *saveButton;


@property (nonatomic, assign) NSInteger integerOfTime;//倒计时秒数
@property (nonatomic, strong) NSTimer *timer;//获取验证码倒计时
@property (nonatomic, strong) NSString *isSelectedGetCodeButton;//是否点击过获取验证码

@end

@implementation BindNewPhoneViewController


- (void)viewWillDisappear:(BOOL)animated
{
    [_timer setFireDate:[NSDate distantFuture]];
    [self.obtainButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    self.obtainButton.userInteractionEnabled = YES;
    [self.obtainButton setBackgroundColor:ZTOrangeColor];
    [self.currentTextField resignFirstResponder];
    [self.nowPhoneNumberTextField resignFirstResponder];
    [self.verificationTextField setText:@""];
    _timer = nil;
    self.isSelectedGetCodeButton = @"";
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定新手机号";
    
    [self createSubViews];
}

- (void)createSubViews
{
    
    self.currentView = [[UIView alloc] init];
    [self.view addSubview:self.currentView];
    
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.height.mas_equalTo(GTH(125));
    }];
    
    self.currentTextField = [[UITextField alloc] init];
    self.currentTextField.placeholder = @"输入当前手机号码";
    self.currentTextField.keyboardType = UIKeyboardTypePhonePad;
    self.currentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.currentTextField.delegate = self;
    self.currentTextField.font = FONT(30);
    self.currentTextField.textColor = ZTTitleColor;
    [self.currentTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.currentTextField setValue:FONT(30) forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.currentTextField];
    
    [self.currentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(GTW(28));
        make.right.equalTo(self.view).offset(GTW(-28));
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.height.mas_equalTo(GTH(125));
    }];
    
    self.currentLineView = [[UIView alloc] init];
    self.currentLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.currentLineView];
    
    [self.currentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.currentTextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    self.nowPhoneNumberView = [[UIView alloc] init];
    [self.view addSubview:self.nowPhoneNumberView];
    
    [self.nowPhoneNumberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.currentLineView.mas_bottom);
        make.height.mas_equalTo(GTH(125));
    }];
    
    self.nowPhoneNumberTextField = [[UITextField alloc] init];
    self.nowPhoneNumberTextField.placeholder = @"输入新的手机号码";
    self.nowPhoneNumberTextField.keyboardType = UIKeyboardTypePhonePad;
    self.nowPhoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nowPhoneNumberTextField.delegate = self;
    self.nowPhoneNumberTextField.font = FONT(30);
    self.nowPhoneNumberTextField.textColor = ZTTitleColor;
    [self.nowPhoneNumberTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.nowPhoneNumberTextField setValue:FONT(30) forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.nowPhoneNumberTextField];
    
    [self.nowPhoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(GTW(28));
        make.right.equalTo(self.view).offset(GTW(-28));
        make.top.equalTo(self.currentLineView.mas_bottom);
        make.height.mas_equalTo(GTH(125));
    }];
    
    self.nowPhoneNumberLineView = [[UIView alloc] init];
    self.nowPhoneNumberLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.nowPhoneNumberLineView];
    
    [self.nowPhoneNumberLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.nowPhoneNumberTextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    
    self.verificationView = [[UIView alloc] init];
    [self.view addSubview:self.verificationView];
    
    [self.verificationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.nowPhoneNumberLineView.mas_bottom);
        make.height.mas_equalTo(GTH(125));
    }];
    
    self.verificationTextField = [[UITextField alloc] init];
    self.verificationTextField.placeholder = @"请输入验证码";
    self.verificationTextField.font = FONT(30);
    self.verificationTextField.textColor = ZTTitleColor;
    [self.verificationTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.verificationTextField setValue:FONT(30) forKeyPath:@"_placeholderLabel.font"];
    self.verificationTextField.keyboardType = UIKeyboardTypePhonePad;
    self.verificationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.verificationTextField.delegate = self;
    [self.view addSubview:self.verificationTextField];
    
    [self.verificationTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.right.equalTo(self.view.mas_right).offset(GTW(-220));
        make.top.equalTo(self.nowPhoneNumberLineView.mas_bottom);
        make.height.mas_equalTo(GTH(125));
    }];
    
    self.obtainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.obtainButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.obtainButton.adjustsImageWhenHighlighted = NO;
    self.obtainButton.titleLabel.font = FONT(24);
    [self.obtainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.obtainButton setBackgroundColor:ZTTextLightGrayColor];
    self.obtainButton.layer.cornerRadius = GTH(10);
    [self.obtainButton addTarget:self action:@selector(getCodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.obtainButton.userInteractionEnabled = NO;
    [self.view addSubview:self.obtainButton];
    
    [self.obtainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(GTW(-36));
        make.top.equalTo(self.verificationTextField.mas_top).offset(GTH(41));
        make.size.mas_equalTo(CGSizeMake(GTW(160), GTH(40)));
    }];
    
    self.verificationLineView = [[UIView alloc] init];
    self.verificationLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.verificationLineView];
    
    [self.verificationLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.verificationTextField.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    self.saveButton.adjustsImageWhenHighlighted = NO;
    self.saveButton.titleLabel.font = FONT(30);
    [self.saveButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    [self.saveButton setBackgroundColor:ZTTextLightGrayColor];
    self.saveButton.layer.cornerRadius = GTH(10);
    [self.saveButton addTarget:self action:@selector(saveButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.saveButton.userInteractionEnabled = NO;
    [self.view addSubview:self.saveButton];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(70));
        make.right.equalTo(self.view.mas_right).offset(GTW(-70));
        make.top.equalTo(self.verificationLineView.mas_bottom).offset(GTH(78));
        make.height.mas_equalTo(GTH(78));
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.nowPhoneNumberTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.verificationTextField];
    
}


- (void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textField = [notification object];
    if (textField == self.nowPhoneNumberTextField) {
        //如果处于倒计时状态下
        if (_integerOfTime > 0) {
            return;
        }
        if (textField.text.length == 0) {
            [self.obtainButton setBackgroundColor:ZTTextLightGrayColor];
            self.obtainButton.userInteractionEnabled = NO;
        } else {
            [self.obtainButton setBackgroundColor:ZTOrangeColor];
            self.obtainButton.userInteractionEnabled = YES;
        }
        
    }
    if (textField == self.verificationTextField) {
        if (textField.text.length == 0) {
            [self.saveButton setBackgroundColor:ZTTextLightGrayColor];
            self.saveButton.userInteractionEnabled = NO;
        } else {
            [self.saveButton setBackgroundColor:ZTOrangeColor];
            self.saveButton.userInteractionEnabled = YES;
        }
        
    }
    
}


#pragma mark - 发送短信验证码
- (void)getCodeButtonAction
{
    [self.currentTextField resignFirstResponder];
    [self.nowPhoneNumberTextField resignFirstResponder];
    [self.verificationTextField resignFirstResponder];
    
    
    //判断号码是否为空
    if ([NSString isEmptyOrWhitespace:self.currentTextField.text]) {
        return;
    }
    if (![NSString isEmptyOrWhitespace:self.currentTextField.text]) {
        //验证是否为手机号码
        if (![NSString isValidatePhone:self.currentTextField.text]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"当前手机号码不合法" Time:3.0];
            return;
        }
    }
    //当前的手机是否跟用户手机号相同
    if (![self.currentTextField.text isEqualToString:[GetUserInfo getUserInfoModel].mobile]) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"当前手机号码不正确" Time:3.0];
        return;
    }
    
    if (![NSString isEmptyOrWhitespace:self.nowPhoneNumberTextField.text]) {
        //验证是否为手机号码
        if (![NSString isValidatePhone:self.nowPhoneNumberTextField.text]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"新手机号码不合法" Time:3.0];
            return;
        }
    }

    
    //发送验证码接口
    [self sendAuthCode];
    
}

#pragma mark - 发送验证码接口
- (void)sendAuthCode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.nowPhoneNumberTextField.text forKey:@"tel"];
    //重新绑定-1，默认(注册)-0
    [params setValue:@"1" forKey:@"isReBind"];
    
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
        self.obtainButton.userInteractionEnabled = NO;
        [self.obtainButton setBackgroundColor:ZTTextLightGrayColor];
        
    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}



- (void)saveButtonAction
{
    //判断号码是否为空
    if ([NSString isEmptyOrWhitespace:self.currentTextField.text]) {
        [self.obtainButton setBackgroundColor:ZTLineGrayColor];
        self.obtainButton.userInteractionEnabled = NO;
        return;
    }
    //验证是否为手机号码
    if (![NSString isValidatePhone:self.currentTextField.text] && [NSString isValidatePhone:self.nowPhoneNumberTextField.text]) {
        [self.obtainButton setBackgroundColor:ZTOrangeColor];
        [MBHUDManager showBriefAlert:@"当前手机号码不合法"];
        return;
    }
    //判断 - 是否点击获取验证码按钮
    if (self.isSelectedGetCodeButton.length == 0) {
        [MBHUDManager showBriefAlert:@"请先发送验证码 !"];
        return;
    }
    //判断手机验证码是否为空
    if ([NSString isEmptyOrWhitespace:self.verificationTextField.text]) {
        [self.saveButton setBackgroundColor:ZTLineGrayColor];
        self.saveButton.userInteractionEnabled = NO;
        return;
    }
    

    self.saveButton.userInteractionEnabled = YES;
    [self.saveButton setBackgroundColor:ZTOrangeColor];
    
    //校验验证码
    [self checkAuthCode];
    
}

#pragma mark - 校验验证码接口
- (void)checkAuthCode
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.nowPhoneNumberTextField.text forKey:@"tel"];
    [params setValue:self.verificationTextField.text forKey:@"authCode"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/checkAuthCode", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //调用重新绑定的接口
        [self reBindTel];

    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - 绑定新手机号接口
- (void)reBindTel
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.nowPhoneNumberTextField.text forKey:@"tel"];
    [params setValue:self.verificationTextField.text forKey:@"authCode"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/reBindTel", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSString *token = [resultObject objectForKey:@"data"];
        [GetUserInfo updateUserinfoOfToken:token];
        [self popToAccountVC];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 返回到账号页面
- (void)popToAccountVC
{
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[AccountsViewController class]]) {
            [self popToVC:VC animated:YES];
            return;
        }
    }
    AccountsViewController *accountVC = [[AccountsViewController alloc] init];
    [self pushVC:accountVC animated:YES IsNeedLogin:YES];
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
        self.obtainButton.userInteractionEnabled = YES;
        [self.obtainButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.obtainButton setBackgroundColor:ZTOrangeColor];
    }
    else {
        self.isSelectedGetCodeButton = @"1";
        self.obtainButton.userInteractionEnabled = NO;
        [self.obtainButton setTitle:[NSString stringWithFormat:@"已发送(%lds)",(long)_integerOfTime] forState:UIControlStateNormal];
        [self.obtainButton setBackgroundColor:ZTTextLightGrayColor];
    }
}


#pragma mark - UITextField的协议方法
//点击return键,取消键盘第一响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.currentTextField resignFirstResponder];
    [self.nowPhoneNumberTextField resignFirstResponder];
    [self.verificationTextField resignFirstResponder];
    
    return YES;
}

//点击空白处,取消键盘第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.currentTextField resignFirstResponder];
    [self.nowPhoneNumberTextField resignFirstResponder];
    [self.verificationTextField resignFirstResponder];
    
}




@end
