//
//  PseudonymViewController.m
//  Bican
//
//  Created by bican on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "PseudonymViewController.h"

@interface PseudonymViewController () <UITextFieldDelegate>


@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) UILabel *beenUseLabel;

@end

@implementation PseudonymViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"笔名";
    
    [self createRightNavigationItem:nil Title:@"保存" RithtTitleColor:ZTTextGrayColor BackgroundColor:nil CornerRadius:0];
    [self createSubViews];
    
}

- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    if (self.pseudonymText.text.length == 0) {
        return;
    }
    [self checkUserNickName];
    
}


- (void)createSubViews
{
    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.topLineView];

    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(GTH(49) + NAV_HEIGHT);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLineView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(GTW(125));
    }];
    
    self.pseudonymText = [[UITextField alloc] init];
    self.pseudonymText.placeholder = @"请输入笔名";
    self.pseudonymText.font = FONT(28);
    self.pseudonymText.text = [GetUserInfo getUserInfoModel].nickname;
    self.pseudonymText.textColor = ZTTextGrayColor;
    self.pseudonymText.borderStyle = UITextBorderStyleNone;
    self.pseudonymText.textAlignment = NSTextAlignmentLeft;
    self.pseudonymText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.pseudonymText.delegate = self;
    [self.pseudonymText setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.pseudonymText setValue:FONT(28) forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:self.pseudonymText];
    
    [self.pseudonymText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLineView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.right.equalTo(self.view.mas_right).offset(GTW(-28));
        make.height.mas_equalTo(GTW(125));
    }];
    
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.bottomLineView];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pseudonymText.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    
    self.beenUseLabel = [[UILabel alloc] init];
    self.beenUseLabel.textColor = ZTRedColor;
    self.beenUseLabel.font = FONT(28);
    self.beenUseLabel.text = @"笔名已被使用";
    self.beenUseLabel.hidden = YES;
    [self.view addSubview:self.beenUseLabel];
    
    [self.beenUseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.top.equalTo(self.bottomLineView.mas_bottom).offset(GTH(30));
    }];
    
}

#pragma mark - 检测昵称是否存在接口
- (void)checkUserNickName
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.pseudonymText.text forKey:@"nickname"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/checkUserNickName", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSString *resultString = [resultObject objectForKey:@"data"];
        if ([resultString isEqualToString:@"true"]) { //笔名存在
            self.beenUseLabel.hidden = NO;
        } else {
            self.beenUseLabel.hidden = YES;
            [self completeBaseInfo];
        }
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}


#pragma mark - 完善个人资料信息
- (void)completeBaseInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    UserInformation *user = [GetUserInfo getUserInfoModel];
    [params setValue:user.roleType forKey:@"roleType"];
    [params setValue:user.firstName forKey:@"firstName"];
    [params setValue:user.lastName forKey:@"lastName"];
    [params setValue:self.pseudonymText.text forKey:@"nickName"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/user/completeBaseInfo", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        UserInformation *user = [[UserInformation alloc] init];
        [user setValuesForKeysWithDictionary:dic];
        [GetUserInfo updateUserinfoModelWithNewModel:user];
        
        [self popVCAnimated:YES];

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
    [self.pseudonymText resignFirstResponder];
    return YES;
}

//点击空白处,取消键盘第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.pseudonymText resignFirstResponder];
}




@end
