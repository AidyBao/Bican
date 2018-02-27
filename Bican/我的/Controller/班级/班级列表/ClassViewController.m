


//
//  ClassViewController.m
//  Bican
//
//  Created by bican on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ClassViewController.h"
#import "MineTableViewCell.h"
#import "ClassModel.h"

#import "AddClassViewController.h"
#import "MyClassViewController.h"

@interface ClassViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ClassViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getClassInfoByTeacher];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的班级";
    [self createRightNavigationItem:nil Title:@"添加班级" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:0];

    [self getClassInfoByTeacher];
    [self createTableView];
}


#pragma mark - 加入班级页面
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    if (self.dataArray.count == 4) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"任教老师的班级不能超过4个" Time:3.0];
        return;
    }
    AddClassViewController *addVC = [[AddClassViewController alloc] init];
    if ([GetUserInfo getUserInfoModel].classId.length != 0) {
        //如果已经加入过班级, 传值
        NSString *province = [GetProvinceDataManager getProvinceNameWithProvinceId:[GetUserInfo getUserInfoModel].provinceId];
        NSString *city = [GetProvinceDataManager getCityNameWithProvinceId:[GetUserInfo getUserInfoModel].provinceId CityId:[GetUserInfo getUserInfoModel].cityId];
        addVC.oldProvinceCity = [NSString stringWithFormat:@"%@%@", province, city];
        addVC.oldSchool = [GetUserInfo getUserInfoModel].schoolName;
    }
    [self pushVC:addVC animated:YES IsNeedLogin:YES];
}

#pragma mark - 获取教师执教班级列表以及学生数量
- (void)getClassInfoByTeacher
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@api/class/getClassInfoByTeacher", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.dataArray removeAllObjects];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            ClassModel *classModel = [[ClassModel alloc] init];
            [classModel setValuesForKeysWithDictionary:dic];
            [self.dataArray addObject:classModel];
        }
        
        [self.tableView reloadData];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 创建TableView
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
    self.tableView.rowHeight = GTH(100);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
    }];
}

#pragma mark - DZNEmptyDataSetSource协议方法
//设置title
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"您还没有加入班级哦";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(28), NSForegroundColorAttributeName:ZTTitleColor, NSParagraphStyleAttributeName:paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_banji_img"];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classListCell"];
    if (!cell) {
        cell = [[MineTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"classListCell"];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.dataArray.count == 0) {
        return cell;
    }
    ClassModel *classModel = self.dataArray[indexPath.row];
    [cell setMineTableViewCellWithLeftText:classModel.className LeftFont:FONT(28) LeftColor:ZTTitleColor RightText:@"" RightFont:nil RightColor:nil IsShowButton:YES];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ClassModel *classModel = self.dataArray[indexPath.row];
    //我的班级
    MyClassViewController *myClassVC = [[MyClassViewController alloc] init];
    myClassVC.className = classModel.className;
    myClassVC.studentCount = classModel.studentCount;
    myClassVC.classId = classModel.classId;
    
    [self pushVC:myClassVC animated:YES IsNeedLogin:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return 0;
    }
    return  GTH(110) + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataArray.count == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(110) + 1)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(GTW(30), 0, ScreenWidth - GTW(30) * 2, view.frame.size.height - 1)];
    
    label.text = [GetUserInfo getUserInfoModel].schoolName;
    label.textColor = ZTTitleColor;
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [view addSubview:label];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, GTH(110), ScreenWidth, 1)];
    lineView.backgroundColor = ZTLineGrayColor;
    [view addSubview:lineView];
    
    return view;
}



@end
