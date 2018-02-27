
//
//  NowCorrectViewController.m
//  Bican
//
//  Created by bican on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "NowCorrectViewController.h"
#import "NowCorrectTableViewCell.h"
#import "InviteModel.h"
#import "InviteGiftModel.h"

#import "FindDetailViewController.h"
#import "CommendArticleDetailViewController.h"
#import "WalletViewController.h"

@interface NowCorrectViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,  NowCorrectCellDelegate, CommendArticleDelegate, GiftTipViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) GiftTipView *giftTipView;

@property (nonatomic, strong) UIButton *mineStudentButton;
@property (nonatomic, strong) UIButton *otherStudentButton;

@property (nonatomic, strong) NSMutableArray *otherStudentArray;
@property (nonatomic, strong) NSMutableArray *mineStudentArray;
@property (nonatomic, assign) BOOL isMine;//是否是我的学生

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)
@end

@implementation NowCorrectViewController

- (NSMutableArray *)otherStudentArray
{
    if (!_otherStudentArray) {
        _otherStudentArray = [NSMutableArray array];
    }
    return _otherStudentArray;
}

- (NSMutableArray *)mineStudentArray
{
    if (!_mineStudentArray) {
        _mineStudentArray = [NSMutableArray array];
    }
    return _mineStudentArray;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"childReload" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isMine = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"childReload" object:nil];
    
    [self createHeaderView];
    [self createTableView];
    
}



- (void)createHeaderView
{
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(GTH(100));
    }];
    
    self.mineStudentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mineStudentButton setTitle:@"我的学生" forState:UIControlStateNormal];
    [self.mineStudentButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self.mineStudentButton setImage:[UIImage imageNamed:@"checkbox_a"] forState:UIControlStateSelected];
    self.mineStudentButton.selected = YES;
    self.mineStudentButton.titleLabel.font = FONT(24);
    self.mineStudentButton.titleLabel.textColor = ZTTitleColor;
    self.mineStudentButton.adjustsImageWhenHighlighted = NO;
    [self.mineStudentButton addTarget:self action:@selector(headerButtoAction:) forControlEvents:UIControlEventTouchUpInside];
    self.mineStudentButton.tag = 2233;
    [self.mineStudentButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:GTW(15)];
    [self.mineStudentButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    [self.view addSubview:self.mineStudentButton];

    [self.mineStudentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(40));
        make.top.equalTo(self.view.mas_top).offset(GTH(20));
        make.size.mas_equalTo(CGSizeMake(GTW(200), GTH(50)));
    }];

    self.otherStudentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.otherStudentButton setTitle:@"其他学生" forState:UIControlStateNormal];
    [self.otherStudentButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self.otherStudentButton setImage:[UIImage imageNamed:@"checkbox_a"] forState:UIControlStateSelected];
    self.otherStudentButton.titleLabel.font = FONT(24);
    self.otherStudentButton.titleLabel.textColor = ZTTitleColor;
    self.otherStudentButton.adjustsImageWhenHighlighted = NO;
    [self.otherStudentButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:GTW(15)];
    [self.otherStudentButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.otherStudentButton.tag = 3344;
    [self.otherStudentButton addTarget:self action:@selector(headerButtoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.otherStudentButton];
    
    [self.otherStudentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mineStudentButton.mas_right).offset(GTW(120));
        make.top.width.height.equalTo(self.mineStudentButton);
    }];
    

}

