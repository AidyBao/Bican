//
//  FindViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "FindViewController.h"
#import "FindTableViewCell.h"
#import "SDCycleScrollView.h"
#import "FindBannerModel.h"
#import "FindListModel.h"

#import "FindSearchViewController.h"
#import "ZiyouViewController.h"
#import "MingtiViewController.h"
#import "JinshiViewController.h"
#import "ReduViewController.h"
#import "FindDetailViewController.h"
#import "MineLoginViewController.h"
#import "FindBannerDetailViewController.h"

@interface FindViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UIScrollViewDelegate, SDCycleScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *picArray;//轮播图数组
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)
@property (nonatomic, strong) NSString *sortStr;

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *ziyouButton;//自由写
@property (nonatomic, strong) UIButton *mingtiButton;//命题作
@property (nonatomic, strong) UIButton *jinshiButton;//进士榜
@property (nonatomic, strong) UIButton *reduButton;//热读吧
@property (nonatomic, strong) SDCycleScrollView *headerScrollView;
@property (nonatomic, assign) CGFloat headerScrollHeight;//轮播图的高
@property (nonatomic, strong) UIView *backView;//导航栏效果

@end

@implementation FindViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

- (NSMutableArray *)picArray
{
    if (!_picArray) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar addSubview:[self createNavBackView]];
    [self refreshData];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.backView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //排序-默认1:时间
    self.sortStr = @"1";
    //设置轮播图的高
    if (ScreenHeight > 736) {
        self.headerScrollHeight = 450 * ScreenWidth / 1080;
    } else {
        self.headerScrollHeight = GTH(450);
    }
    
    [self.navigationController.navigationBar addSubview:[self createNavBackView]];

    [self createTableView];
    
}

#pragma mark - 获取首页轮播图
- (void)getBannerList
{
//    if (self.isUpData == NO) {
//        [self.tableView.mj_footer resetNoMoreData];
//    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@api/sys/getBannerList", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        [self.bannerArray removeAllObjects];
        [self.picArray removeAllObjects];
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            FindBannerModel *model = [[FindBannerModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.bannerArray addObject:model];
            [self.picArray addObject:model.picture];
        }
        //更换轮播图
        _headerScrollView.imageURLStringsGroup = self.picArray;
        [self.tableView reloadData];

    } errorHandler:^(NSError *error) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];

    } reloadHandler:^(BOOL isReload) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
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
    //1-时间, 2-热读
    [params setValue:self.sortStr forKey:@"sort"];

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

#pragma mark - 创建NavBackView
- (UIView *)createNavBackView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
        _backView.backgroundColor = [ZTNavColor colorWithAlphaComponent:0];
        
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(GTW(30), 0, ScreenWidth - GTW(30) * 2, GTH(65));
        [_searchButton setBackgroundColor:RGBA(255, 255, 255, 0.9)];
        [_searchButton setTitle:@"搜索老师、同学和作文" forState:UIControlStateNormal];
        [_searchButton setTitleColor:RGBA(125, 125, 125, 1) forState:UIControlStateNormal];
        _searchButton.titleLabel.font = FONT(26);
        [_searchButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
        [_searchButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:GTW(12)];
        _searchButton.adjustsImageWhenHighlighted = NO;
        _searchButton.layer.cornerRadius = GTH(20);
        [_searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_backView addSubview:_searchButton];
        
    }
    return _backView;
    
}


