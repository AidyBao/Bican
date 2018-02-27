//
//  CheckAndEditCommentViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CheckAndEditCommentViewController.h"
#import "CheckAndEditCommentTableViewCell.h"
#import "ArticleAnnotationModel.h"

#import "AddCommentViewController.h"

@interface CheckAndEditCommentViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CheckAndEditCommentCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CheckAndEditCommentViewController

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
    
    self.title = @"作文批注";
    
    [self createTableView];
    
}

#pragma mark - 获取作文详情(总评 && 批注)
- (void)get_Article_Detail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.articleIdStr forKey:@"articleId"];
    //是否查看批注和总评: 0-查看批注和总评(添加批注数组), 1-评阅批注和总评(没有批注数组)
    [params setValue:@"1" forKey:@"isComment"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/get", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.dataSourceArray removeAllObjects];
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        //批注数组
        NSMutableArray *annotationArray = [dic objectForKey:@"articleAnnotationList"];
        for (NSMutableDictionary *annotationDic in annotationArray) {
            ArticleAnnotationModel *model = [[ArticleAnnotationModel alloc] init];
            [model setValuesForKeysWithDictionary:annotationDic];
            [self.dataSourceArray addObject:model];
        }
        [self.tableView reloadData];
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        
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
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    //刷新数据
    //mj_header
    self.tableView.mj_header = [self createMJRefreshGifHeaderWithSelector:@selector(refreshData)];

}

//刷新数据
- (void)refreshData
{
    [self get_Article_Detail];
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
    static NSString *recommendCell = @"checkAndEditCommentCell";
    CheckAndEditCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:recommendCell];
    if (!cell) {
        cell = [[CheckAndEditCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recommendCell];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.delegate = self;
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    
    ArticleAnnotationModel *model = self.dataSourceArray[indexPath.row];
    [cell setCheckAndEditCommentCellWithContent:model.sourceTxt Comment:model.content];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleAnnotationModel *model = self.dataSourceArray[indexPath.row];
    CGFloat width = ScreenWidth - GTW(30) * 2 - GTW(10) - GTW(68);
    CGSize contentSize = [self getSizeWithString:model.sourceTxt font:FONT(28) str_width:width];
    CGSize commentSize = [self getSizeWithString:model.content font:FONT(28) str_width:width];

    return GTH(30) * 5 + GTH(60) + contentSize.height + commentSize.height + 2;
}

#pragma mark - CheckAndEditCommentCellDelegate
- (void)toDeleteCommentWihtCell:(CheckAndEditCommentTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ArticleAnnotationModel *model = self.dataSourceArray[indexPath.row];
    [self showDeleteAlertWithId:model.annotationId];
    
}
//跳转到修改页面
- (void)toEditCommentWihtCell:(CheckAndEditCommentTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    ArticleAnnotationModel *model = self.dataSourceArray[indexPath.row];
    
    AddCommentViewController *addVC = [[AddCommentViewController alloc] init];
    
    addVC.cotentStr = model.sourceTxt;//原文
    addVC.articleIdStr = model.articleId;
    addVC.startIndex = model.startTxt;
    addVC.endIndex = model.startTxt;
    addVC.comment = model.content;//批注内容
    addVC.annotationIdStr = model.annotationId;//批注id

    [self pushVC:addVC animated:YES IsNeedLogin:YES];
}

#pragma mark - 是否删除
- (void)showDeleteAlertWithId:(NSString *)idStr
{
    NSString *titleStr = @"提示";
    NSString *messageStr = @"是否删除批注";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //这是按钮的背景颜色
    [cancelAction setValue:ZTTitleColor forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用删除接口
        [self remove_annotationWithId:idStr];
        
    }];
    [sureAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 移除批注
- (void)remove_annotationWithId:(NSString *)annotationId
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //批注ID
    [params setValue:annotationId forKey:@"annotationId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/annotation/remove", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"删除批注成功" Time:3.0];
        //重新请求
        [self get_Article_Detail];
        
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
