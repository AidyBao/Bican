//
//  FindSearchResultViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "FindSearchResultViewController.h"
#import "PageSearchResultViewController.h"//作文
#import "UserSearchResultViewController.h"//用户
#import "WJItemsControlView.h"

#import "FindViewController.h"

@interface FindSearchResultViewController () <UIScrollViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) UIView *headerView;//顶部切换的view
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) PageSearchResultViewController *pageVC;
@property (nonatomic, strong) UserSearchResultViewController *userVC;

@property (nonatomic, strong) WJItemsControlView *itemControlView;
@property (nonatomic, assign) NSInteger selectedIndex;//记录选中的位置

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) CGFloat tableViewOffSetY;

@end

@implementation FindSearchResultViewController

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"作文", @"用户", nil];
    }
    return _titleArray;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchBar resignFirstResponder];
    //通知刷新数据
    NSDictionary *dic = @{@"searchKey":self.searhStr};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"realoadPageList" object:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"realoadUserList" object:dic];
}

#pragma mark - 懒加载searchBar
- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        CGFloat bar_height = NAV_HEIGHT - GTH(16) * 2;
    
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, GTH(16), ScreenWidth, bar_height)];
        _searchBar.layer.cornerRadius = GTH(20);
        _searchBar.showsSearchResultsButton = NO;
        _searchBar.showsCancelButton = NO;
        _searchBar.delegate = self;
        if (self.searhStr.length != 0) {
            _searchBar.text = self.searhStr;
        } else {
            _searchBar.placeholder = @"搜索";
        }
        [_searchBar setBackgroundImage:[self createImageWithColor:ZTAlphaColor Height:bar_height]];
        _searchBar.backgroundColor = ZTAlphaColor;
        [_searchBar setSearchFieldBackgroundImage:[self createImageWithColor:ZTAlphaColor Height:bar_height] forState:UIControlStateNormal];
        _searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createScrollView];
    [self createSearchBar];

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
        
}

#pragma mark - 取消按钮方法
- (void)rightBarButtomItemPressed:(UIBarButtonItem *)sender
{
    //返回发现
    for (UIViewController *VC in self.navigationController.viewControllers) {
        if ([VC isKindOfClass:[FindViewController class]]) {
            [self popToVC:VC animated:YES];
            return;
        }
    }
    FindViewController *findVC = [[FindViewController alloc] init];
    [self pushVC:findVC animated:YES IsNeedLogin:NO];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.searhStr = searchText;

}
//点击搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    //通知刷新数据
    NSDictionary *dic = @{@"searchKey":self.searhStr};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"realoadPageList" object:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"realoadUserList" object:dic];
}

#pragma mark - 创建ScrollView
- (void)createScrollView
{
    CGFloat header_height = GTH(90);
    CGFloat scroll_height = ScreenHeight - NAV_HEIGHT - header_height - 1;
    
    //底部内容的scrollView
    self.bigScrollView = [[UIScrollView alloc] init];
    self.bigScrollView.frame = CGRectMake(0, header_height + NAV_HEIGHT + 1, ScreenWidth, scroll_height);
    self.bigScrollView.backgroundColor = [UIColor whiteColor];
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.bounces = NO;
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.delegate = self;
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth * self.titleArray.count, scroll_height);
    [self.view addSubview:self.bigScrollView];
    
    //创建顶部的scrollView
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.selectedColor = ZTOrangeColor;
    config.textColor = ZTTitleColor;
    config.itemWidth = ScreenWidth / self.titleArray.count;
    config.itemFont = FONT(26);
    config.linePercent = 0.3;
    
    self.itemControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, header_height)];
    self.itemControlView.tapAnimation = YES;
    self.itemControlView.config = config;
    self.itemControlView.backgroundColor = [UIColor whiteColor];
    self.itemControlView.titleArray = self.titleArray;
    
    __weak typeof (_bigScrollView)weakScrollView = _bigScrollView;
    [self.itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        _selectedIndex = index;
        [weakScrollView scrollRectToVisible:CGRectMake(index * weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width, weakScrollView.frame.size.height) animated:animation];
        
    }];
    [self.view addSubview:self.itemControlView];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(GTW(30), self.itemControlView.frame.size.height + self.itemControlView.frame.origin.y, ScreenWidth - GTW(30) * 2, 1)];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.lineView];
    
    [self addChildViewController];
}

#pragma mark - 添加子控制器
- (void)addChildViewController
{
    //作文
    self.pageVC = [[PageSearchResultViewController alloc] init];
    self.pageVC.searchResultVC = self;
    self.pageVC.searhStr = self.searhStr;
    self.pageVC.view.frame = CGRectMake(0, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    [self.bigScrollView addSubview:self.pageVC.view];
    
    //用户
    self.userVC = [[UserSearchResultViewController alloc] init];
    self.userVC.searhStr = self.searhStr;
    self.userVC.searchResultVC = self;
    self.userVC.view.frame = CGRectMake(self.bigScrollView.frame.size.width, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    [self.bigScrollView addSubview:self.userVC.view];
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.tableViewOffSetY = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView moveToIndex:offset];
   
    if (scrollView.contentOffset.y > self.tableViewOffSetY) {
        [self.searchBar resignFirstResponder];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView endMoveToIndex:offset];
    
}




@end
