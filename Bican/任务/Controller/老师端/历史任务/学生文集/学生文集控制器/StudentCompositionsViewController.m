//
//  StudentCompositionsViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "StudentCompositionsViewController.h"
#import "StudentCorrectViewController.h"
#import "StudentUnCorrectViewController.h"
#import "WJItemsControlView.h"

#import "CompositionSelectedViewController.h"

@interface StudentCompositionsViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) StudentCorrectViewController *studentCorrectVC;
@property (nonatomic, strong) StudentUnCorrectViewController *studentUnCorrectVC;

@property (nonatomic, strong) WJItemsControlView *itemControlView;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, assign) NSInteger selectedTitleIndex;//记录选中的下标
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation StudentCompositionsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.studentIdStr forKey:@"studentId"];
    [dic setValue:self.nickName forKey:@"nickName"];
    [dic setValue:self.schoolName forKey:@"schoolName"];
    [dic setValue:self.startDate forKey:@"startDate"];
    [dic setValue:self.endDate forKey:@"endDate"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"correct" object:dic];
    
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"未评阅", @"已评阅", nil];
    }
    return _titleArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认为0
    self.selectedTitleIndex = 0;
    
    self.title = self.nickName;
    [self initNav];
    [self createScrollView];
}

#pragma mark - 进入编辑页面
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    //多选页面
    CompositionSelectedViewController *selectedVC = [[CompositionSelectedViewController alloc] init];
    
    selectedVC.navTitle = self.nickName;
    selectedVC.studentIdStr = self.studentIdStr;
    selectedVC.startDate = self.startDate;
    selectedVC.endDate = self.endDate;

    [self pushVC:selectedVC animated:YES IsNeedLogin:YES];
}

#pragma mark - 右按钮
- (void)initNav
{
    if (self.selectedTitleIndex == 0) {
        [self createRightNavigationItem:nil Title:@"多选" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:0];
        
    } else {
        [self createRightNavigationItem:nil Title:@"" RithtTitleColor:nil BackgroundColor:nil CornerRadius:0];
    }
    
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
    config.itemWidth = ScreenWidth / 2;
    config.itemFont = FONT(26);
    config.linePercent = 0.3;
    
    self.itemControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, header_height)];
    self.itemControlView.tapAnimation = YES;
    self.itemControlView.config = config;
    self.itemControlView.backgroundColor = [UIColor whiteColor];
    self.itemControlView.titleArray = self.titleArray;
    
    __weak typeof (_bigScrollView)weakScrollView = _bigScrollView;
    __weak typeof(self)weakSelf = self;
    [self.itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        _selectedTitleIndex = index;
        [weakScrollView scrollRectToVisible:CGRectMake(index * weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width, weakScrollView.frame.size.height) animated:animation];
        [weakSelf initNav];

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
    //未评阅
    self.studentUnCorrectVC = [[StudentUnCorrectViewController alloc] init];
    self.studentUnCorrectVC.studentCompostionsVC = self;
    self.studentUnCorrectVC.view.frame = CGRectMake(0, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    [self.bigScrollView addSubview:self.studentUnCorrectVC.view];
    
    //已评阅
    self.studentCorrectVC = [[StudentCorrectViewController alloc] init];
    self.studentCorrectVC.studentCompostionsVC = self;
    self.studentCorrectVC.view.frame = CGRectMake(self.bigScrollView.frame.size.width, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    [self.bigScrollView addSubview:self.studentCorrectVC.view];
}

#pragma mark - 滚动之后
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView moveToIndex:offset];
    self.selectedTitleIndex = offset;

}

#pragma mark - 拖拽之后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView endMoveToIndex:offset];
    self.selectedTitleIndex = offset;
    [self initNav];
    
}


@end
