//
//  AllInviteViewController.m
//  Bican
//
//  Created by chichen on 2018/1/10.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AllInviteViewController.h"
#import "InviteTableViewCell.h"
#import "InviteModel.h"
#import "InviteGiftModel.h"
#import "InvitFooterView.h"

#import "CorrectViewController.h"
#import "CommendArticleDetailViewController.h"
#import "FindDetailViewController.h"

@interface AllInviteViewController ()<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, InvitFooterViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *refusedButton;
@property (nonatomic, strong) UIButton *acceptButton;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation AllInviteViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部邀请";
    
    [self createTableView];
    
}

#pragma mark - 获取收到评阅邀请列表
- (void)getAllInviteMeList
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //状态: 0-待处理, 1-已接受, 2-已拒绝, 3-全部
    [params setValue:@"3" forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];

    NSString *url = [NSString stringWithFormat:@"%@api/invite/inviteMeList", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (self.isUpData == NO) {
            [self.dataSourceArray removeAllObjects];
        }
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dataDic = [resultObject objectForKey:@"data"];
        NSMutableDictionary *pages = [dataDic objectForKey:@"pages"];
        self.pageCount = [pages objectForKey:@"pageCount"];
        NSMutableArray *listArray = [dataDic objectForKey:@"list"];
        for (NSMutableDictionary *dic in listArray) {
            InviteModel *model = [[InviteModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
        }
        [self.tableView reloadData];
        if ([self.pageCount integerValue] <= self.start_row) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } errorHandler:^(NSError *error) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        
    } reloadHandler:^(BOOL isReload) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 创建TableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
    }];
    //刷新数据
    //mj_header
    self.tableView.mj_header = [self createMJRefreshGifHeaderWithSelector:@selector(refreshData)];
    
    //mj_footer
    self.tableView.mj_footer = [self createMJRefreshBackGifFooterWithSelector:@selector(loadMoreData)];
    
    if (![self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

//刷新数据
- (void)refreshData
{
    self.isUpData = NO;
    self.start_row = 1;
    self.page_size = 10;
    [self getAllInviteMeList];
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self getAllInviteMeList];
}

#pragma mark - DZNEmptyDataSetSource协议方法
//设置title
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"什么都没有";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(28), NSForegroundColorAttributeName:ZTTitleColor, NSParagraphStyleAttributeName:paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_neirong"];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inviteCell"];
    if (!cell) {
        cell = [[InviteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"inviteCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    InviteModel *inviteModel = self.dataSourceArray[indexPath.section];
    NSMutableArray *flowerListArray = inviteModel.flowerList;
    NSMutableArray *array = [NSMutableArray array];
    for (NSMutableDictionary *dic in flowerListArray) {
        InviteGiftModel *model = [[InviteGiftModel alloc] init];
        NSString *string = [NSString string];
        [model setValuesForKeysWithDictionary:dic];
        string = [NSString stringWithFormat:@"并向你赠送礼物%@朵%@", model.currency, model.name];
        [array addObject:string];
    }
    [cell createInviteViewControllerWithNickname:inviteModel.nickname
                                      SchoolName:inviteModel.schoolName
                                           Title:inviteModel.title
                                       Frequency:inviteModel.frequency
                                          Status:inviteModel.status
                                          Flower:[array componentsJoinedByString:@","]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  GTH(86);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(86))];
    view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth / 2) - GTW(125), GTH(30), GTW(250), GTH(25))];
    InviteModel *inviteModel = self.dataSourceArray[section];
    label.text = inviteModel.sendDatetime;
    label.textColor = ZTTextGrayColor;
    label.font = FONT(24);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return GTH(80);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, ScreenWidth, GTH(80));
    view.backgroundColor = [UIColor redColor];
    InviteModel *inviteModel = self.dataSourceArray[section];

    InvitFooterView *footerView = [[InvitFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(80))];
    footerView.delegate = self;
    footerView.tag = 10000 + section;
    [view addSubview:footerView];

    //0-待处理, 1-待评阅 2-已评, 3-已拒绝
    //4-超时未处理，已自动取消邀请, 5-邀请已撤回
    if ([inviteModel.status isEqualToString:@"0"]) {
        [footerView createInvitFooterViewWithTitle:@"待处理" TitleColor:ZTRedColor SureButtonTitle:@"接受" NoButtonTitle:@"拒绝"];
    }
    if ([inviteModel.status isEqualToString:@"1"]) {
        [footerView createInvitFooterViewWithTitle:@"待评阅" TitleColor:ZTBlueColor ButtonTitle:@"评阅作文"];
    }
    if ([inviteModel.status isEqualToString:@"2"]) {
        [footerView createInvitFooterViewWithTitle:inviteModel.statusStr TitleColor:ZTBlueColor ButtonTitle:@"查看"];
    }
    if ([inviteModel.status isEqualToString:@"3"]) {
        [footerView createInvitFooterViewWithTitle:inviteModel.statusStr Color:ZTRedColor IsShowAskButton:NO];
    }
    if ([inviteModel.status isEqualToString:@"4"]) {
        [footerView createInvitFooterViewWithTitle:inviteModel.statusStr Color:[UIColor whiteColor] IsShowAskButton:YES];
    }
    if ([inviteModel.status isEqualToString:@"5"]) {
        [footerView createInvitFooterViewWithTitle:inviteModel.statusStr Color:[UIColor whiteColor] IsShowAskButton:NO];
    }

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteModel *inviteModel = self.dataSourceArray[indexPath.section];
    NSMutableArray *flowerListArray = inviteModel.flowerList;
    NSMutableArray *array = [NSMutableArray array];
    for (NSMutableDictionary *dic in flowerListArray) {
        InviteGiftModel *model = [[InviteGiftModel alloc] init];
        NSString *string = [NSString string];
        [model setValuesForKeysWithDictionary:dic];
        string = [NSString stringWithFormat:@"并向你赠送礼物%@朵%@", model.currency, model.name];
        [array addObject:string];
    }
    
    CGFloat width = ScreenWidth - GTW(30) * 4 - GTW(42) - 1 - GTW(10) - GTW(20);
    CGSize size = [self getSizeWithString:[array componentsJoinedByString:@","] font:FONT(24) str_width:width];

    return size.height + GTH(280);

}

