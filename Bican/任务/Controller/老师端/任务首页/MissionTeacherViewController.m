//
//  MissionTeacherViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MissionTeacherViewController.h"
#import "MissionTeacherTableViewCell.h"
#import "MissionModel.h"
#import "MissionClassModel.h"

#import "MissionTeacherhHistoryViewController.h"
#import "MissionClassViewController.h"
#import "MissionUnfinishedViewController.h"
#import "MissionCompletedViewController.h"
#import "AddClassViewController.h"

@interface MissionTeacherViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIImageView *centerImageView;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *tableFooterView;
@property (nonatomic, strong) UIButton *checkMoreButton;

@property (nonatomic, strong) NSMutableArray *thisWeekArray;//本周
@property (nonatomic, strong) NSMutableArray *lastWeekArray;//上周

@property (nonatomic, strong) NSString *data;
@property (nonatomic, strong) NSString *completeWordCount;

@property (nonatomic, strong) MissionModel *thisWeekModel;
@property (nonatomic, strong) MissionModel *lastWeekModel;

@property (nonatomic, assign) BOOL isHaveClass;//是否加入过班级
@property (nonatomic, strong) UIView *emptyView;

@end

@implementation MissionTeacherViewController

- (NSMutableArray *)thisWeekArray
{
    if (!_thisWeekArray) {
        _thisWeekArray = [NSMutableArray array];
    }
    return _thisWeekArray;
}

- (NSMutableArray *)lastWeekArray
{
    if (!_lastWeekArray) {
        _lastWeekArray = [NSMutableArray array];
    }
    return _lastWeekArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    [self createEmptyView];

}

#pragma mark - 创建数据为空的页面
- (void)createEmptyView
{
    self.emptyView = [[UIView alloc] init];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.emptyView];
    
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"search_no_img"];
    [self.emptyView addSubview:imageView];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(GTH(320));
        make.center.equalTo(self.view);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"还不能查看任务哦 , 需要先加入班级";
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = ZTTitleColor;
    titleLabel.font = FONT(28);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.emptyView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.top.equalTo(imageView.mas_bottom).offset(GTH(30));
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
    }];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setTitle:@"加入班级" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [addButton setBackgroundColor:ZTOrangeColor];
    addButton.layer.masksToBounds = YES;
    addButton.layer.cornerRadius = GTH(30);
    addButton.titleLabel.font = FONT(30);
    [addButton addTarget:self action:@selector(addClassButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.emptyView addSubview:addButton];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(titleLabel);
        make.top.equalTo(titleLabel.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(GTH(80));
        make.width.mas_equalTo(GTW(160));
    }];
    
    self.emptyView.hidden = YES;
    
}

#pragma mark - 加入班级
- (void)addClassButtonAction
{
    AddClassViewController *addClassVC = [[AddClassViewController alloc] init];
    [self pushVC:addClassVC animated:YES IsNeedLogin:YES];

}

#pragma mark - 创建TableHeaderView
- (UIView *)createTableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(545))];
        _tableHeaderView.backgroundColor = [UIColor whiteColor];

        _centerView = [[UIView alloc] init];
        _centerView.backgroundColor = [UIColor whiteColor];
        //阴影的透明度
        _centerView.layer.shadowOpacity = 0.24f;
        _centerView.layer.shadowRadius = GTH(20);
        _centerView.layer.cornerRadius = GTH(20);
        [_tableHeaderView addSubview:_centerView];
        [_centerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tableHeaderView.mas_left).offset(GTW(28));
            make.width.mas_equalTo(ScreenWidth - GTW(28) * 2);
            make.top.equalTo(_tableHeaderView.mas_top).offset(GTH(40));
            make.bottom.equalTo(_tableHeaderView.mas_bottom).offset(GTH(-40));
        }];

        _centerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"renwu-bg"]];
        [_centerView addSubview:_centerImageView];
        [_centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(_centerView);
            make.height.mas_equalTo(GTH(110));
        }];

        _centerLabel = [[UILabel alloc] init];
        _centerLabel.center = _centerImageView.center;
        _centerLabel.text = @"本周任务";
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        _centerLabel.textColor = [UIColor whiteColor];
        _centerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
        [_centerView addSubview:_centerLabel];
        [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(_centerImageView);
        }];

        _tipLabel = [[UILabel alloc] init];
        _tipLabel.text = @"任务概述";
        _tipLabel.textColor = ZTTextGrayColor;
        _tipLabel.font = FONT(28);
        [_centerView addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_centerImageView.mas_bottom).offset(GTH(42));
            make.left.equalTo(_centerView.mas_left).offset(GTW(36));
        }];

        _titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title-icon"]];
        [_centerView addSubview:_titleImageView];
        [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_tipLabel);
            make.top.equalTo(_tipLabel.mas_bottom).offset(GTH(36));
            make.size.mas_equalTo(CGSizeMake(GTW(20), GTH(32)));
        }];

        _titleLabel = [[UILabel alloc] init];
        if (self.data.length != 0) {
            _titleLabel.text = self.data;
        } else {
            _titleLabel.text = @"暂无任务";
        }
        _titleLabel.textColor = ZTTitleColor;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
        [_centerView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleImageView.mas_right).offset(GTW(10));
            make.right.equalTo(_centerView.mas_right).offset(GTW(-36));
            make.top.equalTo(_titleImageView);
        }];

        _contentLabel = [[UILabel alloc] init];
        _contentLabel.text = self.completeWordCount;
        _contentLabel.textColor = ZTTextGrayColor;
        _contentLabel.numberOfLines = 3;
        _contentLabel.font = FONT(30);
        [_centerView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(GTH(36));
        }];
        //设置间距
