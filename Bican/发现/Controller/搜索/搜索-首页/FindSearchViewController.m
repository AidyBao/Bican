//
//  FindSearchViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//  首页发现-搜索

#import "FindSearchViewController.h"
#import "FindSearchTableViewCell.h"
#import "ClearHistoryView.h"
#import "SearchHistoryModel.h"

#import "FindSearchResultViewController.h"

@interface FindSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, FindSearchCellDelegate, ClearHistoryViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) CGFloat tableViewOffSetY;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSString *searchText;//搜索的内容
@property (nonatomic, strong) NSString *deleteIdString;//删除的ids
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;//选中的行

@property (nonatomic, strong) ClearHistoryView *clearHistoryView;

@end

@implementation FindSearchViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.searchBar resignFirstResponder];
    self.deleteIdString = @"";
    [self getHistoryKeyWords];
}

#pragma mark - 懒加载searchBar
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        CGFloat bar_height = NAV_HEIGHT - GTH(16) * 2;
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, GTH(16), ScreenWidth, bar_height)];
        _searchBar.layer.cornerRadius = GTH(20);
        //是否显示取消按钮
        _searchBar.showsSearchResultsButton = NO;
        _searchBar.showsCancelButton = NO;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        [_searchBar setBackgroundImage:[self createImageWithColor:ZTAlphaColor Height:bar_height]];
        _searchBar.backgroundColor = ZTAlphaColor;
        [_searchBar setSearchFieldBackgroundImage:[self createImageWithColor:ZTAlphaColor Height:bar_height] forState:UIControlStateNormal];
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getHistoryKeyWords];
    [self createSearchBar];
    [self createTableView];
    
}

#pragma mark - 获取客户历史记录
- (void)getHistoryKeyWords
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@api/user/getHistoryKeyWords", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.dataSourceArray removeAllObjects];
        [self hideLoading];
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            SearchHistoryModel *model = [[SearchHistoryModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
        }
        [self.tableView reloadData];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - 删除客户历史记录
- (void)deleteHistory
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //历史记录id串, 逗号拼接(1,2,3)
    [params setValue:self.deleteIdString forKey:@"ids"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/deleteHistory", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
        if ([[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            //重新请求
            [self getHistoryKeyWords];
        }
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}


#pragma mark - 创建SearchBar
- (void)createSearchBar
{
    if (@available(iOS 11.0, *)) {
        CGFloat buttonWidth = GTW(80);
        
        SearchBarNavTitleView *navTitleView = [[SearchBarNavTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - buttonWidth * 2, NAV_HEIGHT)];
        [navTitleView addSubview:self.searchBar];
        
        [self setConstraintsForSearchBar:self.searchBar TitleView:navTitleView];
        self.navigationItem.titleView = navTitleView;
        
    } else {
        self.navigationItem.titleView = self.searchBar;
        
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, GTW(80), GTH(60));
    [button setTitle:@"取消" forState:UIControlStateNormal];
    [button setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    [button setBackgroundColor:ZTOrangeColor];
    button.titleLabel.font = FONT(28);
    button.layer.cornerRadius = GTH(10);
    [button addTarget:self action:@selector(rightBarButtomItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -15;
    self.navigationItem.rightBarButtonItems = @[negativeSpacer,rightItem];
    
    [self.view addSubview:self.tableView];
    
}

#pragma mark - 取消按钮方法
- (void)rightBarButtomItemPressed:(UIBarButtonItem *)sender
{
    [self popVCAnimated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searchText = searchText;
}

#pragma mark - 键盘的search按钮点击方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    FindSearchResultViewController *searchResultVC = [[FindSearchResultViewController alloc] init];
    searchResultVC.searhStr = self.searchText;
    [self pushVC:searchResultVC animated:YES IsNeedLogin:NO];
}


#pragma mark - 创建UITableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];

    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = GTH(100);
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
    }];
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.tableViewOffSetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > self.tableViewOffSetY) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - tableView协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"findSearchCell";
    FindSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[FindSearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    SearchHistoryModel *model = self.dataSourceArray[indexPath.row];
    cell.contentLabel.text = model.keyWords;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchHistoryModel *model = self.dataSourceArray[indexPath.row];
    //搜索结果页面
    FindSearchResultViewController *searchResultVC = [[FindSearchResultViewController alloc] init];
    searchResultVC.searhStr = model.keyWords;
    [self pushVC:searchResultVC animated:YES IsNeedLogin:NO];
}

#pragma mark - FindSearchCellDelegate
- (void)toDeleteCell:(FindSearchTableViewCell *)cell
{
    self.selectedIndexPath = [self.tableView indexPathForCell:cell];
    SearchHistoryModel *model = self.dataSourceArray[self.selectedIndexPath.row];
    self.deleteIdString = model.key_id;
    //删除接口
    [self deleteHistory];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return GTH(85);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat label_width = (ScreenWidth - GTW(28) * 2) / 2;
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, ScreenWidth, GTH(85));
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(GTW(28), 0, label_width, GTH(85));
    leftLabel.text = @"搜索历史";
    leftLabel.font = FONT(26);
    leftLabel.textColor = ZTTextLightGrayColor;
    [view addSubview:leftLabel];
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.frame = CGRectMake(leftLabel.frame.size.width + leftLabel.frame.origin.x, 0, label_width, GTH(85));
    [clearButton setTitle:@"清空" forState:UIControlStateNormal];
    [clearButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    //按钮文字居右
    clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    clearButton.titleLabel.font = FONT(26);
    [clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:clearButton];
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.frame = CGRectMake(GTW(28), GTH(85) - 1, ScreenWidth - GTW(28) * 2, 1);
    lineLabel.backgroundColor = ZTLineGrayColor;
    [view addSubview:lineLabel];
    
    return view;
}

#pragma mark - 清空历史搜索
- (void)clearButtonAction
{
    if (self.dataSourceArray.count == 0) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.clearHistoryView = [[ClearHistoryView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.clearHistoryView.delegate = self;
    [window addSubview:self.clearHistoryView];

}

#pragma mark - ClearHistoryViewDelegate
- (void)toClearAllHistoryData
{
    self.deleteIdString = @"";
    if (self.dataSourceArray.count == 0) {
        return;
    }
    if (self.dataSourceArray.count == 1) {
        SearchHistoryModel *model = self.dataSourceArray[0];
        self.deleteIdString = model.key_id;
        
    } else {
        for (int i = 0; i < self.dataSourceArray.count; i++) {
            SearchHistoryModel *model = self.dataSourceArray[i];
            self.deleteIdString = [NSString stringWithFormat:@"%@,%@",self.deleteIdString, model.key_id];
        }
    }
    self.deleteIdString = [self.deleteIdString substringFromIndex:1];
    [self deleteHistory];
}


@end
