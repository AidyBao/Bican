//
//  MineNoLoginViewController.m
//  Bican
//
//  Created by chichen on 2017/12/24.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MineNoLoginViewController.h"
#import "MineTableViewCell.h"
#import "MineNoLoginHeaderView.h"

#import "MineLoginViewController.h"
#import "SetUpViewController.h"

@interface MineNoLoginViewController ()<UITableViewDelegate, UITableViewDataSource, MineNoLoginHeaderViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineNoLoginHeaderView *tableHeaderView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation MineNoLoginViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
//        _dataSourceArray = [NSMutableArray arrayWithObjects:@"评阅", @"收藏", @"钱包", @"设置", nil];
        _dataSourceArray = [NSMutableArray arrayWithObjects:@"评阅", @"收藏", @"设置", nil];
    }
    return _dataSourceArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = GTH(125);
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = [self createTableHeaderView];
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    
}

- (MineNoLoginHeaderView *)createTableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[MineNoLoginHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(628))];
        _tableHeaderView.delegate = self;
    }
    return _tableHeaderView;
}

#pragma mark - MineNoLoginHeaderViewDelegate
- (void)pushToVCWithTag:(NSInteger)tag
{
//    if (tag == 1001) {
        MineLoginViewController *mineLoginVC = [[MineLoginViewController alloc] init];
        [self pushVC:mineLoginVC animated:YES IsNeedLogin:NO];
//        NSLog(@"登录");
//    }
//    if (tag == 1002) {
//        NSLog(@"文集");
//    }
//    if (tag == 1003) {
//        NSLog(@"草稿");
//    }
//    if (tag == 1004) {
//        NSLog(@"关注");
//    }
//    if (tag == 1005) {
//        NSLog(@"发邀请");
//    }
//    if (tag == 1006) {
//        NSLog(@"收邀请");
//    }
}

#pragma mark - TableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"mineNoLoginTableViewCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    [cell setMineTableViewCellWithLeftText:self.dataSourceArray[indexPath.row] LeftFont:FONT(30) LeftColor:ZTTitleColor RightText:@"" RightFont:FONT(30) RightColor:ZTTitleColor IsShowButton:YES];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
    //if (indexPath.row == 3) {
        //设置
        SetUpViewController *setupVC = [[SetUpViewController alloc] init];
        [self pushVC:setupVC animated:YES IsNeedLogin:NO];
        
    } else {
        MineLoginViewController *mineLoginVC = [[MineLoginViewController alloc] init];
        [self pushVC:mineLoginVC animated:YES IsNeedLogin:YES];
    }
}



@end
