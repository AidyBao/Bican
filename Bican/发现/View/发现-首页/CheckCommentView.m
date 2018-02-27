//
//  CheckCommentView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/13.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CheckCommentView.h"
#import "CheckCommentTableViewCell.h"
#import "AnnotationListModel.h"

@interface CheckCommentView () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation CheckCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSourceArray = [NSMutableArray array];
        [self createSubViews];
    }
    return self;
}

#pragma mark - 作文批注列表
- (void)getAnnotationList
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.articleIdStr forKey:@"articleId"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];
    //1-查看批注列表, 2-评阅批注列
    [params setValue:@"1" forKey:@"type"];
    //评阅人ID: (查看所有批注-0)
    [params setValue:self.annotationUserIdStr forKey:@"annotationUserId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/annotation/list", BASE_URL];
    
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
        NSMutableArray *array = [dataDic objectForKey:@"list"];
        for (NSMutableDictionary *dic in array) {
            AnnotationListModel *model = [[AnnotationListModel alloc] init];
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
            [self.checkVC pushToLoginVC];
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
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0)];
    
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
    [self getAnnotationList];
    
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self getAnnotationList];
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
    static NSString *defaultCellID = @"checkCommentTableViewCell";
    CheckCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[CheckCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    AnnotationListModel *model = self.dataSourceArray[indexPath.row];
    
    if (self.isShowAll) {
        //全部的显示
        NSString *center = [NSString stringWithFormat:@"@%@(%@%@)", model.nickname, model.firstName, model.role];
        [cell setCheckCommentCellWithOriginal:model.sourceTxt
                                      Comment:model.content
                                       Center:center
                                 IsShowCenter:YES];
        
        
    } else {
        //个人
        [cell setCheckCommentCellWithOriginal:model.sourceTxt
                                      Comment:model.content
                                       Center:@""
                                 IsShowCenter:NO];

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnnotationListModel *model = self.dataSourceArray[indexPath.row];

    NSString *original = model.sourceTxt;
    NSString *center = [NSString stringWithFormat:@"@%@(%@%@)", model.nickname, model.firstName, model.role];
    NSString *comment = model.content;
    
    CGFloat width = ScreenWidth - GTW(67) - GTW(30) * 3;
    
    CGSize titleSize = [self getSizeWithString:original font:FONT(24) str_width:width];
    CGSize centerSize = [self getSizeWithString:center font:FONT(24) str_width:width];
    CGSize commentSize = [self getSizeWithString:comment font:FONT(24) str_width:width];

    if (self.isShowAll) {
        return GTH(30) * 4 + 2 + titleSize.height + centerSize.height + commentSize.height;
        
    } else {
        return GTH(30) * 3 + GTH(20) + 2 + titleSize.height + commentSize.height;

    }
    
}


@end
