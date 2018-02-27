//
//  MissionClassViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MissionClassViewController.h"
#import "MissionClassTableViewCell.h"//未完成
#import "WJItemsControlView.h"

#import "StudentCompositionsViewController.h"
#import "MissionCompletedViewController.h"
#import "MissionUnfinishedViewController.h"

@interface MissionClassViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) MissionCompletedViewController *missionCompletedVC;
@property (nonatomic, strong) MissionUnfinishedViewController *missionUnfinishedVC;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIButton *headerLeftButton;
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) WJItemsControlView *itemControlView;
@property (nonatomic, assign) NSInteger selectedIndex;//记录选中的位置

@end

@implementation MissionClassViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.classId forKey:@"classId"];
    [dic setValue:self.startDate forKey:@"startDate"];
    [dic setValue:self.endDate forKey:@"endDate"];
    [dic setValue:self.schoolName forKey:@"schoolName"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"misson" object:dic];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"已完成", @"未完成", nil];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认为0
    self.selectedIndex = 0;
    
    [self createHeaderView];
    [self createScrollView];
  
}

#pragma mark - 创建HeaderView
- (void)createHeaderView
{
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, GTH(239)));
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view);
    }];
    
    self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"renwu_head_bg"]];
    [self.headerView addSubview:self.headerImageView];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.headerView);
    }];
    
    self.headerTitleLabel = [[UILabel alloc] init];
    self.headerTitleLabel.text = @"班级任务";
    self.headerTitleLabel.font = FONT(30);
    self.headerTitleLabel.textColor = ZTTitleColor;
    self.headerTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:self.headerTitleLabel];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.headerView);
        make.height.mas_equalTo(NAV_HEIGHT - 20);
        make.top.equalTo(self.headerView.mas_top).offset(20);
    }];
    
    self.headerLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headerLeftButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
    [self.headerLeftButton setImage:[UIImage imageNamed:@"return"] forState:UIControlStateHighlighted];
    self.headerLeftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.headerLeftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.headerLeftButton addTarget:self action:@selector(headerLeftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.headerLeftButton];
    [self.headerLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.left.equalTo(self.headerView).offset(GTW(30));
        make.centerY.equalTo(self.headerTitleLabel);
    }];
    
    self.schoolLabel = [[UILabel alloc] init];
    self.schoolLabel.text = self.grade;
    self.schoolLabel.textColor = ZTOrangeColor;
    self.schoolLabel.backgroundColor = [UIColor blackColor];
    self.schoolLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(26)];
    self.schoolLabel.textAlignment = NSTextAlignmentCenter;
    [self.headerView addSubview:self.schoolLabel];
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left).offset(GTW(28));
        make.bottom.equalTo(self.headerView.mas_bottom).offset(GTH(-40));
        make.height.mas_equalTo(GTH(28));
        make.width.mas_equalTo(GTW(60));
    }];
    //设置部分圆角
    self.schoolLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(60), GTH(28))];

    self.classLabel = [[UILabel alloc] init];
    self.classLabel.text = self.className;
    self.classLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(26)];
    self.classLabel.textColor = ZTTitleColor;
    [self.headerView addSubview:self.classLabel];
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.schoolLabel.mas_right).offset(GTW(20));
        make.centerY.equalTo(self.schoolLabel);
    }];
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.text = [NSString stringWithFormat:@"%@ / %@", self.completeCount, self.totalCount];
    self.countLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(26)];
    self.countLabel.textColor = ZTTitleColor;
    [self.headerView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headerView.mas_right).offset(GTW(-28));
        make.centerY.equalTo(self.schoolLabel);
    }];
    self.countLabel.attributedText = [UILabel changeLabel:self.countLabel Color:ZTBlueColor Loc:0 Len:2 Font:self.countLabel.font];
    
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.text = @"完成人数";
    self.statusLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(26)];
    self.statusLabel.textColor = ZTTitleColor;
    [self.headerView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.countLabel.mas_left).offset(GTW(-30));
        make.centerY.equalTo(self.schoolLabel);
    }];
    
}

#pragma mark - 返回按钮
- (void)headerLeftButtonAction
{
    [self popVCAnimated:YES];
}

#pragma mark - 创建ScrollView
- (void)createScrollView
{
    CGFloat header_height = GTH(90);
    CGFloat scroll_height = ScreenHeight - header_height - GTH(239) - 1;
    
    //底部内容的scrollView
    self.bigScrollView = [[UIScrollView alloc] init];
    self.bigScrollView.frame = CGRectMake(0, header_height + 1 + GTH(239), ScreenWidth, scroll_height);
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
    
    self.itemControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, GTH(239), ScreenWidth, header_height)];
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
    //已完成
    self.missionCompletedVC = [[MissionCompletedViewController alloc] init];
    self.missionCompletedVC.view.frame = CGRectMake(0, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    self.missionCompletedVC.missionClassVC = self;
    [self.bigScrollView addSubview:self.missionCompletedVC.view];
    
    //未完成
    self.missionUnfinishedVC = [[MissionUnfinishedViewController alloc] init];
    self.missionUnfinishedVC.view.frame = CGRectMake(self.bigScrollView.frame.size.width, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    self.missionUnfinishedVC.missionClassVC = self;
    [self.bigScrollView addSubview:self.missionUnfinishedVC.view];
}

#pragma mark - 滚动之后
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView moveToIndex:offset];
}

#pragma mark - 拖拽之后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView endMoveToIndex:offset];
    
}






@end
