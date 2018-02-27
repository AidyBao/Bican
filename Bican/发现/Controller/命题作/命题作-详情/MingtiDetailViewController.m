//
//  MingtiDetailViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/6.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MingtiDetailViewController.h"
#import "MingtiDetailHeaderView.h"
#import "MingtiDetailTableViewCell.h"
#import "MingtiListModel.h"
#import "FindListModel.h"

#import "FindDetailViewController.h"
#import "MingtiCompleteViewController.h"
#import "ZiyouFilterViewController.h"

@interface MingtiDetailViewController ()  <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MingtiDetailHeaderViewDelegate, ZiyouFilterViewControllerDelegate>

@property (nonatomic, strong) MingtiDetailHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UIButton *writeButton;//写作文按钮

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *selectedProvice;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedSchool;
@property (nonatomic, strong) NSString *selectedGrade;
@property (nonatomic, strong) NSString *selectedClass;

@end

@implementation MingtiDetailViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRightNavigationItem:nil Title:@"筛选" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:0];

    [self getList];
    [self createHeaderView];
    [self createTableView];
    [self createWriteButton];
    
}

#pragma mark - 筛选
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    ZiyouFilterViewController *ziyouFilterVC = [[ZiyouFilterViewController alloc] init];
    ziyouFilterVC.bigTypeId = @"2";
    ziyouFilterVC.typeIdStr = self.mingtiListModel.typeId;
    ziyouFilterVC.delegate = self;
    [self pushVC:ziyouFilterVC animated:YES IsNeedLogin:NO];
}

#pragma mark - ZiyouFilterViewControllerDelegate
- (void)startDate:(NSString *)startDate
          EndDate:(NSString *)endDate
  SelectedProvice:(NSString *)selectedProvice
     SelectedCity:(NSString *)selectedCity
   SelectedSchool:(NSString *)selectedSchool
    SelectedGrade:(NSString *)selectedGrade
    SelectedClass:(NSString *)selectedClass
{
    self.startDate = startDate;
    self.endDate = endDate;
    self.selectedProvice = selectedProvice;
    self.selectedCity = selectedCity;
    self.selectedGrade = selectedGrade;
    self.selectedClass = selectedClass;
    self.selectedSchool = selectedSchool;
    
    [self getList];
}

#pragma mark - 创建写文章按钮
- (void)createWriteButton
{
    CGFloat width = GTH(120);
    
    self.writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.writeButton.frame = CGRectMake(ScreenWidth - width - GTW(30), ScreenHeight - width - TABBAR_HEIGHT, width, width);
    [self.writeButton setImage:[UIImage imageNamed:@"suspension"] forState:UIControlStateNormal];
    self.writeButton.adjustsImageWhenHighlighted = NO;
    [self.writeButton addTarget:self action:@selector(gotoWriteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.writeButton];
    
    if ([[GetUserInfo getUserInfoModel].roleType isEqualToString:@"2"]) {
        //老师端 - 隐藏
        self.writeButton.hidden = YES;
    } else {
        //未登录 && 学生端 - 显示
        self.writeButton.hidden = NO;
    }
    [self.view bringSubviewToFront:self.writeButton];
    
}

#pragma mark - 写作文按钮
- (void)gotoWriteButtonAction
{
    //学生登录 - 写作文
    if ([[GetUserInfo getUserInfoModel].roleType isEqualToString:@"1"]) {
//        NSLog(@"写作文");
    }
    //未登录 - 跳转登录
    if ([GetUserInfo getUserInfoModel].roleType.length == 0) {
        [self pushToLoginVC];
    }
    
}

#pragma mark - 获取作文精选列表
- (void)getList
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];
    //栏目分类: 1-自由写, 2-命题作
    [params setValue:@"2" forKey:@"bigTypeId"];
    //二级栏目ID，必须传一级栏目
    [params setValue:self.mingtiListModel.typeId forKey:@"typeId"];
    //筛选条件
    [params setValue:self.startDate forKey:@"startDate"];
    [params setValue:self.endDate forKey:@"endDate"];
    [params setValue:self.selectedProvice forKey:@"proviceId"];
    [params setValue:self.selectedCity forKey:@"cityId"];
    [params setValue:self.selectedSchool forKey:@"schoolId"];
    [params setValue:self.selectedGrade forKey:@"gradeName"];
    [params setValue:self.selectedClass forKey:@"classId"];
    
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

#pragma mark - 创建HeaderView
- (void)createHeaderView
{
    self.headerView = [[MingtiDetailHeaderView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, GTH(487) + GTH(30) * 2)];
    self.headerView.delegate = self;
    //设置header
    [self.headerView setMingtiDetailHeaderViewWithFromUser:self.mingtiListModel.provider FromTest:self.mingtiListModel.source Content:self.mingtiListModel.summary];
    
    [self.view addSubview:self.headerView];
    
}

#pragma mark - 完整命题按钮
- (void)pushToMingtiAllVC
{
    MingtiCompleteViewController *completeVC = [[MingtiCompleteViewController alloc] init];
    completeVC.typeIdStr = self.mingtiListModel.typeId;
    [self pushVC:completeVC animated:YES IsNeedLogin:NO];
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
    self.tableView.rowHeight = GTH(430);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT + GTH(487) + GTH(30) * 2);
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
    static NSString *defaultCellID = @"mingtiDetailCell";
    MingtiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MingtiDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    FindListModel *model = self.dataSourceArray[indexPath.row];
    
    [cell setMingtiDetailCellWithHeaderImage:model.avatar
                                    NickName:model.nickname
                                  SchoolName:model.schoolName
                                       Title:model.title
                                     Content:model.content
                                  ReadNumber:model.readNumber
                                PraiseNumber:model.praiseNumber
                            CollectionNumber:model.collectionNumber
                               CommentNumber:model.commentNumber];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FindListModel *model = self.dataSourceArray[indexPath.row];
    //跳转到文章详情
    FindDetailViewController *detailVC = [[FindDetailViewController alloc] init];
    detailVC.articleIdStr = model.articleId;
    detailVC.isRecommend = model.isRecommend;
    [self pushVC:detailVC animated:YES IsNeedLogin:NO];
    
}

@end
