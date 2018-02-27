//
//  MessageViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//  通知

#import "MessageViewController.h"
#import "MessageTableViewCell.h"
#import "CommentViewController.h"//评论
#import "CollectAndGoodViewController.h"//收藏和赞
#import "MessageInviteViewController.h"//邀请
#import "GuanzhuViewController.h"//关注
#import "MessageModel.h"

@interface MessageViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *dataArray;
//@property (nonatomic, strong) NSString *unreadNumber;//未读数量

@property (nonatomic, strong) NSString *attentionCount;
@property (nonatomic, strong) NSString *collectionCount;
@property (nonatomic, strong) NSString *inviteCount;
@property (nonatomic, strong) NSString *recommendCount;
@property (nonatomic, strong) NSString *commentCount;

@property (nonatomic, strong) NSMutableArray *unReadArray;

@end

@implementation MessageViewController

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithObjects:@"pinglun", @"shouchanghezan", @"yaoqin", @"guanzhu", nil];
    }
    return _imageArray;
}

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithObjects:@"评论", @"收藏和赞", @"邀请", @"关注", nil];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)unReadArray
{
    if (!_unReadArray) {
        _unReadArray = [NSMutableArray array];
    }
    return _unReadArray;
}


- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"informationReload" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageCount) name:@"informationReload" object:nil];
    [self createTableView];
    [self messageCount];
}

#pragma mark - 创建TableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = GTH(118) + 1;
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    
    
}

#pragma mark - 获取分类消息未读数量
- (void)messageCount
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/message/messageCount", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.unReadArray removeAllObjects];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        
        NSMutableDictionary *dataDic = [resultObject objectForKey:@"data"];
        NSString *attentionCount = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"attentionCount"]];
        if ([attentionCount integerValue] > 99) {
            self.attentionCount = @"99+";
        } else {
            self.attentionCount = attentionCount;

        }
        
        NSString *inviteCount = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"inviteCount"]];
        if ([attentionCount integerValue] > 99) {
            self.inviteCount = @"99+";
        } else {
            self.inviteCount = inviteCount;
            
        }
        
        NSString *collectionCount = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"collectionCount"]];
        if ([attentionCount integerValue] > 99) {
            self.collectionCount = @"99+";
        } else {
            self.collectionCount = collectionCount;
            
        }
        
        NSString *commentCount = [NSString stringWithFormat:@"%@", [dataDic objectForKey:@"commentCount"]];
        if ([attentionCount integerValue] > 99) {
            self.commentCount = @"99+";
        } else {
            self.commentCount = commentCount;
            
        }
        
        [self.unReadArray addObject:self.commentCount];
        [self.unReadArray addObject:self.collectionCount];
        [self.unReadArray addObject:self.inviteCount];
        [self.unReadArray addObject:self.attentionCount];
        
        [self.tableView reloadData];

    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"messageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.unReadArray.count == 0) {
        [cell setMessageCellWithImage:(NSString *)self.imageArray[indexPath.row] Title:(NSString *)self.dataSourceArray[indexPath.row] Count:@"" CountBackgroundColor:ZTDarkRedColor];
        
    } else {
        [cell setMessageCellWithImage:(NSString *)self.imageArray[indexPath.row] Title:(NSString *)self.dataSourceArray[indexPath.row] Count:self.unReadArray[indexPath.row] CountBackgroundColor:ZTDarkRedColor];
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {//评论
        CommentViewController *commentVC = [[CommentViewController alloc] init];
        [self.informationVC pushVC:commentVC animated:YES IsNeedLogin:YES];
    }
    if (indexPath.row == 1) {//收藏和赞
        CollectAndGoodViewController *collectVC = [[CollectAndGoodViewController alloc] init];
        [self.informationVC pushVC:collectVC animated:YES IsNeedLogin:YES];
    }
    if (indexPath.row == 2) {//邀请
        MessageInviteViewController *commentVC = [[MessageInviteViewController alloc] init];
        [self.informationVC pushVC:commentVC animated:YES IsNeedLogin:YES];
    }
    if (indexPath.row == 3) {//关注
        GuanzhuViewController *guanzhuVC = [[GuanzhuViewController alloc] init];
        [self.informationVC pushVC:guanzhuVC animated:YES IsNeedLogin:YES];
    }
}



@end
