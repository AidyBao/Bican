//
//  InviteViewController.m
//  Bican
//
//  Created by bican on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "InviteViewController.h"
#import "MineStudentInviteViewController.h"
#import "OtherStudentInviteViewController.h"
#import "WJItemsControlView.h"
#import "AllInviteViewController.h"

@interface InviteViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) WJItemsControlView *itemControlView;
@property (nonatomic, assign) NSInteger selectedIndex;//记录选中的位置
@property (nonatomic, strong) MineStudentInviteViewController *mineStudentInviteVC;
@property (nonatomic, strong) OtherStudentInviteViewController *otherStudentInviteVC;

@end

@implementation InviteViewController

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"我的学生", @"其他学生", nil];
    }
    return _titleArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"inviteReload" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"待处理的邀请";
    
    [self createRightNavigationItem:nil Title:@"全部" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:5];
    [self modifyReadStatus];
    [self createScrollView];
}

- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    AllInviteViewController *allInviteVC = [[AllInviteViewController alloc] init];
    [self pushVC:allInviteVC animated:YES IsNeedLogin:YES];
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
    //我的学生
    self.mineStudentInviteVC = [[MineStudentInviteViewController alloc] init];
    self.mineStudentInviteVC.inviteVC = self;
    self.mineStudentInviteVC.view.frame = CGRectMake(0, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    [self.bigScrollView addSubview:self.mineStudentInviteVC.view];
    
    //其他学生
    self.otherStudentInviteVC = [[OtherStudentInviteViewController alloc] init];
    self.otherStudentInviteVC.inviteVC = self;
    self.otherStudentInviteVC.view.frame = CGRectMake(self.bigScrollView.frame.size.width, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    [self.bigScrollView addSubview:self.otherStudentInviteVC.view];
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

#pragma mark - 修改消息状态
- (void)modifyReadStatus
{
    if (self.messageId.length == 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:@"1" forKey:@"type"];
    //消息ID集合，英文逗号分隔
    [params setValue:self.messageId forKey:@"idList"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/message/modifyReadStatus", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}






@end
