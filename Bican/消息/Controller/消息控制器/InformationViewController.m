//
//  InformationViewController.m
//  Bican
//
//  Created by chichen on 2017/12/24.
//  Copyright © 2017年 ZT. All rights reserved.
//  消息 - 视图控制器

#import "InformationViewController.h"
#import "MessageViewController.h"
#import "NoticeViewController.h"
#import "WJItemsControlView.h"
#import "MessageModel.h"

@interface InformationViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) MessageViewController *messageVC;
@property (nonatomic, strong) NoticeViewController *noticeVC;
@property (nonatomic, strong) WJItemsControlView *itemControlView;
@property (nonatomic, assign) NSInteger selectedIndex;//记录选中的位置
@property (nonatomic, strong) NSString *unreadNumber;//未读数量
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) UILabel *messageCountLabel;

@end

@implementation InformationViewController

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"通知", @"公告", nil];
    }
    return _titleArray;
}

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
    [self messageList];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"informationReload" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self messageList];
    [self createScrollView];
    
}

#pragma mark - 创建ScrollView
- (void)createScrollView
{
    CGFloat header_height = GTH(90);
    CGFloat scroll_height = ScreenHeight - NAV_HEIGHT - TABBAR_HEIGHT - header_height - 1;
    
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
    
    CGFloat message_height = GTH(32);
    
    self.messageCountLabel = [[UILabel alloc] init];
    self.messageCountLabel.frame = CGRectMake(ScreenWidth / 4 + GTW(18), self.itemControlView.frame.origin.y + message_height / 2, message_height, message_height);
    self.messageCountLabel.textAlignment = NSTextAlignmentCenter;
    self.messageCountLabel.font = FONT(18);
    self.messageCountLabel.textColor = [UIColor whiteColor];
    self.messageCountLabel.backgroundColor = ZTDarkRedColor;
    self.messageCountLabel.layer.cornerRadius = message_height / 2;
    self.messageCountLabel.layer.masksToBounds = YES;
    self.messageCountLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.messageCountLabel];

    self.messageCountLabel.hidden = YES;
    [self addChildViewController];

    
}

#pragma mark - 添加子控制器
- (void)addChildViewController
{
    //通知
    self.messageVC = [[MessageViewController alloc] init];
    self.messageVC.informationVC = self;
    self.messageVC.view.frame = CGRectMake(0, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    [self.bigScrollView addSubview:self.messageVC.view];
    
    //公告
    self.noticeVC = [[NoticeViewController alloc] init];
    self.noticeVC.informationVC = self;
    self.noticeVC.view.frame = CGRectMake(self.bigScrollView.frame.size.width, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height);
    [self.bigScrollView addSubview:self.noticeVC.view];
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

#pragma mark - 获取消息列表
- (void)messageList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@api/message/list", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dataDic = [resultObject objectForKey:@"data"];
        self.unreadNumber = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"unread"]];
        NSMutableArray *listArray = [dataDic objectForKey:@"list"];
        for (NSMutableDictionary *dic in listArray) {
            MessageModel *model = [[MessageModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
        }
        [self updateMessage];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}


- (void)updateMessage
{
    if (self.unreadNumber.length == 0) {
        self.messageCountLabel.hidden = YES;

    } else {
        if ([self.unreadNumber integerValue] <= 0) {
            self.messageCountLabel.hidden = YES;
            
        } else {
            self.messageCountLabel.hidden = NO;
            NSString *string = [NSString string];
            if ([self.unreadNumber integerValue] > 99) {
                string = @"99+";
            } else {
                string = self.unreadNumber;
            }
            self.messageCountLabel.text = string;
            
        }
        
    }
    
}


@end
