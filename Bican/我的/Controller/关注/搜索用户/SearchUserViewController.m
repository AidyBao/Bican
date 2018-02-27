//
//  SearchUserViewController.m
//  Bican
//
//  Created by bican on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "SearchUserViewController.h"
#import "SearchUserTableViewCell.h"
#import "UserSearchResultModel.h"
#import "UserIntroViewController.h"

@interface SearchUserViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *backHeaderView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)
@end

@implementation SearchUserViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"搜索用户";
    
    [self createSubViews];
    [self createTableView];

}

- (void)createSubViews
{
    self.backHeaderView = [[UIView alloc] init];
    self.backHeaderView.backgroundColor = ZTNavColor;
    [self.view addSubview:self.backHeaderView];
    
    [self.backHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.height.mas_equalTo(GTH(100));
    }];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    [self.searchButton setBackgroundColor:ZTLineGrayColor];
    self.searchButton.layer.cornerRadius = GTH(10);
    self.searchButton.adjustsImageWhenHighlighted = NO;
    self.searchButton.titleLabel.font = FONT(24);
    [self.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchButton];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backHeaderView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.backHeaderView.mas_top).offset(GTH(20));
        make.size.mas_equalTo(CGSizeMake(GTW(80), GTH(100) - GTH(40)));
    }];
    
    
    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.searchTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTextField setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    self.searchTextField.textColor = ZTTitleColor;
    self.searchTextField.backgroundColor = ZTLineGrayColor;
    self.searchTextField.layer.cornerRadius = GTH(10);
    self.searchTextField.delegate = self;
    self.searchTextField.font = FONT(24);
    [self.searchTextField resignFirstResponder];
    self.searchTextField.placeholder = @"搜索用户";
    [self.view addSubview:self.searchTextField];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backHeaderView.mas_left).offset(GTW(28));
        make.top.equalTo(self.backHeaderView.mas_top).offset(GTH(20));
        make.right.equalTo(self.searchButton.mas_left).offset(GTW(-28));
        make.height.equalTo(self.searchButton);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
}


- (void)textFieldChanged:(NSNotification *)notification
{
    if (self.searchTextField.text.length != 0) {
        [self.searchButton setBackgroundColor:ZTOrangeColor];
    } else {
        [self.searchButton setBackgroundColor:ZTLineGrayColor];
    }
    //记录搜索的内容
    self.searhStr = self.searchTextField.text;
  
    
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
    self.tableView.rowHeight = GTH(160);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(GTH(100) + NAV_HEIGHT);
    }];
    
    //刷新数据
    //mj_header
    self.tableView.mj_header = [self createMJRefreshGifHeaderWithSelector:@selector(refreshData)];
    
    //mj_footer
    self.tableView.mj_footer = [self createMJRefreshBackGifFooterWithSelector:@selector(loadMoreData)];

}


//刷新数据
- (void)refreshData
{
    self.isUpData = NO;
    self.start_row = 1;
    self.page_size = 10;
    [self get_user_list];
    
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self get_user_list];
}


#pragma mark - DZNEmptyDataSetSource协议方法
//设置title
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"没有搜到哦, 换个关键词试试呗";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(28), NSForegroundColorAttributeName:ZTTitleColor, NSParagraphStyleAttributeName:paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"search_no_img"];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"searchUesrTableViewCell";
    SearchUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[SearchUserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    UserSearchResultModel *model = self.dataSourceArray[indexPath.row];
    
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_header"]];
    //如果是老师
    if ([model.roleType isEqualToString:@"2"]) {
        if (model.teacherName.length != 0) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.nickName, model.teacherName];
        } else {
            cell.nameLabel.text = model.nickName;
        }
    } else {
        cell.nameLabel.text = model.nickName;
    }
    //学生显示班级
    if ([model.roleType isEqualToString:@"1"]) {
        if (model.grade.length == 0) {
            cell.classLabel.text = [NSString stringWithFormat:@"%@", model.schoolName];
        } else {
            cell.classLabel.text = [NSString stringWithFormat:@"%@ · %@", model.schoolName, model.grade];
        }
    }
    
    cell.keyWord = self.searhStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserSearchResultModel *model = self.dataSourceArray[indexPath.row];
    UserIntroViewController *userIntroVC = [[UserIntroViewController alloc] init];
    userIntroVC.userModel = model;
    [self pushVC:userIntroVC animated:YES IsNeedLogin:YES];
    
}


#pragma mark - 检索用户列表
- (void)get_user_list
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //角色: 1-学生, 2-老师,0-默认:所有角色类型
    [params setValue:@"0" forKey:@"roleType"];
    //是否首页检索: 1-是, 0-否
    [params setValue:@"1" forKey:@"indexQuery"];
    [params setValue:self.searhStr forKey:@"keyWords"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/user/list", BASE_URL];
    
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
        //记录所有的页数
        NSMutableDictionary *pages = [dataDic objectForKey:@"pages"];
        self.pageCount = [NSString stringWithFormat:@"%@", [pages objectForKey:@"pageCount"]];
        NSMutableArray *array = [dataDic objectForKey:@"list"];
        for (NSMutableDictionary *dic in array) {
            UserSearchResultModel *model = [[UserSearchResultModel alloc] init];
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
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - 搜索按钮方法
- (void)searchButtonAction
{
    [self.searchTextField resignFirstResponder];
    if (self.searhStr.length == 0) {
        return;
    }
    [self get_user_list];
}

#pragma mark - UITextField的协议方法
//点击return键,取消键盘第一响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTextField resignFirstResponder];
    
    return YES;
}

//点击空白处,取消键盘第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchTextField resignFirstResponder];
    
    
}



@end
