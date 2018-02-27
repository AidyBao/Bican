//
//  UserIntroViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//  用户简介

#import "UserIntroViewController.h"
#import "UserIntroTableViewCell.h"

@interface UserIntroViewController () <UITableViewDataSource, UITableViewDelegate, UserIntroTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSString *isAttention;//记录关注的状态

@end

@implementation UserIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isAttention = self.userModel.isAttention;
    [self createTableView];
    
}

#pragma mark - 创建UITableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = GTH(255);
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
    }];
    
}

#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"userIntroCell";
    UserIntroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[UserIntroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    
    //记录初始的关注状态
    self.isAttention = self.userModel.isAttention;
    
    [cell setCellWithHeadImage:self.userModel.avatar
                      NickName:self.userModel.nickName
                    SchoolName:self.userModel.schoolName
                         Grade:self.userModel.grade
                       Comment:self.userModel.reviewNumber
                        Invite:self.userModel.inviteNumber
                   IsAttention:self.userModel.isAttention
                        UserId:self.userModel.userId];
    
    //设置星星
    [cell setUserIntroCellStar:self.userModel.goodReview];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UserIntroTableViewCellDelegate
- (void)attentionButtonWithCell:(UserIntroTableViewCell *)cell
{
    if ([self.isAttention isEqualToString:@"0"]) {
        [cell changeButtonWithTitle:@"已关注" Color:ZTLineGrayColor];
    } else {
        [cell changeButtonWithTitle:@"+ 加关注" Color:ZTOrangeColor];
    }
    //调用接口
    [self attentionChange];
}

#pragma mark - 关注/取消关注
- (void)attentionChange
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //关注用户ID
    [params setValue:self.userModel.userId forKey:@"attentionUserId"];
    //状态: 1-关注, 2-取消关注
    if ([self.isAttention isEqualToString:@"0"]) {
        self.isAttention = @"1";
        [params setValue:@"1" forKey:@"status"];
    } else {
        self.isAttention = @"0";
        [params setValue:@"2" forKey:@"status"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@api/user/attentionChange", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        if ([self.isAttention isEqualToString:@"0"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"取消关注成功" Time:3.0];
        }
        if ([self.isAttention isEqualToString:@"1"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"关注成功" Time:3.0];
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



@end
