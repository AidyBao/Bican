//
//  MissionFilterViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MissionFilterViewController.h"
#import "ZTBottomSelectedSingleView.h"
#import "ZTPickerView.h"
#import "ClassModel.h"

@interface MissionFilterViewController () <ZTPickerViewDelegate, ZTBottomSelectedSingleViewDelegate>

@property (nonatomic, strong) UIButton *clearButton;//清除条件按钮
@property (nonatomic, strong) UILabel *dateFilterLabel;//时间筛选
@property (nonatomic, strong) UILabel *classFilterLabel;//班级筛选
@property (nonatomic, strong) UIButton *chooseClassButton;//选择班级按钮
@property (nonatomic, strong) UIButton *downButton;//下拉按钮
@property (nonatomic, strong) ZTPickerView *startPickerView;///开始日期
@property (nonatomic, strong) ZTPickerView *endPickerView;//结束日期
@property (nonatomic, strong) NSString *startStr;//开始时间
@property (nonatomic, strong) NSString *endStr;//结束时间

@property (nonatomic, strong) ZTBottomSelectedSingleView *bottomSelectedSingleView;
@property (nonatomic, strong) NSMutableArray *selectedClassIndexArray;//选择的班级
@property (nonatomic, strong) NSMutableArray *classArray;

@end

@implementation MissionFilterViewController

- (NSMutableArray *)selectedClassIndexArray
{
    if (!_selectedClassIndexArray) {
        _selectedClassIndexArray = [NSMutableArray array];
    }
    return _selectedClassIndexArray;
}

- (NSMutableArray *)classArray
{
    if (!_classArray) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLeftNavigationItem:nil Title:@"取消"];
    
    [self createRightNavigationItem:nil Title:@"确定" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:GTH(20)];

    [self createUI];
    [self creatBottomTableView];
}

#pragma mark - 确认按钮
- (void)RightNavigationButtonClick:(UIButton *)leftbtn
{
    if (self.startStr.length == 8 && self.endStr.length == 0) {
        [MBHUDManager showBriefAlert:@"请选择结束日期 ! "];
        return;
    }
    if (self.endStr.length == 8 && self.startStr.length == 0) {
        [MBHUDManager showBriefAlert:@"请选择开始日期 ! "];
        return;
    }
    if (self.startStr.length != 0) {
        if (self.startStr.length < 8) {
            [MBHUDManager showBriefAlert:@"请选择完整的开始日期 ! "];
            return;
        }
    }
    if (self.endStr.length != 0) {
        if (self.endStr.length < 8) {
            [MBHUDManager showBriefAlert:@"请选择完整的结束日期 ! "];
            return;
        }
    }
    //协议传值: 开始日期 && 结束日期 && 选择的班级
    if ([self.delegate respondsToSelector:@selector(startDate:EndDate:SelelctedClassIndex:)]) {
 
        NSString *string = [NSString string];
        NSMutableArray *array = [NSMutableArray array];
        if (self.selectedClassIndexArray.count != 0) {
            for (int i = 0; i < self.selectedClassIndexArray.count; i++) {
                NSString *index = self.selectedClassIndexArray[i];
                ClassModel *model = self.classArray[[index integerValue]];
                [array addObject:model.classId];
            }
            string = [array componentsJoinedByString:@","];
        }
        //classId已经拼接
        [self.delegate startDate:self.startStr EndDate:self.endStr SelelctedClassIndex:string];
        [self popVCAnimated:YES];
    }
    
}

#pragma mark - 取消按钮
- (void)LeftNavigationButtonClick:(UIButton *)rightbtn
{
    [self popVCAnimated:YES];
}

