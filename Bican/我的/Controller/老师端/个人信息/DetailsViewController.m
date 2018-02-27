//
//  DetailsViewController.m
//  Bican
//
//  Created by bican on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "DetailsViewController.h"
#import "DetailsTableViewCell.h"

@interface DetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *numTextField;

@end

@implementation DetailsViewController

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"姓", @"名", @"教师资格证编号(选填)", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)contentArray
{
    if (!_contentArray) {
        _contentArray = [NSMutableArray arrayWithObjects:@"请输入姓氏", @"请输入名字", @"请输入证书编号", nil];
    }
    return _contentArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    [self createRightNavigationItem:nil Title:@"保存" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:5];
    
    [self createTableView];
}

- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    if (self.titleTextField.text.length == 0 || self.nameTextField.text.length == 0) {
        return;
    }
    if (self.numTextField.text.length < 17) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请输入17位教师资格证书编号" Time:3.0];
        return;
    }
    [self checkUserCertificateNumber];

}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = GTH(131);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailsCell = @"detailsCell";
    DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailsCell];
    if (!cell) {
        cell = [[DetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailsCell];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];

    cell.nameLabel.text = self.titleArray[indexPath.row];
    cell.nameTextField.placeholder = self.contentArray[indexPath.row];
    
    UserInformation *user = [GetUserInfo getUserInfoModel];
    if (indexPath.row == 0) {
        cell.nameTextField.text = user.firstName;
        self.titleTextField = cell.nameTextField;
    }
    if (indexPath.row == 1) {
        cell.nameTextField.text = user.lastName;
        self.nameTextField = cell.nameTextField;
    }
    if (indexPath.row == 2) {
        cell.nameTextField.text = user.certificateNumber;
        self.numTextField = cell.nameTextField;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:cell.nameTextField];
    
    return cell;
}

- (void)textFieldChanged:(NSNotification *)notification
{
    UITextField *textField = [notification object];
    if (textField == self.numTextField) {
        return;
    }
    
    if (self.titleTextField.text.length > 0 && self.nameTextField.text.length > 0) {
  
        [self createRightNavigationItem:nil Title:@"保存" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:0];
    } else {
        [self createRightNavigationItem:nil Title:@"保存" RithtTitleColor:ZTTextGrayColor BackgroundColor:nil CornerRadius:0];

    }
    
}

#pragma mark - 校验教师资格证编号是否存在
- (void)checkUserCertificateNumber
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.numTextField.text forKey:@"certificateNumber"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/checkUserCertificateNumber", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:NSStringTransformLatinToKatakana params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //教师资格证编好校验成功
        if ([[resultObject objectForKey:@"data"] isEqualToString:@"false"]) {
            [self completeBaseInfo];
        }
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
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
    [params setValue:self.titleTextField.text forKey:@"firstName"];
    [params setValue:self.nameTextField.text forKey:@"lastName"];
    [params setValue:user.nickname forKey:@"nickName"];
    [params setValue:self.numTextField.text forKey:@"certificateNumber"];

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



@end
