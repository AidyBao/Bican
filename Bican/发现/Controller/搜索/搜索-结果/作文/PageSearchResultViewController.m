//
//  PageSearchResultViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/16.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "PageSearchResultViewController.h"
#import "SearchCompositionTableViewCell.h"//作文
#import "FindListModel.h"

#import "FindDetailViewController.h"


@interface PageSearchResultViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation PageSearchResultViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"realoadPageList" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationAction:) name:@"realoadPageList" object:nil];
    
    [self getList];
    [self createTableView];
    
}

#pragma mark - 通知方法
- (void)getNotificationAction:(NSNotification *)notification
{
    NSDictionary *infoDic = [notification object];
    self.searhStr = [infoDic objectForKey:@"searchKey"];
    [self refreshData];
}

#pragma mark - 获取作文精选列表
- (void)getList
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //每页请求的数据个数
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    //请求开始的页数
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];
    [params setValue:self.searhStr forKey:@"keyWords"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/list", BASE_URL];
    
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
        NSDictionary *dataDic = [resultObject objectForKey:@"data"];
        NSDictionary *pages = [dataDic objectForKey:@"pages"];
        self.pageCount = [NSString stringWithFormat:@"%@", [pages objectForKey:@"pageCount"]];
        NSMutableArray *array = [dataDic objectForKey:@"list"];
        for (NSMutableDictionary *dic in array) {
            FindListModel *model = [[FindListModel alloc] init];
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

#pragma mark - 创建UITableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = GTH(180);
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
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
    [self getList];
    
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self getList];
}

#pragma mark - DZNEmptyDataSetSource协议方法
//设置title
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有搜到哦, 换个关键词试试呗 ";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(28), NSForegroundColorAttributeName:ZTTitleColor, NSParagraphStyleAttributeName:paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"search_no_img"];
}

#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //作文
    static NSString *defaultCellID = @"compositionCell";
    SearchCompositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[SearchCompositionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    FindListModel *model = self.dataSourceArray[indexPath.row];
    
    NSString *bigType = model.bigTypeName;
    NSString *type = model.typeName;
    NSString *nickname = model.nickname;
    NSString *schoolName = model.schoolName;
    
    cell.titleLabel.text = model.title;
    cell.keyWord = self.searhStr;
    if (type.length == 0) {
        cell.typeLabel.text = bigType;
    } else {
        cell.typeLabel.text = [NSString stringWithFormat:@"%@ · %@", bigType, type];
    }
    if (schoolName.length == 0) {
        cell.classLabel.text = nickname;
    } else if (nickname.length == 0) {
        cell.classLabel.text = schoolName;
    } else {
        cell.classLabel.text = [NSString stringWithFormat:@"%@ | %@", nickname, schoolName];
    }
    
    return cell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FindListModel *model = self.dataSourceArray[indexPath.row];
    //文章详情页面
    FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
    findDetailVC.articleIdStr = model.articleId;
    findDetailVC.isRecommend = model.isRecommend;
    [self.searchResultVC pushVC:findDetailVC animated:YES IsNeedLogin:NO];
    
}



@end