#pragma mark - InvitFooterViewDelegate
//拒绝按钮
- (void)buttonToNoWithView:(InvitFooterView *)view
{
    InviteModel *inviteModel = self.dataSourceArray[view.tag - 10000];
    [self handleInviteWithStauts:@"2" InviteId:inviteModel.invite_id];
}
//确认按钮
- (void)buttonToSureWithView:(InvitFooterView *)view
{
    //0-待处理-接受
    InviteModel *inviteModel = self.dataSourceArray[view.tag - 10000];
    if ([inviteModel.status isEqualToString:@"0"]) {
        [self handleInviteWithStauts:@"1" InviteId:inviteModel.invite_id];
    }
    //1-待评阅-评阅作文
    if ([inviteModel.status isEqualToString:@"1"]) {
        CommendArticleDetailViewController *detailVC = [[CommendArticleDetailViewController alloc] init];
        detailVC.inviteModel = inviteModel;
        [self pushVC:detailVC animated:YES IsNeedLogin:YES];
    }
    //2-已评阅-查看
    if ([inviteModel.status isEqualToString:@"2"]) {
        FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
        findDetailVC.articleIdStr = inviteModel.articleId;
        findDetailVC.isRecommend = inviteModel.isRecommend;
        [self pushVC:findDetailVC animated:YES IsNeedLogin:YES];
    }
    

}
//问号
- (void)buttonToAskWithView:(InvitFooterView *)view
{

}

#pragma mark - 接受/拒绝评阅
- (void)handleInviteWithStauts:(NSString *)stauts InviteId:(NSString *)inviteId
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //评阅邀请ID
    [params setValue:inviteId forKey:@"inviteId"];
    //状态:1-接受, 2-拒绝
    [params setValue:stauts forKey:@"status"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/invite/handleInvite", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            return;
        }
        //更新table
        [self updateTableWithStauts:stauts];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];
        
    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 更新table
- (void)updateTableWithStauts:(NSString *)stauts
{
    if ([stauts isEqualToString:@"2"]) {
        //拒绝
        [self refreshData];
    } else {
        //接受 - 弹窗提示
        [self showAlert];
    }
    
}

#pragma mark - 提示框
- (void)showAlert
{
    //获取记录的是否提示
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:@"isShowInvite"];
    
    if (string.length != 0) {
        return;
    }
    NSString *titleStr = @"提示";
    NSString *messageStr = @"已接受邀请, 在\"我的-评阅\"页面查看待评阅的作文";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不再提示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //记录已经提示过了
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"isShowInvite"];
        
    }];
    [cancelAction setValue:ZTTitleColor forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //我的-评阅
        CorrectViewController *correctVC = [[CorrectViewController alloc] init];
        [self pushVC:correctVC animated:YES IsNeedLogin:YES];
        
    }];
    [sureAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


@end
