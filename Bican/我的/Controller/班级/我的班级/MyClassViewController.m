//
//  MyClassViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MyClassViewController.h"
#import "MyClassTableViewCell.h"
#import "ZTBottomSelecteView.h"
#import "StudentListModel.h"

#import "ClassStudentViewController.h"
#import "ZTBottomSelecteView.h"

@interface MyClassViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ZTBottomSelecteViewDelegate, MyClassTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZTBottomSelecteView *bottomSelecteView;
@property (nonatomic, strong) NSArray *removeArray;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;//记录选中的cell行数

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation MyClassViewController

- (NSArray *)removeArray
{
    if (!_removeArray) {
        _removeArray = [NSArray arrayWithObjects:@"确认移除", @"将学生移除班级列表?", nil];
    }
    return _removeArray;
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
    self.title = @"我的班级";
    
    [self createRightNavigationItem:nil Title:@"退出班级" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:0];
    
    [self createTableView];
    [self createBottomSelecteView];

    
}

#pragma mark - 退出班级
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    NSString *titleStr = @"提示";
    NSString *messageStr = @"确认退出该班级";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //这是按钮的背景颜色
    [cancelAction setValue:ZTTitleColor forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self quitClass];
    }];
    [sureAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma makr - 创建弹出的view
- (void)createBottomSelecteView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bottomSelecteView = [[ZTBottomSelecteView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bottomSelecteView.delegate = self;
    self.bottomSelecteView.hidden = YES;
    
    [window addSubview:self.bottomSelecteView];
}

#pragma makr - ZTBottomSelecteViewDelegate
- (void)selecetedIndex:(NSInteger)selecetedIndex
{
    if (selecetedIndex == 0) {
        self.bottomSelecteView.hidden = YES;
        [self removeStudent];
        return;
    }
    self.bottomSelecteView.hidden = NO;
}

- (void)cancelButtonClick
{
    
}

#pragma mark - MyClassTableViewCellDelegate
- (void)removeStudentWithCell:(MyClassTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.bottomSelecteView setZTBottomSelecteViewWithArray:self.removeArray CancelButtonTitle:@"取消" TextColor:ZTTextGrayColor TextFont:FONT(30) IsShowOrangeColor:YES OrangeColorIndex:0];
    self.bottomSelecteView.hidden = NO;
    //记录选中的行
    self.selectedIndexPath = indexPath;
    
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
    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = GTH(180);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
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
    [self getByClass];
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self getByClass];
}


#pragma mark - DZNEmptyDataSetSource协议方法
//设置title
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有学生数据";
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myClassListCell"];
    if (!cell) {
        cell = [[MyClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classListCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    StudentListModel *model = self.dataSourceArray[indexPath.row];
    
    [cell createMyClassTableViewCellWithFirstName:model.firstName LastName:model.lastName AllUnCommentCount:model.allUnCommentCount AllCount:model.allCount UnCommentCount:model.unCommentCount];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    StudentListModel *model = self.dataSourceArray[indexPath.row];
    //班级学生
    ClassStudentViewController *classStuVC = [[ClassStudentViewController alloc] init];
    classStuVC.clickUserIdStr = model.userId;
    [self pushVC:classStuVC animated:YES IsNeedLogin:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  GTH(110) + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(110) + 1)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - GTW(30) - GTW(120), 0, GTW(120), view.frame.size.height - 1)];
    rightLabel.text = [NSString stringWithFormat:@"%@人", self.studentCount];
    rightLabel.textColor = ZTTitleColor;
    rightLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    rightLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:rightLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(GTW(30), 0, ScreenWidth - GTW(30) * 3 - GTW(80), view.frame.size.height - 1)];
    label.text = [NSString stringWithFormat:@"%@%@", [GetUserInfo getUserInfoModel].schoolName, self.className];
    label.textColor = ZTTitleColor;
    label.numberOfLines = 0;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [view addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, GTH(110), ScreenWidth, 1)];
    lineView.backgroundColor = ZTLineGrayColor;
    [view addSubview:lineView];
    
    return view;
}



#pragma mark - 移除学生接口
- (void)removeStudent
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.classId forKey:@"classId"];
    StudentListModel *model = self.dataSourceArray[self.selectedIndexPath.row];
    [params setValue:model.userId forKey:@"studentId"];

    NSString *url = [NSString stringWithFormat:@"%@api/class/removeStudent", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [self hideLoading];
        //重新查询学生列表
        [self getByClass];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - 退出班级接口
- (void)quitClass
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    UserInformation *user = [GetUserInfo getUserInfoModel];
    [params setValue:user.roleType forKey:@"roleType"];
    [params setValue:self.classId forKey:@"classId"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/quitClass", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //返回到我的班级列表
        [self popVCAnimated:YES];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}


#pragma mark - 根据班级获取学生列表接口
- (void)getByClass
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.classId forKey:@"classId"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/getByClass", BASE_URL];
    
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
            StudentListModel *model = [[StudentListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
        }
        //刷新学生总数
        self.studentCount = [NSString stringWithFormat:@"%ld", self.dataSourceArray.count];
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
