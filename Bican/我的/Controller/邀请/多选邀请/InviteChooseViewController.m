//
//  InviteChooseViewController.m
//  Bican
//
//  Created by chichen on 2018/1/10.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "InviteChooseViewController.h"
#import "InviteChooseTableViewCell.h"
#import "InviteModel.h"
#import "InviteGiftModel.h"

@interface InviteChooseViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, InviteChooseTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellSelectedArray;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *selectedAllButton;//全选按钮
@property (nonatomic, strong) UILabel *selectedAllLabel;
@property (nonatomic, assign) BOOL isSelectedAll;//是否全选

@property (nonatomic, strong) UIButton *refusedButton;
@property (nonatomic, strong) UIButton *acceptButton;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation InviteChooseViewController

- (NSMutableArray *)cellSelectedArray
{
    if (!_cellSelectedArray) {
        _cellSelectedArray = [NSMutableArray array];
        if (_dataSourceArray.count > 0) {
            for (int i = 0; i < _dataSourceArray.count; i++) {
                [_cellSelectedArray addObject:@"NO"];
            }
        }
    }
    return _cellSelectedArray;
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
    
    self.title = @"待处理的邀请";
    
    //默认不全选
    self.isSelectedAll = NO;
    
    [self createBottomView];
    [self createTableView];    
}

#pragma mark - 获取收到分类评阅邀请列表(我的学生/其他学生)
- (void)inviteMeListByType
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:@"1" forKey:@"type"];
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


#pragma mark - 创建
- (void)createBottomView
{
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = ZTOrangeColor;
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(GTH(96));
    }];
    
    self.selectedAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedAllButton setImage:[UIImage imageNamed:@"duihuan_checkbox"] forState:UIControlStateNormal];
    [self.selectedAllButton setImage:[UIImage imageNamed:@"duihuan_checkbox_a"] forState:UIControlStateSelected];
    [self.selectedAllButton addTarget:self action:@selector(selectedAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.selectedAllButton];
    
    [self.selectedAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(GTW(30));
        make.centerY.equalTo(self.bottomView);
        make.width.height.mas_equalTo(GTH(38));
    }];
    
    self.selectedAllLabel = [[UILabel alloc] init];
    self.selectedAllLabel.text = @"全选";
    self.selectedAllLabel.font = FONT(26);
    self.selectedAllLabel.textColor = ZTTitleColor;
    [self.bottomView addSubview:self.selectedAllLabel];
    
    [self.selectedAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedAllButton.mas_right).offset(GTW(21));
        make.centerY.equalTo(self.bottomView);
    }];
    
    self.acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.acceptButton.layer.cornerRadius = GTH(25);
    [self.acceptButton setTitle:@"接受" forState:UIControlStateNormal];
    self.acceptButton.adjustsImageWhenHighlighted = NO;
    [self.acceptButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    self.acceptButton.tag = 1111;
    self.acceptButton.titleLabel.font = FONT(28);
    [self.acceptButton setBackgroundColor:[UIColor whiteColor]];
    [self.acceptButton addTarget:self action:@selector(markCompositopns:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.acceptButton];
    
    [self.acceptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(GTW(-20));
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(GTW(100), GTH(65)));
    }];
    
    self.refusedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refusedButton.layer.cornerRadius = GTH(25);
    [self.refusedButton setTitle:@"拒绝" forState:UIControlStateNormal];
    self.refusedButton.adjustsImageWhenHighlighted = NO;
    [self.refusedButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    self.refusedButton.tag = 2222;
    self.refusedButton.titleLabel.font = FONT(28);
    [self.refusedButton setBackgroundColor:[UIColor whiteColor]];
    [self.refusedButton addTarget:self action:@selector(markCompositopns:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.refusedButton];

    [self.refusedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.acceptButton).offset(GTW(-130));
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(GTW(100), GTH(65)));
    }];
    
}

#pragma mark - 全选 || 反全选
- (void)selectedAllButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.isSelectedAll = sender.selected;
    
    [self.cellSelectedArray removeAllObjects];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        if (self.isSelectedAll) {
            [self.cellSelectedArray addObject:@"YES"];
        } else {
            [self.cellSelectedArray addObject:@"NO"];
        }
    }
    
    [self.tableView reloadData];
    
}

#pragma makr - 创建TableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom).offset(GTH(-96));
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"compositionsSelectedCell";
    InviteChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[InviteChooseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    
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
    
    [cell createInviteChooseCellWithNickname:inviteModel.nickname
                                  SchoolName:inviteModel.schoolName
                                       Title:inviteModel.title
                                   Frequency:inviteModel.frequency
                                      Status:inviteModel.status
                                      Flower:[array componentsJoinedByString:@","]];
    
    //设置cell是否选中
    [cell setCellIsSelected:self.cellSelectedArray[indexPath.row]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string = self.cellSelectedArray[indexPath.row];
    if ([string isEqualToString:@"NO"]) {
        string = @"YES";
        [self.cellSelectedArray replaceObjectAtIndex:indexPath.row withObject:string];
    } else {
        string = @"NO";
        [self.cellSelectedArray replaceObjectAtIndex:indexPath.row withObject:string];
    }
    InviteChooseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setCellIsSelected:self.cellSelectedArray[indexPath.row]];
    [self checkIsAll];

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

#pragma mark - CompositionSelectedCellDelegate
- (void)selecetedCell:(InviteChooseTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    NSString *string = self.cellSelectedArray[indexPath.row];
    if ([string isEqualToString:@"NO"]) {
        string = @"YES";
        [self.cellSelectedArray replaceObjectAtIndex:indexPath.row withObject:string];
    } else {
        string = @"NO";
        [self.cellSelectedArray replaceObjectAtIndex:indexPath.row withObject:string];
    }
    [cell setCellIsSelected:self.cellSelectedArray[indexPath.row]];
    [self checkIsAll];
    
}

#pragma mark - 是否为全选
- (void)checkIsAll
{
    if (![self.cellSelectedArray containsObject:@"NO"]) {
        //全选
        self.selectedAllButton.selected = YES;
    } else if (![self.cellSelectedArray containsObject:@"YES"]) {
        //全不选
        self.selectedAllButton.selected = NO;
    }

}

#pragma mark - 拒绝或者接受按钮
- (void)markCompositopns:(UIButton *)sender
{
    NSString *stauts = [NSString string];
    if (sender.tag == 1111) {
        //接受
        stauts = @"0";
    } else {
        //拒绝
        stauts = @"1";
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.cellSelectedArray.count; i++) {
        if ([self.cellSelectedArray[i] isEqualToString:@"YES"]) {
            InviteModel *inviteModel = self.dataSourceArray[i];
            [array addObject:inviteModel.invite_id];
        }
    }
    //调用接口
    [self handleInviteWithStauts:stauts InviteId:[array componentsJoinedByString:@","]];
    
}

#pragma mark - 接受/拒绝评阅
- (void)handleInviteWithStauts:(NSString *)stauts InviteId:(NSString *)inviteId
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //评阅邀请ID(","分割)
    [params setValue:inviteId forKey:@"invitedIds"];
    //状态:0-接受, 1-拒绝
    [params setValue:stauts forKey:@"type"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/invite/receiveByIds", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [self popVCAnimated:YES];
        
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