#pragma mark - 获取教师执教班级列表
- (void)getClassByTeacher
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/class/getClassByTeacher", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.classArray removeAllObjects];
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            ClassModel *model = [[ClassModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.classArray addObject:model];
        }
        //显示选择的view
        self.bottomSelectedSingleView.isCanChooseMore = YES;
        NSMutableArray *result = [NSMutableArray array];
        for (ClassModel *model in self.classArray) {
            [result addObject:model.className];
        }
        [self.bottomSelectedSingleView setBottomSelectedSingleViewWithArray:
         result Title:@"选择班级" SelectedStr:@""];
        self.bottomSelectedSingleView.hidden = NO;
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 创建BottomTableView
- (void)creatBottomTableView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bottomSelectedSingleView = [[ZTBottomSelectedSingleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bottomSelectedSingleView.hidden = YES;
    self.bottomSelectedSingleView.delegate = self;
    
    [window addSubview:self.bottomSelectedSingleView];
    
}

#pragma mark - ZTBottomSelectedSingleViewDelegate
//单选
- (void)singleViewSelectedCotent:(NSString *)selectedCount SelectedIndex:(NSInteger)selectedIndex
{
    
}

//多选
- (void)singleViewSelectedCotentArray:(NSMutableArray *)selectedCotentArray
                   SelectedIndexArray:(NSMutableArray *)selectedIndexArray
{
    //记录选择的班级下标
    [self.selectedClassIndexArray removeAllObjects];
    if (selectedIndexArray.count == 0) {
        return;
    }
    [self.selectedClassIndexArray addObjectsFromArray:selectedIndexArray[0]];
    [self.chooseClassButton setTitle:[selectedCotentArray[0] componentsJoinedByString:@","] forState:UIControlStateNormal];
}


//搜索按钮
- (void)selectedSingleVSearchButtonAction
{
    
}

#pragma mark - 创建页面
- (void)createUI
{
    //时间筛选
    self.dateFilterLabel = [[UILabel alloc] init];
    self.dateFilterLabel.text = @"时间筛选";
    self.dateFilterLabel.backgroundColor = ZTOrangeColor;
    self.dateFilterLabel.textColor = [UIColor whiteColor];
    self.dateFilterLabel.font = FONT(26);
    self.dateFilterLabel.textAlignment = NSTextAlignmentCenter;
    self.dateFilterLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(136), GTH(48))];
    [self.view addSubview:self.dateFilterLabel];
    
    [self.dateFilterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(GTH(20) + NAV_HEIGHT);
        make.left.equalTo(self.view).offset(GTW(28));
        make.size.mas_equalTo(CGSizeMake(GTW(136), GTH(48)));
    }];
    
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setTitle:@"清除条件" forState:UIControlStateNormal];
    [self.clearButton setTitleColor:ZTTextLightGrayColor forState:UIControlStateNormal];
    self.clearButton.titleLabel.font = FONT(28);
    self.clearButton.adjustsImageWhenHighlighted = NO;
    self.clearButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.clearButton addTarget:self action:@selector(clearButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];
    
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(GTW(-28));
        make.centerY.equalTo(self.dateFilterLabel);
    }];
    
    UILabel *dateLineLabel = [[UILabel alloc] init];
    dateLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:dateLineLabel];
    
    [dateLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateFilterLabel);
        make.right.equalTo(self.clearButton);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.dateFilterLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.startPickerView = [[ZTPickerView alloc] init];
    self.startPickerView.backgroundColor = [UIColor whiteColor];
    self.startPickerView.delegate = self;
    self.startPickerView.tag = 22333;
    [self.view addSubview:self.startPickerView];
    
    [self.startPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dateLineLabel.mas_bottom).offset(1);
        make.height.mas_equalTo(GTH(296));
        make.left.equalTo(self.dateFilterLabel);
        make.right.equalTo(self.clearButton);
    }];
    [self.startPickerView setPickerViewWithStartDate:self.bengin_start EndDate:self.bengin_end Title:@"开始日期" ComponentsCount:3];
    
    UILabel *pickerLineLabel = [[UILabel alloc] init];
    pickerLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:pickerLineLabel];
    
    [pickerLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(dateLineLabel);
        make.top.equalTo(self.startPickerView.mas_bottom);
    }];
    
    self.endPickerView = [[ZTPickerView alloc] init];
    self.endPickerView.backgroundColor = [UIColor whiteColor];
    self.endPickerView.delegate = self;
    self.endPickerView.tag = 33444;
    [self.view addSubview:self.endPickerView];
    
    [self.endPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pickerLineLabel.mas_bottom).offset(1);
        make.left.right.height.equalTo(self.startPickerView);
    }];
    [self.endPickerView setPickerViewWithStartDate:self.end_start EndDate:self.end_end Title:@"结束日期" ComponentsCount:3];
    
    //班级筛选
    self.classFilterLabel = [[UILabel alloc] init];
    self.classFilterLabel.text = @"班级筛选";
    self.classFilterLabel.backgroundColor = ZTOrangeColor;
    self.classFilterLabel.textColor = [UIColor whiteColor];
    self.classFilterLabel.font = FONT(26);
    self.classFilterLabel.textAlignment = NSTextAlignmentCenter;
    self.classFilterLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(136), GTH(48))];
    [self.view addSubview:self.classFilterLabel];
    
    [self.classFilterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endPickerView.mas_bottom).offset(GTH(20));
        make.left.equalTo(self.view).offset(GTW(28));
        make.size.mas_equalTo(CGSizeMake(GTW(136), GTH(48)));
    }];
    
    UILabel *classLineLabel = [[UILabel alloc] init];
    classLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:classLineLabel];
    
    [classLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(dateLineLabel);
        make.top.equalTo(self.classFilterLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.chooseClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseClassButton setTitle:@"全部班级" forState:UIControlStateNormal];
    [self.chooseClassButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.chooseClassButton.titleLabel.font = FONT(30);
    self.chooseClassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.chooseClassButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.chooseClassButton addTarget:self action:@selector(chooseClassButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chooseClassButton];
    
    [self.chooseClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(GTH(90));
        make.left.right.equalTo(classLineLabel);
        make.top.equalTo(classLineLabel.mas_bottom);
    }];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downButton setImage:[UIImage imageNamed:@"bt-paixu"] forState:UIControlStateNormal];
    [self.view addSubview:self.downButton];
    
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(13), GTH(7)));
        make.right.equalTo(classLineLabel.mas_right).offset(GTW(-13));
        make.centerY.equalTo(self.chooseClassButton);
    }];
    
    UILabel *buttonLineLabel = [[UILabel alloc] init];
    buttonLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:buttonLineLabel];
    
    [buttonLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(dateLineLabel);
        make.top.equalTo(self.chooseClassButton.mas_bottom);
    }];
    
}

#pragma mark - 清除时间的筛选条件
- (void)clearButtonAction
{
    self.startStr = @"";
    self.endStr = @"";
    [self.startPickerView setPickerToNone];
    [self.endPickerView setPickerToNone];
    
}

#pragma mark - ZTPickerViewDelegate
- (void)selectedPickerView:(ZTPickerView *)pickerView WithContent:(NSString *)content
{
    //开始日期
    if (pickerView.tag == 22333) {
        self.startStr = content;
    }
    //结束日期
    if (pickerView.tag == 33444) {
        self.endStr = content;
    }
}

#pragma mark - 显示view
- (void)chooseClassButtonAction
{
    [self getClassByTeacher];
    
}




@end
