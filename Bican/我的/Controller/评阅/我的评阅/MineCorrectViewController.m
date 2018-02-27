
//
//  MineCorrectViewController.m
//  Bican
//
//  Created by bican on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MineCorrectViewController.h"
#import "MineCorrectTableViewCell.h"
#import "MineReviewModel.h"
#import "InviteGiftModel.h"

#import "FindDetailViewController.h"

@interface MineCorrectViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation MineCorrectViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"childReload" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"childReload" object:nil];
    
    [self createTableView];
    
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
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
    [self inviteMe];
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self inviteMe];
}


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
            MineReviewModel *model = [[MineReviewModel alloc] init];
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

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"attentionTableViewCell";
    MineCorrectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MineCorrectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    MineReviewModel *reviewModel = self.dataSourceArray[indexPath.row];
    NSMutableArray *flowerListArray = reviewModel.flowerList;
    NSMutableArray *array = [NSMutableArray array];
    for (NSMutableDictionary *dic in flowerListArray) {
        InviteGiftModel *model = [[InviteGiftModel alloc] init];
        NSString *string = [NSString string];
        [model setValuesForKeysWithDictionary:dic];
        string = [NSString stringWithFormat:@"评阅可得：%@朵%@", model.currency, model.name];
        [array addObject:string];
    }
    
    [cell createMineReviewTableViewWithAvatar:reviewModel.avatar
                                     Nickname:reviewModel.nickname
                                   SchoolName:reviewModel.schoolName
                                  BigTypeName:reviewModel.bigTypeName
                                        Title:reviewModel.title
                                      Summary:reviewModel.summary
                                       Flower:[array componentsJoinedByString:@","]
                              ArticleFraction:reviewModel.articleFraction];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MineReviewModel *reviewModel = self.dataSourceArray[indexPath.row];
    //文章详情
    FindDetailViewController *findVC = [[FindDetailViewController alloc] init];
    findVC.articleIdStr = reviewModel.articleId;
    findVC.isRecommend = reviewModel.isRecommend;
    [self.correctVC pushVC:findVC animated:YES IsNeedLogin:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineReviewModel *reviewModel = self.dataSourceArray[indexPath.row];
    NSMutableArray *flowerListArray = reviewModel.flowerList;
    NSMutableArray *array = [NSMutableArray array];
    for (NSMutableDictionary *dic in flowerListArray) {
        InviteGiftModel *model = [[InviteGiftModel alloc] init];
        NSString *string = [NSString string];
        [model setValuesForKeysWithDictionary:dic];
        string = [NSString stringWithFormat:@"评阅可得：%@朵%@", model.currency, model.name];
        [array addObject:string];
    }
    
    CGFloat width = ScreenWidth - GTW(30) * 2;
    
    CGSize titleSize = [self getSizeWithString:reviewModel.title font:[UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)] str_width:width];
//    CGSize descSize = [self getSizeWithString:reviewModel.summary font:FONT(28) str_width:width];
    CGSize flowerSize = [self getSizeWithString:[array componentsJoinedByString:@","] font:[UIFont fontWithName:@"Helvetica-Bold" size:GTW(26)] str_width:width - GTW(10) - GTW(35)];
    
    return GTH(36) + GTH(50) + GTH(34) + titleSize.height + GTH(28) + GTH(120) + GTH(20) * 4 + 1 + flowerSize.height + GTH(40);
    
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



@end
