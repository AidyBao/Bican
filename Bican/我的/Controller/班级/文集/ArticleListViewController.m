//
//  ArticleListViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ArticleListViewController.h"
#import "ArticleChooseViewController.h"
#import "ArticleListTableViewCell.h"
#import "SelectCompositionModel.h"
#import "ZTBottomSelecteView.h"

#import "FindDetailViewController.h"
#import "CommendArticleDetailViewController.h"

@interface ArticleListViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ZTBottomSelecteViewDelegate, ArticleListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) ZTBottomSelecteView *bottomSelecteView;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@property (nonatomic, strong) NSString *selelctedRow;//记录选中的行数

@end

@implementation ArticleListViewController

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
    
    self.title = @"文集";
    [self createRightNavigationItem:nil Title:@"多选" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:0];
    
    [self createTableView];
    [self createBottomSelecteView];
    
    
}

#pragma mark - 获取学生文集列表
- (void)pubList
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
    [params setValue:@"0" forKey:@"IsComment"];
    [params setValue:self.studentIdStr forKey:@"studentId"];
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


#pragma mark - 跳转到多选页面
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    ArticleChooseViewController *chooseVC = [[ArticleChooseViewController alloc] init];
    chooseVC.dataSourceArray = self.dataSourceArray;
    [self pushVC:chooseVC animated:YES IsNeedLogin:YES];
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
    self.tableView.rowHeight = GTH(125);
    
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
    [self pubList];
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self pubList];
    
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
    ArticleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"acticleListCell"];
    if (!cell) {
        cell = [[ArticleListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"articleListCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
    
    [cell setArticleListCellWithBigType:model.bigTypeName
                               TypeName:model.typeName
                                   Date:model.sendDate
                         AppraiseStatus:model.appraiseStatus
                      AppraiseStatusStr:model.appraiseStatusStr
                                  Title:model.title];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
    if ([model.appraiseStatus isEqualToString:@"1"]) {
        //已评阅 - 跳转到文章详情页面
        FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
        findDetailVC.articleIdStr = model.composition_id;
        findDetailVC.isRecommend = model.isRecommend;
        [self pushVC:findDetailVC animated:YES IsNeedLogin:YES];
        
    } else {
        //显示提示菜单
        self.bottomSelecteView.hidden = NO;
        NSString *string = [NSString string];
        if ([model.isRecommend isEqualToString:@"0"]) {//未推荐
            string = @"推荐";
        } else {//已推荐
            string = @"已推荐";
        }
        [self.bottomSelecteView setZTBottomSelecteViewWithArray:@[string, @"标为已评", @"评阅", @"查看文章"] CancelButtonTitle:@"取消" TextColor:ZTTextGrayColor TextFont:FONT(30) IsShowOrangeColor:NO OrangeColorIndex:0];
        
    }
    
    //记录选中的row
    self.selelctedRow = [NSString stringWithFormat:@"%ld", indexPath.row];
    
}

#pragma mark - ArticleListCellDelegate
- (void)moreButtonClickWithCell:(ArticleListTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
    if ([model.appraiseStatus isEqualToString:@"1"]) {
        //已评阅
        self.bottomSelecteView.hidden = NO;
        NSString *string = [NSString string];
        if ([model.isRecommend isEqualToString:@"0"]) {//未推荐
            string = @"推荐";
        } else {//已推荐
            string = @"已推荐";
        }
        [self.bottomSelecteView setZTBottomSelecteViewWithArray:@[string, @"查看文章"] CancelButtonTitle:@"取消" TextColor:ZTTextGrayColor TextFont:FONT(30) IsShowOrangeColor:NO OrangeColorIndex:0];

    } else {
        //未评阅
        self.bottomSelecteView.hidden = NO;
        NSString *string = [NSString string];
        if ([model.isRecommend isEqualToString:@"0"]) {//未推荐
            string = @"推荐";
        } else {//已推荐
            string = @"已推荐";
        }
        [self.bottomSelecteView setZTBottomSelecteViewWithArray:@[string, @"标为已评", @"评阅", @"查看文章"] CancelButtonTitle:@"取消" TextColor:ZTTextGrayColor TextFont:FONT(30) IsShowOrangeColor:NO OrangeColorIndex:0];
    }
    //记录选中的row
    self.selelctedRow = [NSString stringWithFormat:@"%ld", indexPath.row];

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

- (void)cancelButtonClick
{
    
}

#pragma makr - ZTBottomSelecteViewDelegate
- (void)selecetedIndex:(NSInteger)selecetedIndex
{
    SelectCompositionModel *model = self.dataSourceArray[[self.selelctedRow integerValue]];
    
    if (selecetedIndex == 0) {//已推荐不做任何操作
        if ([model.isRecommend isEqualToString:@"1"]) {
            return;
        }
    }
    self.bottomSelecteView.hidden = YES;
    if (selecetedIndex == 0) {
        //推荐 (未推荐状态下, 调用推荐按钮)
        if ([model.isRecommend isEqualToString:@"0"]) {
            [self recommend_articleWithId:model.composition_id];
        }
    }
    if ([model.appraiseStatus isEqualToString:@"0"]) {
        //未评阅
        if (selecetedIndex == 1) {
            //标记为已评
            [self modifyInviteStatusWithArticleIds:model.composition_id];
        }
        if (selecetedIndex == 2) {
            //评阅
            CommendArticleDetailViewController *detailVC = [[CommendArticleDetailViewController alloc] init];
            
            InviteModel *inviteModel = [[InviteModel alloc] init];
            inviteModel.summary = model.summary;
            inviteModel.articleId = model.composition_id;
            inviteModel.invite_id = @"-1";
            inviteModel.bigTypeName = model.bigTypeName;
            inviteModel.bigTypeId = model.bigTypeId;
            inviteModel.typeId = model.smallTypeId;
            inviteModel.typeName = model.typeName;
            inviteModel.title = model.title;
            inviteModel.nickname = self.nickName;
            inviteModel.schoolName = self.schoolName;

            detailVC.inviteModel = inviteModel;
            [self pushVC:detailVC animated:YES IsNeedLogin:YES];
        }
        if (selecetedIndex == 3) {
            //查看文章
            FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
            findDetailVC.articleIdStr = model.composition_id;
            findDetailVC.isRecommend = model.isRecommend;
            [self pushVC:findDetailVC animated:YES IsNeedLogin:YES];
        }

    } else {
        //已评阅
        if (selecetedIndex == 1) {
            //查看文章
            FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
            findDetailVC.articleIdStr = model.composition_id;
            findDetailVC.isRecommend = model.isRecommend;
            [self pushVC:findDetailVC animated:YES IsNeedLogin:YES];
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

#pragma mark - 标记为已评
- (void)modifyInviteStatusWithArticleIds:(NSString *)articleIds
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:articleIds forKey:@"articleIds"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/invite/modifyStatus", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"标记为已评阅成功" Time:3.0];
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
