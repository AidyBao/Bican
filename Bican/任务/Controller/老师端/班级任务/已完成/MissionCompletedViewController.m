//
//  MissionCompletedViewController.m
//  Bican
//
//  Created by bican on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MissionCompletedViewController.h"
#import "MissionClassTableViewCell.h"//未完成
#import "MissionGradeModel.h"
#import "StudentCompositionsViewController.h"

@interface MissionCompletedViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectedIndex;//记录选中的位置
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前位置
@property (nonatomic, strong) NSString *pageCount;//总页数(number)
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉

@end

@implementation MissionCompletedViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"misson" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData:) name:@"misson" object:nil];

    [self createTableView];
}

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

#pragma mark - 通知接收数据, 重新请求数据
- (void)getData:(NSNotification *)notification
{
    NSMutableDictionary *dic = [notification object];
    self.classId = [dic objectForKey:@"classId"];
    self.startDate = [dic objectForKey:@"startDate"];
    self.endDate = [dic objectForKey:@"endDate"];
    [self refreshData];
    
}

#pragma mark - 获取班级任务列表
- (void)classList
{
    if (self.classId.length == 0 || self.startDate.length == 0 || self.endDate.length == 0) {
        return;
    }
   
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    //完成情况: 0-未完成, 1-已完成
    [params setValue:@"1" forKey:@"status"];
    [params setValue:self.classId forKey:@"classId"];
    [params setValue:self.startDate forKey:@"startDate"];
    [params setValue:self.endDate forKey:@"endDate"];
    
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];

    NSString *url = [NSString stringWithFormat:@"%@api/task/classList", BASE_URL];
    
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
            MissionGradeModel *model = [[MissionGradeModel alloc] init];
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
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = GTH(100);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
    }];
    
    //刷新数据
    //mj_header
    self.tableView.mj_header = [self createMJRefreshGifHeaderWithSelector:@selector(refreshData)];
    
    //mj_footer
    self.tableView.mj_footer = [self createMJRefreshBackGifFooterWithSelector:@selector(loadMoreData)];
    
    
}

//刷新数据
- (void)refreshData
{
    self.isUpData = NO;
    self.start_row = 1;
    self.page_size = 10;
    [self classList];
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self classList];
    
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
    static NSString *defaultCellID = @"missionNoClassCell";
    MissionClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MissionClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    MissionGradeModel *model = self.dataSourceArray[indexPath.row];
    
    [cell createMissionGradeTableViewWithFirstName:model.firstName
                                          LastName:model.lastName
                                         WordCount:model.wordCount
                                       InviteCount:model.inviteCount];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.dataSourceArray.count == 0) {
        return;
    }
    MissionGradeModel *model = self.dataSourceArray[indexPath.row];
    
    //跳转到 -> 学生文集
    StudentCompositionsViewController *studentVC = [[StudentCompositionsViewController alloc] init];
    studentVC.nickName = model.nickname;
    studentVC.studentIdStr = model.studentId;
    studentVC.startDate = self.startDate;
    studentVC.endDate = self.endDate;
    
    [self.missionClassVC pushVC:studentVC animated:YES IsNeedLogin:YES];
    
}


@end
