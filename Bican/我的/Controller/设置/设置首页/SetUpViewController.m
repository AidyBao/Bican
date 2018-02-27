//
//  SetUpViewController.m
//  Bican
//
//  Created by bican on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "SetUpViewController.h"
#import "MineTableViewCell.h"
#import "FeedbackViewController.h"
#import "AboutBicanViewController.h"

@interface SetUpViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UIButton *footerButton;

@end

@implementation SetUpViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithObjects:@"问题反馈", @"清理缓存", @"关于笔参", nil];
    }
    return _dataSourceArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self createTableView];
    [self createFooterView];
    
}

- (void)createFooterView
{
    self.footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footerButton setBackgroundColor:ZTOrangeColor];
    [self.footerButton setTitle:@"退出登录" forState:UIControlStateNormal];
    self.footerButton.titleLabel.font = FONT(30);
    [self.footerButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.footerButton.adjustsImageWhenHighlighted = NO;
    [self.footerButton addTarget:self action:@selector(footerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footerButton];
    
    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(GTH(96));
    }];
    
    if (![GetUserInfo judgIsloginByUserModel]) {
        self.footerButton.hidden = YES;
    } else {
        self.footerButton.hidden = NO;
    }
}

#pragma mark - 退出登录接口
- (void)footerButtonAction
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/user/logOut", BASE_URL];

    [NetWorkingManager postWithUrlStr:url token:[GetUserInfo getUserInfoModel].token params:params params_ext:params_ext successHandler:^(id resultObject) {

        [self hideLoading];
        [self.dataSourceArray removeAllObjects];

        NSString *msg = [resultObject objectForKey:@"msg"];

        [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
        //如果不登录成功
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            return;
        }
        //清空用户信息
        [GetUserInfo deleteUserModelInCache];
        //退出登录成功后, 发起通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changTabBarChildController" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToFind" object:nil];
        [self popToRootVCAnimated:YES];

    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];

}



- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] init];
    self.tableView.scrollEnabled = NO;
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = GTH(128);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(GTH(-96));
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"setUpCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    NSString *leftStr = self.dataSourceArray[indexPath.row];
    if (indexPath.row == 1) {
        NSInteger size = [[SDImageCache sharedImageCache] getSize];
        float cacheSize = size / 1024.0 / 1024.0;
        cell.contentLabel.text = [NSString stringWithFormat:@"%.2f MB", cacheSize];
        cell.contentLabel.textColor = ZTTitleColor;
      
    }
    [cell setMineTableViewCellWithLeftText:leftStr LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:cell.contentLabel.text RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//问题反馈
        FeedbackViewController *feedbackVC = [[FeedbackViewController alloc] init];
        [self pushVC:feedbackVC animated:YES IsNeedLogin:YES];
    }
    if (indexPath.row == 1) {//清理缓存
        NSUInteger size = [[SDImageCache sharedImageCache] getSize];
        float cacheSize = size / 1024.0 / 1024.0;
        if (cacheSize == 0) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"别点了,已经没有缓存" Time:3.0];
            
        } else {
            
            UIAlertController *cacheAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认清除缓存数据?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [ZTToastUtils showToastIsAtTop:NO Message:@"清理完成" Time:3.0];
                    
                }];
                
                [self reloadTableView:self.tableView Row:1 Section:0];
            }];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [ensure setValue:ZTOrangeColor forKey:@"titleTextColor"];
            [cancel setValue:ZTTitleColor forKey:@"titleTextColor"];
            [cacheAlert addAction:ensure];
            [cacheAlert addAction:cancel];
            [self presentViewController:cacheAlert animated:YES completion:nil];
            
        }
    }
    if (indexPath.row == 2) {//关于笔参
        AboutBicanViewController *aboutBicanVC = [[AboutBicanViewController alloc] init];
        [self pushVC:aboutBicanVC animated:YES IsNeedLogin:NO];
    }
//    if (indexPath.row == 3) {//应用升级
//        [self update];
//    }
    
}
                                      
                                        
#pragma mark - 查询应用升级接口
- (void)update
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //app当前版本
    [params setValue:APPVERSION forKey:@"appNumber"];
    //0-android, 1-ios
    [params setValue:@"1" forKey:@"appSystem"];
    [params setValue:@"-1" forKey:@"userId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/apk/update", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //(number)isForceUpdate: 0  强制升级(只返回0)
        //(number)status: 0 - 当前是最新版本, 1 - 当前有版本可以升级
        NSString *status = [NSString stringWithFormat:@"%@", [resultObject objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            UIAlertController *updateAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您有新版本需要更新" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/1335857886"]]; // 应用ID信息可以直接从AppStore拿到
                
            }];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [updateAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
            [cancelAction setValue:ZTTitleColor forKey:@"titleTextColor"];
            [updateAlert addAction:updateAction];
            [updateAlert addAction:cancelAction];
            [self presentViewController:updateAlert animated:YES completion:nil];
            
        } else {
            [ZTToastUtils showToastIsAtTop:NO Message:@"当前已经是最新版本了" Time:3.0];
        }
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

@end
