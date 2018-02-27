//
//  MineViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MineTeacherViewController.h"
#import "MineHeaderView.h"
#import "MineTableViewCell.h"

#import "ClassViewController.h"
#import "InviteViewController.h"
#import "CorrectViewController.h"
#import "RecommendViewController.h"
#import "AttentionViewController.h"
#import "CollectViewController.h"
#import "WalletViewController.h"
#import "SetUpViewController.h"
#import "AccountsViewController.h"
#import "MineNoLoginViewController.h"

@interface MineTeacherViewController ()<UITableViewDelegate, UITableViewDataSource, MineHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineHeaderView *headerView;

@end

@implementation MineTeacherViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    UserInformation *user = [GetUserInfo getUserInfoModel];
    [_headerView setMineHeaderViewWithHeaderImage:user.avatar Name:user.nickname School:user.schoolName ClassName:user.className];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
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
    self.tableView.tableHeaderView = [self createTableViewHeaderView];
    self.tableView.rowHeight = GTH(128);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

- (UIView *)createTableViewHeaderView
{
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(254))];
        UserInformation *user = [GetUserInfo getUserInfoModel];
        [_headerView setMineHeaderViewWithHeaderImage:user.avatar Name:user.nickname School:user.schoolName ClassName:user.className];
        
        _headerView.delegate = self;
    }
    return _headerView;
}

#pragma mark - MineHeaderViewDelegate
- (void)pushToAccountsVC
{
    AccountsViewController *accountsVC = [[AccountsViewController alloc] init];
    [self pushVC:accountsVC animated:YES IsNeedLogin:YES];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            //return 2;//屏蔽钱包模块
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"MineTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    if (indexPath.section == 0) {
        [cell setMineTableViewCellWithLeftText:@"班级" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [cell setMineTableViewCellWithLeftText:@"邀请" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];
        }
        if (indexPath.row == 1) {
            [cell setMineTableViewCellWithLeftText:@"评阅" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];
        }
        if (indexPath.row == 2) {
            [cell setMineTableViewCellWithLeftText:@"推荐" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [cell setMineTableViewCellWithLeftText:@"关注" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];
            
        } if (indexPath.row == 1) {
            [cell setMineTableViewCellWithLeftText:@"收藏" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];
        }
    }
    if (indexPath.section == 3) {
        [cell setMineTableViewCellWithLeftText:@"设置" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];
        /*
        if (indexPath.row == 0) {
            [cell setMineTableViewCellWithLeftText:@"钱包" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];
        }
        if (indexPath.row == 1) {
            [cell setMineTableViewCellWithLeftText:@"设置" LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];
        }*/
    }
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ClassViewController *classVC = [[ClassViewController alloc] init];
        [self pushVC:classVC animated:YES IsNeedLogin:YES];
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            InviteViewController *inviteVC = [[InviteViewController alloc] init];
            [self pushVC:inviteVC animated:YES IsNeedLogin:YES];
            
        } else if (indexPath.row == 1) {
            CorrectViewController *correctVC = [[CorrectViewController alloc] init];
            [self pushVC:correctVC animated:YES IsNeedLogin:YES];
//            MineNoLoginViewController *mineNoLoginVC = [[MineNoLoginViewController alloc] init];
//            [self pushVC:mineNoLoginVC animated:YES];
        } else {
            RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
            [self pushVC:recommendVC animated:YES IsNeedLogin:YES];
        }
        
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            AttentionViewController *attentionVC = [[AttentionViewController alloc] init];
            [self pushVC:attentionVC animated:YES IsNeedLogin:YES];
        } else {
            CollectViewController *collectVC = [[CollectViewController alloc] init];
            [self pushVC:collectVC animated:YES IsNeedLogin:YES];
        }
    } else if (indexPath.section == 3){
        SetUpViewController *setUp = [[SetUpViewController alloc] init];
        [self pushVC:setUp animated:YES IsNeedLogin:NO];
        /*
        if (indexPath.row == 0) {
            WalletViewController *walletVC = [[WalletViewController alloc] init];
            [self pushVC:walletVC animated:YES IsNeedLogin:YES];
        } else {
            SetUpViewController *setUp = [[SetUpViewController alloc] init];
            [self pushVC:setUp animated:YES IsNeedLogin:NO];
        }*/
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(20))];
    view.backgroundColor = RGBA(250, 250, 250, 1);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 0;
    }
    return GTH(20);
}

@end

