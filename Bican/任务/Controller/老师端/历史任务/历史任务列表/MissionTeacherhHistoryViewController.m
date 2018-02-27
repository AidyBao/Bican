//
//  MissionTeacherhHistoryViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MissionTeacherhHistoryViewController.h"
#import "MissionTeacherTableViewCell.h"
#import "MissionModel.h"
#import "MissionClassModel.h"

#import "MissionClassViewController.h"
#import "MissionFilterViewController.h"

@interface MissionTeacherhHistoryViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MissionFilterViewControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *startDateArray;//开始时间数组
@property (nonatomic, strong) NSMutableArray *endDateArray;//开始时间数组

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前位置
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@property (nonatomic, strong) NSString *begin_startDate;//开始时间区间
@property (nonatomic, strong) NSString *begin_endDate;

@property (nonatomic, strong) NSString *end_startDate;//结束时间区间
@property (nonatomic, strong) NSString *end_endDate;

@property (nonatomic, strong) NSString *startStr;//接口入参
@property (nonatomic, strong) NSString *endStr;

@property (nonatomic, strong) NSString *selelctedClassIndex;

@end

@implementation MissionTeacherhHistoryViewController

- (NSMutableArray *)startDateArray
{
    if (!_startDateArray) {
        _startDateArray = [NSMutableArray array];
    }
    return _startDateArray;
}

- (NSMutableArray *)endDateArray
{
    if (!_endDateArray) {
        _endDateArray = [NSMutableArray array];
    }
    return _endDateArray;
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
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史任务";
    
    [self createRightNavigationItem:nil Title:@"筛选" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:0];

    [self createTableView];
    
}

#pragma mark - 右按钮筛选
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    MissionFilterViewController *filterVC = [[MissionFilterViewController alloc] init];
    filterVC.delegate = self;
    
    filterVC.bengin_start = self.begin_startDate;
    filterVC.bengin_end = self.begin_endDate;
    
    filterVC.end_start = self.end_startDate;
    filterVC.end_end = self.end_endDate;
    
    [self pushVC:filterVC animated:YES IsNeedLogin:YES];
}

#pragma mark - MissionFilterViewControllerDelegate
- (void)startDate:(NSString *)startDate
          EndDate:(NSString *)endDate
SelelctedClassIndex:(NSString *)selelctedClassIndex
{
    self.startStr = startDate;
    self.endStr = endDate;
    self.selelctedClassIndex = selelctedClassIndex;
    [self refreshData];
}

#pragma mark - 获取老师任务列表
- (void)teacherList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //任务类型: 1-本周任务, 2-上周任务, 3-历史任务
    [params setValue:@"3" forKey:@"type"];
    [params setValue:self.selelctedClassIndex forKey:@"classIdList"];
    if (self.startStr.length != 0) {
        [params setValue:[NSString newStringDateFromString:self.startStr] forKey:@"startDate"];
    }
    if (self.endStr.length != 0) {
        [params setValue:[NSString newStringDateFromString:self.endStr] forKey:@"endDate"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@api/task/teacherList", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.dataSourceArray removeAllObjects];
        [self.startDateArray removeAllObjects];
        [self.endDateArray removeAllObjects];
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dataDic = [resultObject objectForKey:@"data"];
        NSMutableArray *listArray = [dataDic objectForKey:@"list"];
        for (NSMutableDictionary *dic in listArray) {
            MissionModel *model = [[MissionModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
            [self.startDateArray addObject:model.startDate];
            [self.endDateArray addObject:model.endDate];
        }
        [self.tableView reloadData];
        //排序数组
        [self sortDate];
        
    } errorHandler:^(NSError *error) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        
    } reloadHandler:^(BOOL isReload) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 排序数组
- (void)sortDate
{
    [self.startDateArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];//升序
    }];
    [self.endDateArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];//升序
    }];
    
    if (self.startDateArray.count != 0) {
        self.begin_startDate = [NSString newStringDateNoLineFromString:[self.startDateArray firstObject]];
        self.begin_endDate = [NSString newStringDateNoLineFromString:[self.startDateArray lastObject]];
    }
    
    if (self.endDateArray.count != 0) {
        self.end_startDate = [NSString newStringDateNoLineFromString:[self.endDateArray firstObject]];
        self.end_endDate = [NSString newStringDateNoLineFromString:[self.endDateArray lastObject]];
    }
    
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
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
    }];
    
    //刷新数据
    //mj_header
    self.tableView.mj_header = [self createMJRefreshGifHeaderWithSelector:@selector(refreshData)];
    
    if (![self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header beginRefreshing];
    }
    
}

//刷新数据
- (void)refreshData
{
    self.start_row = 1;
    self.page_size = 10;
    [self teacherList];

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

#pragma mark - TableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self getCellArrayWithSection:section].count;
}

#pragma mark - 根据section获取cell的数组
- (NSMutableArray *)getCellArrayWithSection:(NSInteger)section
{
    NSMutableArray *array = [NSMutableArray array];
    if (self.dataSourceArray.count > 0) {
        MissionModel *missionModel = self.dataSourceArray[section];
        for (NSMutableDictionary *dic in missionModel.classList) {
            MissionClassModel *model = [[MissionClassModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [array addObject:model];
        }
        
    }
    return array;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"missionTeacherHistoryCell";
    MissionTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MissionTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *array = [self getCellArrayWithSection:indexPath.section];
    if (array.count == 0) {
        return cell;
    }
    MissionClassModel *model = array[indexPath.row];
    [cell setMissionTeacherCellWithTypeText:model.grade
                                  TypeColor:ZTOrangeColor
                                   LeftText:model.className
                                  RightText:model.completeCount
                               RightAllText:model.totalCount
                                 RightColor:ZTBlueColor];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *array = [self getCellArrayWithSection:indexPath.section];
    if (array.count == 0) {
        return;
    }
    MissionClassModel *model = array[indexPath.row];
    //跳转到 -> 班级任务
    MissionModel *missionModel = self.dataSourceArray[indexPath.section];
    MissionClassViewController *classVC = [[MissionClassViewController alloc] init];
    classVC.classId = model.classId;
    classVC.grade = model.grade;
    classVC.className = model.className;
    classVC.completeCount = model.completeCount;
    classVC.totalCount = model.totalCount;
    
    classVC.startDate = missionModel.startDate;
    classVC.endDate = missionModel.endDate;
    classVC.schoolName = missionModel.schoolName;
    
    [self pushVC:classVC animated:YES IsNeedLogin:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return GTH(100);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataSourceArray.count == 0) {
        return nil;
    }
    MissionModel *model = self.dataSourceArray[section];
    
    CGFloat label_width = (ScreenWidth - GTW(28) * 2) / 2;
    CGFloat label_height = GTH(100);
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, ScreenWidth, label_height);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(GTW(28), 0, label_width, label_height);
    leftLabel.text = [NSString stringWithFormat:@"%@至%@", model.startDate, model.endDate];
    leftLabel.textColor = ZTTextLightGrayColor;
    leftLabel.font = FONT(24);
    [view addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.frame = CGRectMake(label_width + GTW(28), 0, label_width, label_height);
    rightLabel.text = model.schoolName;
    rightLabel.textColor = ZTTextLightGrayColor;
    rightLabel.font = FONT(24);
    rightLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:rightLabel];
    
    UILabel *lineLabele = [[UILabel alloc] initWithFrame:CGRectMake(0, label_height - 1, ScreenWidth, 1)];
    lineLabele.backgroundColor = ZTLineGrayColor;
    [view addSubview:lineLabele];
    
    return view;
}

@end
