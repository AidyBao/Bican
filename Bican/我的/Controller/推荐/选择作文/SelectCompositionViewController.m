//
//  SelectCompositionViewController.m
//  Bican
//
//  Created by bican on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "SelectCompositionViewController.h"
#import "SelectCompositionTableViewCell.h"
#import "SelectCompositionModel.h"
#import "InvistToRecommedModel.h"

#import "FindDetailViewController.h"

@interface SelectCompositionViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, SelectCompositionTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *invistArray;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@property (nonatomic, strong) NSString *selectedRow;//选中的按钮下标

@end

@implementation SelectCompositionViewController

- (NSMutableArray *)invistArray
{
    if (!_invistArray) {
        _invistArray = [NSMutableArray array];
    }
    return _invistArray;
}

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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择作文";
    
    [self createTableView];
}

#pragma mark - 创建TableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = GTH(125);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0)];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
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
    if (self.isFromeInvist) {
        [self inviteMe];
    } else {
        [self pubList];
    }
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    
    if (self.isFromeInvist) {
        [self inviteMe];
    } else {
        [self pubList];
    }
    
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
    if (self.isFromeInvist) {
        return self.invistArray.count;
        
    } else {
        return self.dataSourceArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"selectCompositionCell";
    SelectCompositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[SelectCompositionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.delegate = self;
    
    if (self.isFromeInvist) {
        if (self.invistArray.count == 0) {
            return cell;
        }
        InvistToRecommedModel *model = self.invistArray[indexPath.row];
        [cell createSelectCompositionControllerWithBigTypeName:model.bigTypeName Title:model.title IsRecommend:model.isRecommend];
        
    } else {
        
        if (self.dataSourceArray.count == 0) {
            return cell;
        }
        SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
        [cell createSelectCompositionControllerWithBigTypeName:model.typeName Title:model.title IsRecommend:model.isRecommend];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSourceArray.count == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isFromeInvist) {
        InvistToRecommedModel *model = self.dataSourceArray[indexPath.row];
        //跳转文章详情
        FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
        findDetailVC.isRecommend = model.isRecommend;
        findDetailVC.articleIdStr = model.articleId;
        [self pushVC:findDetailVC animated:YES IsNeedLogin:YES];
        
    } else {
        SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
        //跳转文章详情
        FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
        findDetailVC.isRecommend = model.isRecommend;
        findDetailVC.articleIdStr = model.composition_id;
        [self pushVC:findDetailVC animated:YES IsNeedLogin:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  GTH(110) + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(110) + 1)];
    view.backgroundColor = [UIColor whiteColor];
    
    UserInformation *user = [GetUserInfo getUserInfoModel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(GTW(30), 0, ScreenWidth - GTW(30) * 3 - GTW(80), view.frame.size.height - 1)];
    if (self.isFromeInvist) {
        label.text = @"邀请我评阅的";
    } else {
        label.text = [NSString stringWithFormat:@"%@ %@", user.schoolName, user.className];
    }
    label.textColor = ZTTitleColor;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [view addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, GTH(110), ScreenWidth, 1)];
    lineView.backgroundColor = ZTLineGrayColor;
    [view addSubview:lineView];
    
    return view;
}

#pragma mark - SelectCompositionTableViewCellDelegate
- (void)selectCompositionToRecommend:(SelectCompositionTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.selectedRow = [NSString stringWithFormat:@"%ld", indexPath.row];
    
    if (self.isFromeInvist) {
        InvistToRecommedModel *model = self.invistArray[indexPath.row];
        if ([model.isRecommend isEqualToString:@"0"]) {//未推荐
            [self recommend_articleWithId:model.articleId];
        }
    } else {
        SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
        if ([model.isRecommend isEqualToString:@"0"]) {//未推荐
            [self recommend_articleWithId:model.composition_id];
        }
    }
    
}

#pragma mark - 推荐作文接口
- (void)recommend_articleWithId:(NSString *)string
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:string forKey:@"articleId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/recommend", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"推荐作文成功" Time:3.0];
        [self refreshData];
        
    } errorHandler:^(NSError *error) {
        
        [self hideLoading];
        
    } reloadHandler:^(BOOL isReload) {
        
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 获取学生文集列表
- (void)pubList
{
    if (self.studentId.length == 0) {
        return;
    }
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //评阅状态: 0-表示未评阅,1-表示已评阅
    [params setValue:@"0" forKey:@"IsComment"];
    [params setValue:self.studentId forKey:@"studentId"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];

    NSString *url = [NSString stringWithFormat:@"%@api/article/pubList", BASE_URL];

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
            SelectCompositionModel *model = [[SelectCompositionModel alloc] init];
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

#pragma mark - 获取老师推荐作文列表
- (void)inviteMe
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];

    NSString *url = [NSString stringWithFormat:@"%@api/invite/inviteMe", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (self.isUpData == NO) {
            [self.invistArray removeAllObjects];
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
            InvistToRecommedModel *model = [[InvistToRecommedModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.invistArray addObject:model];
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


@end
