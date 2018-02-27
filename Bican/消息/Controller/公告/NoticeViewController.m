//
//  NoticeViewController.m
//  Bican
//
//  Created by chichen on 2017/12/24.
//  Copyright © 2017年 ZT. All rights reserved.
//  公告

#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
#import "NoticeModel.h"
#import "NoticeDetailViewController.h"

@interface NoticeViewController ()  <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)
@property (nonatomic, strong) NSString *unreadNumber;//未读数量

@end

@implementation NoticeViewController

- (NSMutableArray *)dateArray
{
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"informationReload" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bulletinList) name:@"informationReload" object:nil];

    [self createTableView];
    [self bulletinList];
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
    [self bulletinList];
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self bulletinList];
}


#pragma mark - 获取公告列表
- (void)bulletinList
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:@"1" forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];

    NSString *url = [NSString stringWithFormat:@"%@api/bulletin/list", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (self.isUpData == NO) {
            [self.dataSourceArray removeAllObjects];
            [self.dateArray removeAllObjects];
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
            NoticeModel *model = [[NoticeModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            NSString *date = [NSString newStringDateFromString:[NSString getStringFromSecond:model.pubTime]];
            if (![self.dateArray containsObject:date]) {
                [self.dateArray addObject:date];
            }
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

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dateArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *string = self.dateArray[section];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        NoticeModel *model = [[NoticeModel alloc] init];
        model = self.dataSourceArray[i];
        NSString *pubTime = [NSString newStringDateFromString:[NSString getStringFromSecond:model.pubTime]];
        if ([pubTime isEqualToString:string]) {
            [array addObject:model];
        }

    }
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"noticeTableViewCell";
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[NoticeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0 || self.dateArray.count == 0) {
        return cell;
    }
    
    NSString *string = self.dateArray[indexPath.section];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        NoticeModel *notice = [[NoticeModel alloc] init];
        notice = self.dataSourceArray[i];
        NSString *pubTime = [NSString newStringDateFromString:[NSString getStringFromSecond:notice.pubTime]];
        if ([pubTime isEqualToString:string]) {
            [array addObject:notice];
        }
        
    }
    NoticeModel *model = array[indexPath.row];
    
    [cell setNoticeCellWithHeadImage:model.avatar Title:model.title Desc:model.summary];

    if (model.picture.length == 0) {
        [cell isShowPicImage:NO Image:@""];

    } else {
        [cell isShowPicImage:YES Image:model.picture];
        
    }
    //添加长按手势
    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)];
    [cell.contentView addGestureRecognizer:longPressGest];

    return cell;
    
}

#pragma makr - 获取长按
-(void)longPressView:(UILongPressGestureRecognizer *)longPressGest
{
    if (longPressGest.state == UIGestureRecognizerStateBegan) {        
        CGPoint location = [longPressGest locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        [self showAlertWithIndex:indexPath.row Section:indexPath.section];

    }

}

#pragma mark - 弹窗
- (void)showAlertWithIndex:(NSInteger)index Section:(NSInteger)section
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[UIAlertController class]]) {
            [view removeFromSuperview];
        }
    }
    NSString *titleStr = @"提示";
    NSString *messageStr = @"是否确认删除";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:ZTTitleColor forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *string = self.dateArray[section];
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.dataSourceArray.count; i++) {
            NoticeModel *notice = [[NoticeModel alloc] init];
            notice = self.dataSourceArray[i];
            NSString *pubTime = [NSString newStringDateFromString:[NSString getStringFromSecond:notice.pubTime]];
            if ([pubTime isEqualToString:string]) {
                [array addObject:notice];
            }
            
        }
        NoticeModel *model = array[index];
        [weakSelf bulletinRemoveWithBullitenId:model.bullitenId];
        
    }];
    [sureAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *string = self.dateArray[indexPath.section];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        NoticeModel *notice = [[NoticeModel alloc] init];
        notice = self.dataSourceArray[i];
        NSString *pubTime = [NSString newStringDateFromString:[NSString getStringFromSecond:notice.pubTime]];
        if ([pubTime isEqualToString:string]) {
            [array addObject:notice];
        }

    }
    NoticeModel *model = array[indexPath.row];
    NoticeDetailViewController *noticeDetailVC = [[NoticeDetailViewController alloc] init];
    noticeDetailVC.noticeModel = model;
    [self.informationVC pushVC:noticeDetailVC animated:YES IsNeedLogin:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dateArray.count == 0) {
        return 0;
    }
    return GTH(90);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dateArray.count == 0) {
        return nil;
    }
    NSString *string = self.dateArray[section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(90))];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    NSString *now = [NSString newStringDateFromString:[NSString getStringFromTime:[NSString stringFromNow]]];

    if ([string isEqualToString:now]) {
        label.frame = CGRectMake(0, 0, GTW(65), GTH(44));
        label.text = @"今天";
    } else {
        label.frame = CGRectMake(0, 0, GTW(200), GTH(44));
        label.text = string;
    }
    label.center = view.center;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = FONT(24);
    label.backgroundColor = ZTTextLightGrayColor;
    label.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:label.bounds];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dateArray.count == 0) {
        return GTH(180) + 1;
    }
    NSString *string = self.dateArray[indexPath.section];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        NoticeModel *notice = [[NoticeModel alloc] init];
        notice = self.dataSourceArray[i];
        NSString *pubTime = [NSString newStringDateFromString:[NSString getStringFromSecond:notice.pubTime]];
        if ([pubTime isEqualToString:string]) {
            [array addObject:notice];
        }
        
    }
    NoticeModel *model = array[indexPath.row];
    if (model.picture.length == 0) {
        return GTH(180) + 1;
        
    } else {
        return GTH(180) * 2 + 1;
    }
}


#pragma mark - 删除公告
- (void)bulletinRemoveWithBullitenId:(NSString *)bullitenId
{
    if (bullitenId.length == 0) {
        return;
    }
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:@"4" forKey:@"type"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];

    [params setValue:bullitenId forKey:@"bulletinId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/bulletin/remove", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
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