- (void)headerButtoAction:(UIButton *)button
{
    if (button.tag == 2233) {
        self.mineStudentButton.selected = YES;
        self.otherStudentButton.selected = NO;
        self.isMine = YES;
    }
    if (button.tag == 3344) {
        self.mineStudentButton.selected = NO;
        self.otherStudentButton.selected = YES;
        self.isMine = NO;
    }
    [self handling];
    
}

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
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(GTH(100));
    }];
    
    //刷新数据
    //mj_header
    self.tableView.mj_header = [self createMJRefreshGifHeaderWithSelector:@selector(refreshData)];
    
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
    [self handling];
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
    if (self.isMine) {
        return self.mineStudentArray.count;
    }
    return self.otherStudentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"attentionTableViewCell";
    NowCorrectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[NowCorrectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    
    InviteModel *inviteModel = [[InviteModel alloc] init];
    
    if (self.isMine) {
        if (self.mineStudentArray.count == 0) {
            return cell;
        }
        inviteModel = self.mineStudentArray[indexPath.row];
    }
    if (!self.isMine) {
        if (self.otherStudentArray.count == 0) {
            return cell;
        }
        inviteModel = self.otherStudentArray[indexPath.row];
    }
    
    NSMutableArray *flowerListArray = inviteModel.flowerList;
    NSMutableArray *array = [NSMutableArray array];
    for (NSMutableDictionary *dic in flowerListArray) {
        InviteGiftModel *model = [[InviteGiftModel alloc] init];
        NSString *string = [NSString string];
        [model setValuesForKeysWithDictionary:dic];
        string = [NSString stringWithFormat:@"评阅可得：%@朵%@", model.currency, model.name];
        [array addObject:string];
    }
    [cell createNowCorrectTableViewWithAvatar:inviteModel.avatar
                                     Nickname:inviteModel.nickname
                                   SchoolName:inviteModel.schoolName
                                  BigTypeName:inviteModel.bigTypeName
                                        Title:inviteModel.title
                                      Summary:inviteModel.summary
                                       Flower:[array componentsJoinedByString:@","]
                                     Relation:inviteModel.relation
                                 SendDatetime:inviteModel.sendDatetime
                              ReceiveDatetime:inviteModel.receiveDatetime
     ];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InviteModel *inviteModel = [[InviteModel alloc] init];
    if (self.isMine) {
        inviteModel = self.mineStudentArray[indexPath.row];
    }
    if (!self.isMine) {
        inviteModel = self.otherStudentArray[indexPath.row];
    }
    NSMutableArray *flowerListArray = inviteModel.flowerList;
    NSMutableArray *array = [NSMutableArray array];
    for (NSMutableDictionary *dic in flowerListArray) {
        InviteGiftModel *model = [[InviteGiftModel alloc] init];
        NSString *string = [NSString string];
        [model setValuesForKeysWithDictionary:dic];
        string = [NSString stringWithFormat:@"评阅可得：%@朵%@", model.currency, model.name];
        [array addObject:string];
    }
    CGFloat width = ScreenWidth - GTW(30) * 2;
    
    CGSize titleSize = [self getSizeWithString:inviteModel.title font:[UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)] str_width:width];
//    CGSize descSize = [self getSizeWithString:inviteModel.summary font:FONT(28) str_width:width];
    CGSize flowerSize = [self getSizeWithString:[array componentsJoinedByString:@","] font:[UIFont fontWithName:@"Helvetica-Bold" size:GTW(26)] str_width:width - GTW(10) - GTW(35)];

    return GTH(36) + GTH(50) + GTH(34) + titleSize.height + GTH(28) + GTH(120) + GTH(20) * 4 + 1 + flowerSize.height + GTH(78);
    
}

#pragma mark - NowCorrectTableViewCellDelegate
- (void)commendArticleWithCell:(NowCorrectTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    InviteModel *model = [[InviteModel alloc] init];
    if (self.isMine) {
        model = self.mineStudentArray[indexPath.row];
    }
    if (!self.isMine) {
        model = self.otherStudentArray[indexPath.row];
    }
    //总评详情
    CommendArticleDetailViewController *articleVC = [[CommendArticleDetailViewController alloc] init];
    articleVC.inviteModel = model;
    articleVC.delegate = self;
    [self.correctVC pushVC:articleVC animated:YES IsNeedLogin:YES];
    
}

#pragma mark - 如果提交评阅成功
- (void)saveCommendSuccess
{
    //弹出提示框
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.giftTipView = [[GiftTipView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.giftTipView.delegate = self;
    [window addSubview:self.giftTipView];
    
}
#pragma mark - GiftTipViewDelegate
- (void)checkButtonClick
{
    [self.giftTipView removeFromSuperview];
    //跳转到钱包首页
    WalletViewController *walletVC = [[WalletViewController alloc] init];
    [self.correctVC pushVC:walletVC animated:YES IsNeedLogin:YES];
    
}

- (void)closeButtonClick
{
    [self.giftTipView removeFromSuperview];
}

#pragma mark - 正在评阅接口
- (void)handling
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    UserInformation *user = [GetUserInfo getUserInfoModel];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/invite/handling", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (self.isUpData == NO) {
            [self.mineStudentArray removeAllObjects];
            [self.otherStudentArray removeAllObjects];
        }
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        NSMutableArray *listArray = [dic objectForKey:@"list"];
        for (NSMutableDictionary *dic in listArray) {
            InviteModel *model = [[InviteModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            if ([model.relation isEqualToString:@"1"]) {
                [self.mineStudentArray addObject:model];
            } else {
                [self.otherStudentArray addObject:model];
            }
        }
        
        [self.tableView reloadData];

    } errorHandler:^(NSError *error) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];

        
    } reloadHandler:^(BOOL isReload) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}




@end