//        _contentLabel.attributedText = [UILabel setLabelSpace:_contentLabel withValue:_contentLabel.text withFont:_contentLabel.font];
//        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    }
    return _tableHeaderView;
}

#pragma mark - 创建TableFooterView
- (UIView *)createTableFooterView
{
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, GTH(82))];
        _tableFooterView.backgroundColor = [UIColor whiteColor];
        
        _checkMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkMoreButton.frame = CGRectMake(0, 0, ScreenWidth, _tableFooterView.frame.size.height);
        _checkMoreButton.titleLabel.font = FONT(24);
        [_checkMoreButton setTitle:@"查看历史任务" forState:UIControlStateNormal];
        [_checkMoreButton setTitleColor:ZTBlueColor forState:UIControlStateNormal];
        [_checkMoreButton setImage:[UIImage imageNamed:@"list-more"] forState:UIControlStateNormal];
        _checkMoreButton.adjustsImageWhenHighlighted = NO;
        [_checkMoreButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:GTH(20)];
        [_checkMoreButton addTarget:self action:@selector(checkMore) forControlEvents:UIControlEventTouchUpInside];
        [_tableFooterView addSubview:_checkMoreButton];
    }
    return _tableFooterView;
}

#pragma mark - 查看历史任务
- (void)checkMore
{
    MissionTeacherhHistoryViewController *historyVC = [[MissionTeacherhHistoryViewController alloc] init];
    [self pushVC:historyVC animated:YES IsNeedLogin:YES];
}

#pragma mark - 获取教师执教班级列表以及学生数量
- (void)getClassInfoByTeacher
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/class/getClassInfoByTeacher", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        if (array.count == 0) {
            self.isHaveClass = NO;
        } else {
            self.isHaveClass = YES;
        }
        //如果没有加入任何班级
        if (!self.isHaveClass) {
            self.emptyView.hidden = NO;
            return;
        }
        self.emptyView.hidden = YES;
        [self getTaskDescription];
        [self teacherListWithType:@"1"];
        [self teacherListWithType:@"2"];

    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 获取任务描述
- (void)getTaskDescription
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:@"0" forKey:@"taskType"];
    NSString *url = [NSString stringWithFormat:@"%@api/task/getTaskDescription", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [self.data isEqualToString:@"data"];
        [self.completeWordCount isEqualToString:@"completeWordCount"];
        
    } errorHandler:^(NSError *error) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        
    } reloadHandler:^(BOOL isReload) {
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}


