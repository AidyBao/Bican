

//
//  OtherStudentInviteViewController.m
//  Bican
//
//  Created by bican on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "OtherStudentInviteViewController.h"
#import "InviteTableViewCell.h"
#import "InviteModel.h"
#import "InviteGiftModel.h"

@interface OtherStudentInviteViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *dealView;
@property (nonatomic, strong) UILabel *dealLabel;
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *refusedButton;
@property (nonatomic, strong) UIButton *acceptButton;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation OtherStudentInviteViewController

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
    if (![self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header beginRefreshing];
    }
    [self refreshData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"inviteReload" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"inviteReload" object:nil];
    
    [self createTableView];
    [self createhHeaderView];
}

#pragma mark - 创建头部的view
- (void)createhHeaderView
{
    self.dealView = [[UIView alloc] init];
    self.dealView.backgroundColor = ZTOrangeColor;
    [self.view addSubview:self.dealView];
    
    [self.dealView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(GTH(60));
    }];
    
    self.dealLabel = [[UILabel alloc] init];
    self.dealLabel.textColor = [UIColor whiteColor];
    self.dealLabel.font = FONT(24);
    self.dealLabel.text = @"待处理的邀请";
    [self.dealView addSubview:self.dealLabel];
    
    [self.dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dealView.mas_left).offset(GTW(20));
        make.centerY.equalTo(self.dealView);
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textColor = [UIColor whiteColor];
    self.numberLabel.font = FONT(24);
    [self.dealView addSubview:self.numberLabel];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.dealView.mas_right).offset(GTW(-20));
        make.centerY.equalTo(self.dealView);
    }];
    
    self.dealView.hidden = YES;
    
}

#pragma mark - 获取收到分类评阅邀请列表(我的学生/其他学生)
- (void)inviteMeListByType
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:@"2" forKey:@"type"];
    [params setValue:@"0" forKey:@"status"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/invite/inviteMeListByType", BASE_URL];
    
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
        //更新UI
        [self updateUI];
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

#pragma mark - 更新页面
- (void)updateUI
{
    if (self.dataSourceArray.count > 0) {
        self.dealView.hidden = NO;
        self.numberLabel.text = [NSString stringWithFormat:@"%ld条", self.dataSourceArray.count];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(GTH(60));
        }];
        
    } else {
        self.dealView.hidden = YES;
        self.numberLabel.text = @"";
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
        }];
    }
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
        make.top.equalTo(self.view);
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
    [self inviteMeListByType];
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self inviteMeListByType];
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
    InviteModel *inviteModel = self.dataSourceArray[indexPath.row];
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
    CGFloat button_width = GTW(120);
    CGFloat label_width = ScreenWidth - GTW(30) * 4 - button_width * 2;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(80))];
    view.backgroundColor = ZTOrangeColor;
    
    self.refusedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refusedButton.frame = CGRectMake(GTW(30), GTH(15), button_width, GTH(50));
    [self.refusedButton setTitle:@"拒绝" forState:UIControlStateNormal];
    [self.refusedButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.refusedButton.layer.borderColor = ZTTitleColor.CGColor;
    self.refusedButton.layer.borderWidth = 1;
    self.refusedButton.layer.cornerRadius = GTH(10);
    self.refusedButton.titleLabel.font = FONT(30);
    self.refusedButton.adjustsImageWhenHighlighted = NO;
    self.refusedButton.tag = section + 1122;
    [self.refusedButton addTarget:self action:@selector(refusedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.refusedButton];

    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.refusedButton.frame.size.width + self.refusedButton.frame.origin.x + GTW(30), 0, label_width, GTH(80))];
    centerLabel.text = @"(请在24小时内完成处理)";
    centerLabel.textColor = ZTTitleColor;
    centerLabel.font = FONT(28);
    centerLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:centerLabel];
    
    self.acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.acceptButton.frame = CGRectMake(centerLabel.frame.size.width + centerLabel.frame.origin.x + GTW(30), GTH(15), button_width, GTH(50));
    [self.acceptButton setTitle:@"接受" forState:UIControlStateNormal];
    [self.acceptButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    [self.acceptButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.acceptButton.adjustsImageWhenHighlighted = NO;
    self.acceptButton.layer.borderColor = ZTTitleColor.CGColor;
    self.acceptButton.layer.cornerRadius = GTH(10);
    self.acceptButton.layer.borderWidth = 1;
    self.acceptButton.titleLabel.font = FONT(30);
    self.acceptButton.tag = section + 3322;
    [self.acceptButton addTarget:self action:@selector(acceptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.acceptButton];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteModel *inviteModel = self.dataSourceArray[indexPath.row];
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

#pragma mark - 接受按钮
- (void)acceptButtonAction:(UIButton *)button
{
    InviteModel *inviteModel = self.dataSourceArray[button.tag - 3322];
    [self handleInviteWithStauts:@"1" InviteId:inviteModel.invite_id];

}

#pragma mark - 拒绝按钮
- (void)refusedButtonAction:(UIButton *)button
{
    InviteModel *inviteModel = self.dataSourceArray[button.tag - 1122];
    [self handleInviteWithStauts:@"2" InviteId:inviteModel.invite_id];
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
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
        //重新请求, 刷新页面
        [self inviteMeListByType];
        
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
