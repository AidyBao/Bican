//
//  StudentCorrectViewController.m
//  Bican
//
//  Created by bican on 2018/1/28.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "StudentCorrectViewController.h"
#import "SelectCompositionTableViewCell.h"
#import "ZTChangeTopView.h"
#import "SelectCompositionModel.h"

#import "FindDetailViewController.h"
#import "CompositionSelectedViewController.h"

@interface StudentCorrectViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, SelectCompositionTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZTChangeTopView *changeTopView;
@property (nonatomic, assign) NSInteger selectedTitleIndex;//记录选中的下标

@property (nonatomic, strong) NSArray *noReadArray;
@property (nonatomic, strong) NSArray *isReadArray;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation StudentCorrectViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"correct" object:nil];
}

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (NSArray *)isReadArray
{
    if (!_isReadArray) {
        _isReadArray = @[@"您本周已经推荐了4篇作文，不能再推荐更多了"];
    }
    return _isReadArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"correct" object:nil];

    [self createTableView];
}

- (void)getData:(NSNotification *)notification
{
    NSMutableDictionary *dic = [notification object];
    self.studentIdStr = [dic objectForKey:@"studentId"];
    self.startDate = [dic objectForKey:@"startDate"];
    self.endDate = [dic objectForKey:@"endDate"];

    [self refreshData];
    
}

#pragma mark - 创建TableView
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
    self.tableView.rowHeight = GTH(140);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
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
    [self pubListByWeeks];
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self pubListByWeeks];
}


#pragma mark - 获取学生文集列表
- (void)pubListByWeeks
{
    if (self.studentIdStr.length == 0) {
        return;
    }
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //评阅状态: 0-表示未评阅,1-表示已评阅
    [params setValue:@"1" forKey:@"IsComment"];
    [params setValue:self.startDate forKey:@"startDate"];
    [params setValue:self.endDate forKey:@"endDate"];
    [params setValue:self.studentIdStr forKey:@"studentId"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];
    NSString *url = [NSString stringWithFormat:@"%@api/article/pubListByWeeks", BASE_URL];
    
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
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"studentCompositionsClassCell";
    SelectCompositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[SelectCompositionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    
    SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
    
    [cell createSelectCompositionControllerWithBigTypeName:[NSString stringWithFormat:@"%@|%@", model.bigTypeName, model.typeName] Title:model.title IsRecommend:model.isRecommend];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
    FindDetailViewController *findDetail = [[FindDetailViewController alloc] init];
    findDetail.articleIdStr = model.composition_id;
    
    [self.studentCompostionsVC pushVC:findDetail animated:YES IsNeedLogin:YES];

}

#pragma mark - 协议
- (void)selectCompositionToRecommend:(SelectCompositionTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
    [self recommend_articleWithId:model.composition_id];
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

@end