#pragma mark - 创建TableHeaderView
- (UIView *)createTableHeaderView
{
    if (!_tableHeaderView) {
        
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.headerScrollHeight + GTH(90))];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];

        //轮播图
        _headerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, self.headerScrollHeight) shouldInfiniteLoop:YES imageNamesGroup:self.picArray];
        _headerScrollView.delegate = self;
        _headerScrollView.imageURLStringsGroup = self.picArray;
        _headerScrollView.placeholderImage = [UIImage imageNamed:@"Bannerzanwei"];
        _headerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _headerScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _headerScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _headerScrollView.autoScroll = YES;
        _headerScrollView.autoScrollTimeInterval = 5.0;
        [_tableHeaderView addSubview:_headerScrollView];
        
        //输入框button
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchButton.frame = CGRectMake(GTW(30), GTH(16) + 20, ScreenWidth - GTW(30) * 2, GTH(65));
        [_searchButton setBackgroundColor:RGBA(255, 255, 255, 0.9)];
        [_searchButton setTitle:@"搜索老师、同学和作文" forState:UIControlStateNormal];
        [_searchButton setTitleColor:RGBA(125, 125, 125, 1) forState:UIControlStateNormal];
        _searchButton.titleLabel.font = FONT(26);
        [_searchButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
        [_searchButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:GTW(12)];
        _searchButton.adjustsImageWhenHighlighted = NO;
        _searchButton.layer.cornerRadius = GTH(20);
        [_searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_tableHeaderView addSubview:_searchButton];
        
        //中心的view
        _centerView = [[UIView alloc] init];
        _centerView.frame = CGRectMake(_searchButton.frame.origin.x, _tableHeaderView.frame.size.height - GTH(180) - GTH(10), _searchButton.frame.size.width, GTH(180));
        _centerView.backgroundColor = [UIColor whiteColor];
        _centerView.layer.shadowColor = RGBA(127, 127, 127, 1).CGColor;
        //阴影的透明度
        _centerView.layer.shadowOpacity = 0.24f;
        _centerView.layer.shadowRadius = GTH(20);
        _centerView.layer.cornerRadius = GTH(20);
        [_tableHeaderView addSubview:_centerView];

        CGFloat origin_X = (ScreenWidth - (GTW(30) * 2) - (GTW(120) * 4)) / 5;
        //自由写
        _ziyouButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ziyouButton.frame = CGRectMake(origin_X, (GTH(180) - GTH(120)) / 2, GTW(120), GTH(120));
        _ziyouButton.tag = 1001;
        [_ziyouButton setImage:[UIImage imageNamed:@"ziyou"] forState:UIControlStateNormal];
        [_ziyouButton setTitle:@"自由写" forState:UIControlStateNormal];
        [_ziyouButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
        _ziyouButton.titleLabel.font = FONT(24);
        _ziyouButton.adjustsImageWhenHighlighted = NO;
        [_ziyouButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:GTH(11)];
        [_ziyouButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:_ziyouButton];
        
        //命题作
        _mingtiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _mingtiButton.frame = CGRectMake(_ziyouButton.frame.size.width + _ziyouButton.frame.origin.x + origin_X, (GTH(180) - GTH(120)) / 2, GTW(120), GTH(120));
        _mingtiButton.tag = 1002;
        [_mingtiButton setImage:[UIImage imageNamed:@"mingti"] forState:UIControlStateNormal];
        [_mingtiButton setTitle:@"命题作" forState:UIControlStateNormal];
        [_mingtiButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
        _mingtiButton.titleLabel.font = FONT(24);
        _mingtiButton.adjustsImageWhenHighlighted = NO;
        [_mingtiButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:GTH(11)];
        [_mingtiButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:_mingtiButton];
        
        //进士榜
        _jinshiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _jinshiButton.frame = CGRectMake(_mingtiButton.frame.size.width + _mingtiButton.frame.origin.x + origin_X, (GTH(180) - GTH(120)) / 2, GTW(120), GTH(120));
        _jinshiButton.tag = 1003;
        [_jinshiButton setImage:[UIImage imageNamed:@"jinshi"] forState:UIControlStateNormal];
        [_jinshiButton setTitle:@"进士榜" forState:UIControlStateNormal];
        [_jinshiButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
        _jinshiButton.titleLabel.font = FONT(24);
        _jinshiButton.adjustsImageWhenHighlighted = NO;
        [_jinshiButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:GTH(11)];
        [_jinshiButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:_jinshiButton];
        
        //热读吧
        _reduButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _reduButton.frame = CGRectMake(_jinshiButton.frame.size.width + _jinshiButton.frame.origin.x + origin_X, (GTH(180) - GTH(120)) / 2, GTW(120), GTH(120));
        _reduButton.tag = 1004;
        [_reduButton setImage:[UIImage imageNamed:@"redu"] forState:UIControlStateNormal];
        [_reduButton setTitle:@"热读吧" forState:UIControlStateNormal];
        [_reduButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
        _reduButton.titleLabel.font = FONT(24);
        _reduButton.adjustsImageWhenHighlighted = NO;
        [_reduButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:GTH(11)];
        [_reduButton addTarget:self action:@selector(centerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_centerView addSubview:_reduButton];
        
    }
    return _tableHeaderView;
    
}

#pragma mark - 轮播图点击跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.bannerArray.count == 0) {
        return;
    }
    FindBannerModel *model = self.bannerArray[index];
    FindBannerDetailViewController *bannerDetailVC = [[FindBannerDetailViewController alloc] init];
    bannerDetailVC.bannerID = model.bannerId;
    [self pushVC:bannerDetailVC animated:YES IsNeedLogin:NO];
    
}

#pragma mark - 搜索按钮, 页面跳转
- (void)searchButtonAction
{
    FindSearchViewController *searchVC = [[FindSearchViewController alloc] init];
    [self pushVC:searchVC animated:YES IsNeedLogin:NO];
}

#pragma mark - 自由写 && 命题作 && 进士榜 && 热读吧
- (void)centerButtonAction:(UIButton *)button
{
    if (button.tag == 1001) {
        ZiyouViewController *ziyouVC = [[ZiyouViewController alloc] init];
        [self pushVC:ziyouVC animated:YES IsNeedLogin:NO];
    }
    if (button.tag == 1002) {
        MingtiViewController *mingtiVC = [[MingtiViewController alloc] init];
        [self pushVC:mingtiVC animated:YES IsNeedLogin:NO];
    }
    if (button.tag == 1003) {
        /*JinshiViewController *jinshiVC = [[JinshiViewController alloc] init];
        [self pushVC:jinshiVC animated:YES IsNeedLogin:NO];*/
          /*[ZTToastUtils showToastIsAtTop:NO Message:@"暂未开通,敬请期待!" Time:3.0];*/
    }
    if (button.tag == 1004) {
        /*ReduViewController *reduVC = [[ReduViewController alloc] init];
        [self pushVC:reduVC animated:YES IsNeedLogin:NO];*/
         /*[ZTToastUtils showToastIsAtTop:NO Message:@"暂未开通,敬请期待!" Time:3.0];*/
    }
}

#pragma mark - UIScrollView协议方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset_Y = scrollView.contentOffset.y;
    CGFloat alpha = (offset_Y + NAV_HEIGHT) / self.headerScrollHeight + GTH(90);
    self.backView.backgroundColor = [ZTNavColor colorWithAlphaComponent:alpha];
    
    if (offset_Y >= NAV_HEIGHT) {
        
        [UIView animateWithDuration:1.0f animations:^{
            
        } completion:^(BOOL finished) {
            
            self.navigationController.navigationBarHidden = NO;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
            }];
            
        }];
        
    } else {
        
        [UIView animateWithDuration:1.0f animations:^{
            
        } completion:^(BOOL finished) {
            
            self.navigationController.navigationBarHidden = YES;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top);
            }];
        }];
    }


}

