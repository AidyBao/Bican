//
//  SelectRangeViewController.m
//  Bican
//
//  Created by bican on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "SelectRangeViewController.h"
#import "MineTableViewCell.h"
#import "ClassModel.h"

#import "SelectCompositionViewController.h"
#import "SelectStudentViewController.h"

@interface SelectRangeViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation SelectRangeViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择范围";
    
    [self createTableView];
    [self getClassByTeacher];
}

#pragma mark - 创建tableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = GTH(100);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
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
    return self.dataSourceArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"selectRangeCell";
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    
    if (indexPath.row == self.dataSourceArray.count) {
        [cell setMineTableViewCellWithLeftText:@"邀请我评阅的" LeftFont:FONT(28) LeftColor:ZTTitleColor RightText:nil RightFont:nil RightColor:nil IsShowButton:YES];

    } else {
        if (self.dataSourceArray.count == 0) {
            return cell;
        }
        ClassModel *model = self.dataSourceArray[indexPath.row];
        [cell setMineTableViewCellWithLeftText:model.className LeftFont:FONT(28) LeftColor:ZTTitleColor RightText:nil RightFont:nil RightColor:nil IsShowButton:YES];
        
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.dataSourceArray.count) {
        //邀请我评阅的
        SelectCompositionViewController *selectCompositionVC = [[SelectCompositionViewController alloc] init];
        selectCompositionVC.isFromeInvist = YES;
        [self pushVC:selectCompositionVC animated:YES IsNeedLogin:YES];
        
    } else {
        //选择学生
        ClassModel *model = self.dataSourceArray[indexPath.row];
        SelectStudentViewController *selectStudentVC  = [[SelectStudentViewController alloc] init];
        selectStudentVC.classId = model.classId;
        [self pushVC:selectStudentVC animated:YES IsNeedLogin:YES];
    }
}


#pragma mark - 获取教师执教班级列表
- (void)getClassByTeacher
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/class/getClassByTeacher", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.dataSourceArray removeAllObjects];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            ClassModel *model = [[ClassModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
        }
        [self.tableView reloadData];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}



@end
