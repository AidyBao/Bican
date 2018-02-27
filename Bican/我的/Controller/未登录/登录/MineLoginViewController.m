//
//  LoginViewController.m
//  Bican
//
//  Created by bican on 2018/1/3.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MineLoginViewController.h"
#import "MineLoginView.h"

#import "ChangePasswordViewController.h"
#import "RegisterViewController.h"
#import "EditPersonalDataViewController.h"

@interface MineLoginViewController ()<MineLoginViewDelegate>

@property (nonatomic, strong) MineLoginView *mineLoginView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation MineLoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //进入到登录页面, 就清空用户信息
    [GetUserInfo deleteUserModelInCache];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    [self createLeftNavigationItem:[UIImage imageNamed:@"return"] Title:@""];
    
    self.mineLoginView = [[MineLoginView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, ScreenHeight - NAV_HEIGHT)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.mineLoginView.passwordTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.mineLoginView.phoneTextField];

    [self.view addSubview:self.mineLoginView];
    
    self.mineLoginView.delegate = self;
}

- (void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    [self popVCAnimated:YES];
    //离开页面时, 发通知更新tabbar
    if (![GetUserInfo judgIsloginByUserModel]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changTabBarChildController" object:nil];
        
    }
}

- (void)textFieldChanged:(NSNotification *)notification
{
//    UITextField *textField = [notification object];
    if (self.mineLoginView.phoneTextField.text.length > 0 && self.mineLoginView.passwordTextField.text.length > 0) {
        self.mineLoginView.loginButton.userInteractionEnabled = YES;
        [self.mineLoginView.loginButton setBackgroundColor:ZTOrangeColor];
    } else {
        self.mineLoginView.loginButton.userInteractionEnabled = NO;
        [self.mineLoginView.loginButton setBackgroundColor:ZTTextLightGrayColor];
    }


}

-(void)seePasswordAndPushWithTag:(NSInteger)tag Button:(UIButton *)button
{
    if (tag == 10001) {
        //密码是否密文显示
        if (button.selected) {
            button.selected = NO;
            self.mineLoginView.passwordTextField.secureTextEntry = YES;

        } else {
            button.selected = YES;
            self.mineLoginView.passwordTextField.secureTextEntry = NO;
        }
    }
    if (tag == 10002) {
        //清空输入框
        [self.mineLoginView.passwordTextField setText:@""];
    }
    if (tag == 10003) {
        //登录
        if (self.mineLoginView.phoneTextField.text.length == 0) {
            return;
        }
        if (self.mineLoginView.passwordTextField.text.length == 0) {
            return;
        }
        if (![NSString isValidatePhone:self.mineLoginView.phoneTextField.text]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"请输入正确的手机号" Time:3.0];
            return;
        }
        //登录接口
        [self loginByPwd];
    }
    if (tag == 10004) {
        //忘记密码
        ChangePasswordViewController *changePasswordVC = [[ChangePasswordViewController alloc] init];
        [self pushVC:changePasswordVC animated:YES IsNeedLogin:NO];
    }
    if (tag == 10005) {
        //注册
        RegisterViewController *registerVC = [[RegisterViewController alloc] init];
        [self pushVC:registerVC animated:YES IsNeedLogin:NO];
    }
}

#pragma mark - 登录接口调用
- (void)loginByPwd
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.mineLoginView.phoneTextField.text forKey:@"tel"];
    [params setValue:self.mineLoginView.passwordTextField.text forKey:@"password"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/user/loginByPwd", BASE_URL];
    
    //记录登录的用户名和密码
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.mineLoginView.phoneTextField.text forKey:@"RemberUsername"];
    [defaults setObject:self.mineLoginView.passwordTextField.text forKey:@"RemberUserPasswd"];

    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {

        [self hideLoading];
        [self.dataSourceArray removeAllObjects];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        //如果不登录成功
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //存model
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        UserInformation *userModel = [[UserInformation alloc] init];
        [userModel setValuesForKeysWithDictionary:dic];
        [self.dataSourceArray addObject:userModel];
        
        [GetUserInfo addUserInfoModel:(UserInformation *)self.dataSourceArray[0]];
        
        //如果个人信息没有完善
        if ([GetUserInfo getUserInfoModel].firstName.length == 0) {
            EditPersonalDataViewController *editVC = [[EditPersonalDataViewController alloc] init];
            [self pushVC:editVC animated:YES IsNeedLogin:YES];
            
        } else {
            //登录成功后, 发起通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changTabBarChildController" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToFind" object:nil];
            [self popToRootVCAnimated:YES];
        }

    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self loginByPwd];
        }
    }];
    
    
}




@end