#pragma mark - 获取老师任务列表
- (void)teacherListWithType:(NSString *)type
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //任务类型: 1-本周任务, 2-上周任务, 3-历史任务
    [params setValue:type forKey:@"type"];
    NSString *url = [NSString stringWithFormat:@"%@api/task/teacherList", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        if ([type isEqualToString:@"1"]) {
            [self.thisWeekArray removeAllObjects];
        }
        if ([type isEqualToString:@"2"]) {
            [self.lastWeekArray removeAllObjects];
        }
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dataDic = [resultObject objectForKey:@"data"];
        NSMutableArray *listArray = [dataDic objectForKey:@"list"];
        NSMutableDictionary *dic = listArray[0];
        
        if ([type isEqualToString:@"1"]) {
            self.thisWeekModel = [[MissionModel alloc] init];
            [self.thisWeekModel setValuesForKeysWithDictionary:dic];
            for (NSMutableDictionary *littleDic in self.thisWeekModel.classList) {
                MissionClassModel *model = [[MissionClassModel alloc] init];
                [model setValuesForKeysWithDictionary:littleDic];
                [self.thisWeekArray addObject:model];
            }
        }
        if ([type isEqualToString:@"2"]) {
            self.lastWeekModel = [[MissionModel alloc] init];
            [self.lastWeekModel setValuesForKeysWithDictionary:dic];
            for (NSMutableDictionary *littleDic in self.lastWeekModel.classList) {
                MissionClassModel *model = [[MissionClassModel alloc] init];
                [model setValuesForKeysWithDictionary:littleDic];
                [self.lastWeekArray addObject:model];
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

#pragma mark - 创建UITableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [self createTableFooterView];
    self.tableView.tableHeaderView = [self createTableHeaderView];

    self.tableView.rowHeight = GTH(100);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
    }];
    
    //刷新数据
    //mj_header
    self.tableView.mj_header = [self createMJRefreshGifHeaderWithSelector:@selector(refreshData)];
    
}

//刷新数据
- (void)refreshData
{
    [self getClassInfoByTeacher];
    
}

#pragma mark - TableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.thisWeekArray.count;
    }
    return self.lastWeekArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"missionTeacherCell";
    MissionTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[MissionTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    MissionClassModel *model = [[MissionClassModel alloc] init];
    if (indexPath.section == 0) {//本周
        if (self.thisWeekArray.count == 0) {
            return cell;
        }
        model = self.thisWeekArray[indexPath.row];
        
    } else {//上周
        if (self.lastWeekArray.count == 0) {
            return cell;
        }
        model = self.lastWeekArray[indexPath.row];

    }
    [cell setMissionTeacherCellWithTypeText:model.grade
                                  TypeColor:ZTOrangeColor
                                   LeftText:model.className
                                  RightText:model.completeCount
                               RightAllText:model.totalCount
                                 RightColor:ZTBlueColor];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MissionClassModel *model = [[MissionClassModel alloc] init];
    //跳转到 -> 班级任务
    MissionClassViewController *classVC = [[MissionClassViewController alloc] init];
    
    if (indexPath.section == 0) {//本周
        model = self.thisWeekArray[indexPath.row];
        classVC.startDate = self.thisWeekModel.startDate;
        classVC.endDate = self.thisWeekModel.endDate;
        classVC.schoolName = self.thisWeekModel.schoolName;
        
    } else {//上周
        model = self.lastWeekArray[indexPath.row];
        classVC.startDate = self.lastWeekModel.startDate;
        classVC.endDate = self.lastWeekModel.endDate;
        classVC.schoolName = self.lastWeekModel.schoolName;

    }
    classVC.classId = model.classId;
    classVC.grade = model.grade;
    classVC.className = model.className;
    classVC.completeCount = model.completeCount;
    classVC.totalCount = model.totalCount;
    [self pushVC:classVC animated:YES IsNeedLogin:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return GTH(100);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat label_width = (ScreenWidth - GTW(28) * 2) / 2;
    CGFloat label_height = GTH(100);

    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, ScreenWidth, label_height);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.frame = CGRectMake(GTW(28), 0, label_width, label_height);
    if (section == 0) {
        leftLabel.text = @"本周任务";
    }
    if (section == 1) {
        leftLabel.text = @"上周任务";
    }
    leftLabel.textColor = ZTTitleColor;
    leftLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [view addSubview:leftLabel];
    
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.frame = CGRectMake(label_width + GTW(28), 0, label_width, label_height);
    if (section == 0) {
        rightLabel.text = self.thisWeekModel.schoolName;
    } else {
        rightLabel.text = self.lastWeekModel.schoolName;
    }
    rightLabel.textColor = ZTTextLightGrayColor;
    rightLabel.font = FONT(24);
    rightLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:rightLabel];
    
    UILabel *lineLabele = [[UILabel alloc] initWithFrame:CGRectMake(0, label_height - 1, ScreenWidth, 1)];
    lineLabele.backgroundColor = ZTLineGrayColor;
    [view addSubview:lineLabele];
    
    return view;
}



@end