#pragma mark - 创建UITableView
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
    self.tableView.tableHeaderView = [self createTableHeaderView];
    self.tableView.rowHeight = GTH(430);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0)];
    [self.tableView registerClass:[FindTableViewCell class] forCellReuseIdentifier:@"findTableViewCell"];

    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
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
    [self getBannerList];
    
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self getList];
}


#pragma mark - TableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"findTableViewCell";
    FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    FindListModel *model = self.dataSourceArray[indexPath.row];
    
    [cell createFindCellWithHeaderImage:model.avatar
                                   Name:model.nickname
                             SchoolName:model.schoolName
                                  Title:model.title
                                Content:model.summary
                                   Read:model.readNumber
                                 Praise:model.praiseNumber
                             Collection:model.collectionNumber
                                Comment:model.collectionNumber];
    
    [cell createTypeLabelWithModel:model];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSourceArray.count == 0) {
        return;
    }
    FindListModel *model = self.dataSourceArray[indexPath.row];
    //文章详情
    FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
    //传值:作文的id
    findDetailVC.articleIdStr = model.articleId;
    findDetailVC.isRecommend = model.isRecommend;
    [self pushVC:findDetailVC animated:YES IsNeedLogin:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return GTH(100);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat label_height = GTH(100);
    CGFloat label_width = (ScreenWidth - (GTW(30) * 2)) / 2;

    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(GTW(30), 0, label_width, label_height);
    leftLabel.text = @"作文精选";
    leftLabel.textColor = ZTTitleColor;
    leftLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(36)];
    [headerView addSubview:leftLabel];

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(ScreenWidth - GTW(30) - GTW(160), 0, GTW(160), label_height);
    [rightButton setTitleColor:ZTTextGrayColor forState:UIControlStateNormal];
    if ([self.sortStr isEqualToString:@"1"]) {
        [rightButton setTitle:@"时间排序" forState:UIControlStateNormal];
    } else {
        [rightButton setTitle:@"热读排序" forState:UIControlStateNormal];
    }
    [rightButton setImage:[UIImage imageNamed:@"bt-paixu"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = FONT(24);
    rightButton.adjustsImageWhenHighlighted = NO;
    [rightButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [rightButton addTarget:self action:@selector(sortButton) forControlEvents:UIControlEventTouchUpInside];;
    [headerView addSubview:rightButton];
    
    return headerView;
    
}

#pragma mark - 重新排序
- (void)sortButton
{
    if ([self.sortStr isEqualToString:@"1"]) {
        self.sortStr = @"2";
    } else {
        self.sortStr = @"1";
    }
    //重新请求数据
    [self refreshData];
}



@end
