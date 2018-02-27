//
//  EditPersonalDataViewController.m
//  Bican
//
//  Created by bican on 2018/1/14.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "EditPersonalDataViewController.h"
#import "AddClassViewController.h"

@interface EditPersonalDataViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *statementLabel;
@property (nonatomic, strong) UIView *surnameView;
@property (nonatomic, strong) UITextField *surnameTextField;
@property (nonatomic, strong) UIView *surnameLineView;

@property (nonatomic, strong) UIView *nameView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIView *nameLineView;

@property (nonatomic, strong) UIView *numberView;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UIView *numberLineView;

@property (nonatomic, strong) UIView *penNameView;
@property (nonatomic, strong) UITextField *penNameTextField;
@property (nonatomic, strong) UIView *penNameLineView;
@property (nonatomic, strong) UILabel *beenUseLabel;

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation EditPersonalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑个人资料";
    
    [self createSubViews];
}

- (void)createSubViews
{
    self.statementLabel = [[UILabel alloc] init];
    self.statementLabel.textColor = ZTRedColor;
    self.statementLabel.font = FONT(24);
    self.statementLabel.numberOfLines = 0;
    self.statementLabel.text = @"*此处的真实信息只作为身份验证使用，笔参不会向其他用户透露真实的个人信息。";
    [self.view addSubview:self.statementLabel];
    
    [self.statementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.view.mas_top).offset(GTH(50) + NAV_HEIGHT);
    }];
    
    self.surnameView = [[UIView alloc] init];
    [self.view addSubview:self.surnameView];
    
    [self.surnameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.statementLabel.mas_bottom).offset(GTH(40));
        make.height.mas_equalTo(GTH(120));
    }];
    
    self.surnameTextField = [[UITextField alloc] init];
    self.surnameTextField.placeholder = @"姓 (请输入真实信息)";
    self.surnameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.surnameTextField.font = FONT(24);
    [self.surnameTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.surnameTextField setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    self.surnameTextField.delegate = self;
    [self.surnameTextField resignFirstResponder];
    [self.view addSubview:self.surnameTextField];
    
    [self.surnameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.surnameView);
        make.height.mas_equalTo(GTH(120));
    }];
    
    self.surnameLineView = [[UIView alloc] init];
    self.surnameLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.surnameLineView];
    
    [self.surnameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.surnameView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    self.nameView = [[UIView alloc] init];
    [self.view addSubview:self.nameView];

    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.surnameLineView.mas_bottom);
        make.height.mas_equalTo(GTH(120));
    }];
    
    self.nameTextField = [[UITextField alloc] init];
    self.nameTextField.placeholder = @"名 (请输入真实信息)";
    self.nameTextField.font = FONT(24);
    [self.nameTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.nameTextField setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    self.nameTextField.delegate = self;
    [self.nameTextField resignFirstResponder];
    self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.nameTextField];

    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.nameView);
        make.height.mas_equalTo(GTH(120));
    }];

    self.nameLineView = [[UIView alloc] init];
    self.nameLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.nameLineView];

    [self.nameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.nameView.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    self.numberView = [[UIView alloc] init];
    [self.view addSubview:self.numberView];

    [self.numberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.nameLineView.mas_bottom);
        make.height.mas_equalTo(GTH(120));
    }];

    self.numberTextField = [[UITextField alloc] init];
    self.numberTextField.placeholder = @"教师资格证书编号 (选填)";
    self.numberTextField.font = FONT(24);
    [self.numberTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.numberTextField setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    self.numberTextField.delegate = self;
    [self.numberTextField resignFirstResponder];
    self.numberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.numberTextField];

    [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.numberView);
        make.height.mas_equalTo(GTH(120));
    }];

    self.numberLineView = [[UIView alloc] init];
    self.numberLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.numberLineView];

    [self.numberLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.numberView.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    self.penNameView = [[UIView alloc] init];
    [self.view addSubview:self.penNameView];

    [self.penNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.numberLineView.mas_bottom);
        make.height.mas_equalTo(GTH(120));
    }];

    self.penNameTextField = [[UITextField alloc] init];
    self.penNameTextField.placeholder = @"笔名 (支持中英文、数字和英文符号)";
    self.penNameTextField.font = FONT(24);
    [self.penNameTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.penNameTextField setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    self.penNameTextField.delegate = self;
    [self.penNameTextField resignFirstResponder];
    self.penNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.penNameTextField];

    [self.penNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.penNameView);
        make.height.mas_equalTo(GTH(120));
    }];

    self.penNameLineView = [[UIView alloc] init];
    self.penNameLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.penNameLineView];

    [self.penNameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.penNameView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    self.beenUseLabel = [[UILabel alloc] init];
    self.beenUseLabel.textColor = ZTRedColor;
    self.beenUseLabel.font = FONT(24);
    self.beenUseLabel.text = @"笔名已被使用";
    self.beenUseLabel.hidden = YES;
    [self.view addSubview:self.beenUseLabel];
    
    [self.beenUseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.top.equalTo(self.penNameLineView.mas_bottom).offset(GTH(30));
    }];

    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nextButton.userInteractionEnabled = NO;
    self.nextButton.layer.cornerRadius = GTH(20);
    self.nextButton.adjustsImageWhenHighlighted = NO;
    [self.nextButton setBackgroundColor:ZTTextLightGrayColor];
    [self.nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(50));
        make.right.equalTo(self.view.mas_right).offset(GTW(-50));
        make.top.equalTo(self.penNameLineView.mas_bottom).offset(GTH(100));
        make.height.mas_equalTo(GTH(88));
    }];
    
    
    
}

#pragma mark - 输入完成
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.nameTextField.text.length == 0) {
        return;
    }
    if (self.surnameTextField.text.length == 0) {
        return;
    }
    if (self.penNameTextField.text.length == 0) {
        return;
    }
    self.nextButton.userInteractionEnabled = YES;
    [self.nextButton setBackgroundColor:ZTOrangeColor];

}

#pragma mark - 检测昵称是否存在接口
- (void)checkUserNickName
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.penNameTextField.text forKey:@"nickname"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/checkUserNickName", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSString *resultString = [resultObject objectForKey:@"data"];
        if ([resultString isEqualToString:@"false"]) { //笔名不存在
            self.beenUseLabel.hidden = YES;
            //完善个人信息接口
            [self completeBaseInfo];
            
        } else {
            self.beenUseLabel.hidden = NO;
        }
        
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
    if (self.numberTextField.text.length != 0) {
        if (self.numberTextField.text.length != 17) {
            [ZTToastUtils showToastIsAtTop:YES Message:@"教师资格证格式不正确" Time:3.0];
            return;
        }
    }
    //检测昵称是否存在接口
    [self checkUserNickName];
    
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
    [params setValue:self.penNameTextField.text forKey:@"nickName"];
 
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
        
        //加入班级
        AddClassViewController *addVC = [[AddClassViewController alloc] init];
        addVC.isPassButton = YES;
        [self pushVC:addVC animated:YES IsNeedLogin:YES];
        
        
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
    [self.nameTextField resignFirstResponder];
    [self.surnameTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
    [self.penNameTextField resignFirstResponder];

    return YES;
}

//点击空白处,取消键盘第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.surnameTextField resignFirstResponder];
    [self.numberTextField resignFirstResponder];
    [self.penNameTextField resignFirstResponder];
    
}


@end
