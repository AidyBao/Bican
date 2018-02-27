//
//  RecommendViewController.m
//  Bican
//
//  Created by bican on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "RecommendViewController.h"
#import "RecommendTableViewCell.h"
#import "SelectRangeViewController.h"
#import "RecommendListModel.h"

#import "FindDetailViewController.h"

@interface RecommendViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation RecommendViewController

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
    
    self.title = @"推荐";
    [self createRightNavigationItem:nil Title:@"推荐作文" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:GTH(10)];
    
    [self createTableView];
}

#pragma mark - 右按钮, 推荐作文
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    [self getRecommendCountUpdate];
}

#pragma mark - 查询是否本周可以推荐作文
- (void)getRecommendCountUpdate
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/getRecommendCountUpdate", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [self hideLoading];
        NSMutableDictionary *dataDic = [resultObject objectForKey:@"data"];
        //recommendCount:本周已推荐的文章数
        //avaiableRecomment: 这周还能推荐的文章数
        NSString *avaiableRecomment = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"avaiableRecomment"]];
        NSInteger currunt = [avaiableRecomment integerValue];
        if (currunt > 0) {
            //选择范围
            SelectRangeViewController *selectRangeVC = [[SelectRangeViewController alloc] init];
            [self pushVC:selectRangeVC animated:YES IsNeedLogin:YES];
        } else {
            [ZTToastUtils showToastIsAtTop:NO Message:@"每周最多只能推荐4篇作文" Time:3.0];
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
    self.tableView.rowHeight = GTH(128);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
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
    [self recommendList];
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self recommendList];
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
    static NSString *recommendCell = @"recommendCell";
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendCell];
    if (!cell) {
        cell = [[RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recommendCell];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    RecommendListModel *model = self.dataSourceArray[indexPath.row];
    NSString *date = [NSString newStringDateFromString:[NSString getStringFromTime:model.recommendDate]];
    
    [cell createRecommendTableViewWithNickname:model.nickname
                                   BigTypeName:model.bigTypeName
                                 RecommendDate:date
                                  ArticleTitle:model.articleTitle];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RecommendListModel *recommendList = self.dataSourceArray[indexPath.row];
    //跳转到详情界面
    FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
    findDetailVC.articleIdStr = recommendList.articleId;
    findDetailVC.isRecommend = recommendList.isRecommend;
    [self pushVC:findDetailVC animated:YES IsNeedLogin:YES];
    
}

#pragma mark - 获取老师推荐作文列表
- (void)recommendList
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];

    NSString *url = [NSString stringWithFormat:@"%@api/article/recommendList", BASE_URL];
    
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
            RecommendListModel *recommendListModel = [[RecommendListModel alloc] init];
            [recommendListModel setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:recommendListModel];
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

