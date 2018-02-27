//
//  ZiyouView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/1.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZiyouView.h"
#import "ZiyouTableViewCell.h"
#import "ZiyouTypeDescModel.h"
#import "FindListModel.h"

@interface ZiyouView () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) ZiyouTypeDescModel *ziyouTypeDescModel;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation ZiyouView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSourceArray = [NSMutableArray array];
        [self createSubViews];
    }
    return self;
}

#pragma mark - 获取栏目说明
- (void)getTypeDesc
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.typeId forKey:@"typeId"];

    NSString *url = [NSString stringWithFormat:@"%@api/articleType/get", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSDictionary *dic = [resultObject objectForKey:@"data"];
        self.ziyouTypeDescModel = [[ZiyouTypeDescModel alloc] init];
        [self.ziyouTypeDescModel setValuesForKeysWithDictionary:dic];
        //刷新header
        [self updateHeaderData];

    } errorHandler:^(NSError *error) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];

    } reloadHandler:^(BOOL isReload) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (isReload) {
            [self.ziyouVC pushToLoginVC];
        }
    }];
    
}

#pragma mark - 更新header数据
- (void)updateHeaderData
{
    //更新高度
    CGSize size = [self getSizeWithString:self.ziyouTypeDescModel.introduction font:FONT(28) str_width:ScreenWidth - GTW(30) * 2 - GTW(32) * 2];
    self.tableView.tableHeaderView = [self createTableHeaderViewWithHeight:size.height];
}

#pragma mark - 创建TableHeaderView
- (UIView *)createTableHeaderViewWithHeight:(CGFloat)height
{
    CGFloat view_height = height + GTH(37) * 2 + GTH(28) * 2;
    CGFloat center_height = height + GTH(37) * 2;
    CGFloat center_width = ScreenWidth - GTW(30) * 2;
    
    _tableHeaderView = [[UIView alloc] init];
    _tableHeaderView.frame = CGRectMake(0, 0, ScreenWidth, view_height);
    _tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    _lineView = [[UIView alloc] init];
    _lineView.frame = CGRectMake(GTW(30), 0, ScreenWidth - GTW(30) * 2, 1);
    _lineView.backgroundColor = ZTLineGrayColor;
    [_tableHeaderView addSubview:_lineView];
    
    _centerView = [[UIView alloc] init];
    _centerView.frame = CGRectMake(GTW(30), GTH(28), center_width, center_height);
    _centerView.backgroundColor = ZTAlphaColor;
    _centerView.layer.cornerRadius = GTH(10);
    [_tableHeaderView addSubview:_centerView];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.frame = CGRectMake(GTW(32) + GTW(30), GTH(37) + GTH(28), ScreenWidth - GTW(30) * 2 - GTW(32) * 2, height);
    _descLabel.text = self.ziyouTypeDescModel.introduction;
    _descLabel.textColor = ZTTextGrayColor;
    _descLabel.font = FONT(28);
    _descLabel.numberOfLines = 0;
    _descLabel.attributedText = [UILabel setLabelSpace:_descLabel withValue:_descLabel.text withFont:_descLabel.font];
    _descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_tableHeaderView addSubview:_descLabel];

    return _tableHeaderView;
    
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
    [params setValue:self.typeId forKey:@"typeId"];
    //1-自由写, 2-命题作
    [params setValue:@"1" forKey:@"bigTypeId"];
    //筛选条件
    [params setValue:self.startDate forKey:@"startDate"];
    [params setValue:self.endDate forKey:@"endDate"];
    [params setValue:self.proviceId forKey:@"proviceId"];
    [params setValue:self.cityId forKey:@"cityId"];
    [params setValue:self.schoolId forKey:@"schoolId"];
    [params setValue:self.gradeName forKey:@"gradeName"];
    [params setValue:self.classId forKey:@"classId"];

    NSString *url = [NSString stringWithFormat:@"%@api/article/list", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
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
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        [self.tableView reloadData];
        
        if ([self.pageCount integerValue] <= self.start_row) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } errorHandler:^(NSError *error) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        
    } reloadHandler:^(BOOL isReload) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (isReload) {
            [self.ziyouVC pushToLoginVC];
        }
    }];
    
}

- (void)createSubViews
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
    self.tableView.rowHeight = GTH(400);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT + GTH(76) * 2, 0)];
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
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
    [self getTypeDesc];
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
    static NSString *defaultCellID = @"ziyouTableViewCell";
    ZiyouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[ZiyouTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    
    FindListModel *model = self.dataSourceArray[indexPath.row];
    cell.findListModel = model;
    
    [cell createTypeLabelWithString:self.typeName];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSourceArray.count == 0) {
        return;
    }
    //传值articleId
    if ([self.delegate respondsToSelector:@selector(pushToDetailVCWithArticleIdStr:IsRecommend:)]) {
        FindListModel *model = self.dataSourceArray[indexPath.row];
        [self.delegate pushToDetailVCWithArticleIdStr:model.articleId IsRecommend:model.isRecommend];
    }
}


@end
