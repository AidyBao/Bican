//
//  ZiyouFilterViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/11.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZiyouFilterViewController.h"
#import "ZTBottomSelectedSingleView.h"
#import "ZTBottomTableView.h"
#import "ZTPickerView.h"
#import "FindListModel.h"

@interface ZiyouFilterViewController () <ZTPickerViewDelegate, ZTBottomSelectedSingleViewDelegate, ZTBottomTableViewDelegate>

@property (nonatomic, strong) UIButton *clearDateButton;//清除按钮
@property (nonatomic, strong) UILabel *dateFilterLabel;//时间筛选

@property (nonatomic, strong) UIButton *clearRangButton;//清除按钮
@property (nonatomic, strong) UILabel *rangeFilterLabel;//范围筛选
@property (nonatomic, strong) UILabel *cityLabel;//选择地区
@property (nonatomic, strong) UIButton *chooseCityButton;

@property (nonatomic, strong) UILabel *schoolLabel;//选择学校
@property (nonatomic, strong) UIButton *chooseSchoolButton;

@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UIButton *chooseClassButton;

@property (nonatomic, strong) UIButton *downButton;//下拉按钮
@property (nonatomic, strong) ZTPickerView *startPickerView;///开始日期
@property (nonatomic, strong) ZTPickerView *endPickerView;//结束日期
@property (nonatomic, strong) NSString *startStr;//记录选中的日期
@property (nonatomic, strong) NSString *endStr;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;

@property (nonatomic, strong) ZTBottomSelectedSingleView *bottomSelectedSingleView;

@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) NSMutableArray *gradeArray;

@property (nonatomic, strong) NSMutableArray *schoolNameArray;
@property (nonatomic, strong) NSMutableArray *schoolIdArray;

@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *provinceArray;

@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) NSString *selectedProviceIndex;//选中的省(下标)
@property (nonatomic, strong) NSString *selectedCityIndex;//选中的城市(下标)
@property (nonatomic, strong) NSString *selectedGradeIndex;//选中的年级(下标)
@property (nonatomic, strong) NSString *selectedClassIndex;//选中的班级(下标)
@property (nonatomic, strong) NSString *selectedSchoolIndex;//选中的学校(下标)
@property (nonatomic, assign) NSInteger buttonClick;//记录点击的按钮

@property (nonatomic, strong) ZTBottomTableView *bottomTableView;
@property (nonatomic, strong) NSMutableArray *dateArray;

@end

@implementation ZiyouFilterViewController

- (NSMutableArray *)dateArray
{
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (NSMutableArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray arrayWithArray:[GetProvinceDataManager getAllProvinceModel]];
    }
    return _provinceArray;
}

- (NSMutableArray *)cityArray
{
    if (!_cityArray) {
        _cityArray = [NSMutableArray array];        
        for (ProvinceModel *provinceModel in _provinceArray) {
            NSArray *array = [NSArray array];
            array = [GetProvinceDataManager getCityModelsWithProvinceId:provinceModel.provinceId];
            [_cityArray addObject:array];
        }
    }
    return _cityArray;
}

- (NSMutableArray *)gradeArray
{
    if (!_gradeArray) {
        _gradeArray = [NSMutableArray array];
    }
    return _gradeArray;
}

- (NSMutableArray *)classArray
{
    if (!_classArray) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}

- (NSMutableArray *)schoolNameArray
{
    if (!_schoolNameArray) {
        _schoolNameArray = [NSMutableArray array];
    }
    return _schoolNameArray;
}

- (NSMutableArray *)schoolIdArray
{
    if (!_schoolIdArray) {
        _schoolIdArray = [NSMutableArray array];
    }
    return _schoolIdArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLeftNavigationItem:nil Title:@"取消"];
    
    [self createRightNavigationItem:nil Title:@"确定" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:GTH(20)];
    
    [self getList];
    [self createUI];
    [self createBottomTableView];
    [self creatBottomSelectedSingleView];
    
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
    
    NSDate *beginDate = [NSString dateFromString:self.startStr formatter:@"yyyyMMdd"];
    NSDate *endToDate = [NSString dateFromString:self.endStr formatter:@"yyyyMMdd"];
    
    // -1 表示降序、 0 表示相同  1 表示升序
    if ([endToDate compare:beginDate] < 0) {
        //表示结束时间早于开始时间
        [ZTToastUtils showToastIsAtTop:NO Message:@"结束日期不能早于开始日期, 请重新选择 !" Time:3.0];
        return;
    }
    //协议传值: 开始日期 && 结束日期 && 选择的班级
    if ([self.delegate respondsToSelector:@selector(startDate:EndDate:SelectedProvice:SelectedCity:SelectedSchool:SelectedGrade:SelectedClass:)]) {
        //传值时, 需要传多个id和一个name
        //获取省市的id
        ProvinceModel *model = self.provinceArray[[self.selectedProviceIndex integerValue]];
        NSArray *array = self.cityArray[[self.selectedProviceIndex integerValue]];
        CityModel *cityModel = array[[self.selectedCityIndex integerValue]];
        //获取学校的id
        NSString *schoolId = [NSString string];
        if (self.schoolIdArray.count != 0) {
            schoolId = self.schoolIdArray[[self.selectedSchoolIndex integerValue]];
        }
        //获取年级和班级
        NSString *gradeName = [NSString string];
        if (self.gradeArray.count != 0 && self.selectedGradeIndex.length != 0) {
            gradeName = self.gradeArray[[self.selectedGradeIndex integerValue]];
        }
        MyClassModel *myClassModel = [[MyClassModel alloc] init];
        if (self.classArray.count != 0 && self.selectedClassIndex != 0) {
            NSArray *littleArray = self.classArray[[self.selectedGradeIndex integerValue]];
            myClassModel = littleArray[[self.selectedClassIndex integerValue]];
        }
        
        [self.delegate startDate:self.startStr
                         EndDate:self.endStr
                 SelectedProvice:model.provinceId
                    SelectedCity:cityModel.cityId
                  SelectedSchool:schoolId
                   SelectedGrade:gradeName
                   SelectedClass:myClassModel.my_classId];
        
        [self popVCAnimated:YES];
    }
    
}

#pragma mark - 取消按钮
- (void)LeftNavigationButtonClick:(UIButton *)rightbtn
{
    [self popVCAnimated:YES];
}

#pragma mark - 获取作文精选列表
- (void)getList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.typeIdStr forKey:@"typeId"];
    //1-自由写, 2-命题作
    [params setValue:self.bigTypeId forKey:@"bigTypeId"];
    NSString *url = [NSString stringWithFormat:@"%@api/article/list", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.dateArray removeAllObjects];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSDictionary *dataDic = [resultObject objectForKey:@"data"];
        NSMutableArray *array = [dataDic objectForKey:@"list"];
        for (NSMutableDictionary *dic in array) {
            FindListModel *model = [[FindListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dateArray addObject:model.sendDate];
        }
        [self compareSendDate];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - 比较日期
- (void)compareSendDate
{
    [self.dateArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];//升序
    }];
    
    
    if (self.dateArray.count != 0) {
        self.startPickerView.userInteractionEnabled = YES;
        self.endPickerView.userInteractionEnabled = YES;
        self.startDate = [NSString getStringFromTime:[self.dateArray firstObject]];
        self.endDate = [NSString getStringFromTime:[self.dateArray lastObject]];
 
        [self.startPickerView setPickerViewWithStartDate:self.startDate EndDate:self.endDate Title:@"开始日期" ComponentsCount:3];
        [self.endPickerView setPickerViewWithStartDate:self.startDate EndDate:self.endDate Title:@"结束日期" ComponentsCount:3];
        
    } else {
        self.startPickerView.userInteractionEnabled = NO;
        self.endPickerView.userInteractionEnabled = NO;
        [self.startPickerView setPickerViewWithStartDate:@"" EndDate:@"" Title:@"开始日期" ComponentsCount:3];
        [self.endPickerView setPickerViewWithStartDate:@"" EndDate:@"" Title:@"结束日期" ComponentsCount:3];
    }
    
    
}


#pragma mark - 根据城市id获取学校列表
- (void)getSchoolByCity
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    NSString *cityId = [NSString string];

    if (self.selectedCityIndex.length != 0) {
        NSArray *array = self.cityArray[[self.selectedProviceIndex integerValue]];
        CityModel *cityModel = array[[self.selectedCityIndex integerValue]];
        cityId = cityModel.cityId;
    }
    
    [params setValue:cityId forKey:@"cityId"];
    [params setValue:self.keyWord forKey:@"keyWords"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/sys/getSchoolByCity", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.schoolNameArray removeAllObjects];
        [self.schoolIdArray removeAllObjects];
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            SchoolModel *model = [[SchoolModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.schoolNameArray addObject:model.schoolName];
            [self.schoolIdArray addObject:model.school_id];

        }
        [self hideLoading];
        //重新赋值
        [self.bottomSelectedSingleView setBottomSelectedSingleViewWithArray:self.schoolNameArray Title:@"选择学校" SelectedStr:@""];
        
    } errorHandler:^(NSError *error) {
        
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 根据学校id获取班级年级列表
- (void)getClassBySchoold
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    NSString *schoolId = [NSString string];

    if (self.selectedSchoolIndex.length != 0) {
        schoolId = self.schoolIdArray[[self.selectedSchoolIndex integerValue]];
    }
    
    [params setValue:schoolId forKey:@"schoolId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/class/getClassBySchoold", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.gradeArray removeAllObjects];
        [self.classArray removeAllObjects];

        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            NSString *string = [dic objectForKey:@"gradeName"];
            [self.gradeArray addObject:string];
            
            NSMutableArray *classArray = [NSMutableArray array];
            NSMutableArray *listArray = [dic objectForKey:@"classList"];
            for (NSMutableDictionary *littleDic in listArray) {
                MyClassModel *model = [[MyClassModel alloc] init];
                [model setValuesForKeysWithDictionary:littleDic];
                [classArray addObject:model];
            }
            [self.classArray addObject:classArray];

        }
        [self hideLoading];
        //获取班级的列表
        NSMutableArray *classArray = [NSMutableArray array];
        for (NSArray *array in self.classArray) {
            NSMutableArray *littleArray = [NSMutableArray array];
            for (MyClassModel *myClassModel in array) {
                [littleArray addObject:myClassModel.my_className];
            }
            [classArray addObject:littleArray];
        }
        //重新赋值
        [self.bottomTableView createBottomTableViewWithArray:[NSArray arrayWithObjects:self.gradeArray, classArray, nil] ItemTitleArray:@[@"年级", @"班级"] Title:@"选择班级" SelectedStr:@""];
        
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
- (void)createBottomTableView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bottomTableView = [[ZTBottomTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bottomTableView.hidden = YES;
    self.bottomTableView.delegate = self;
    
    [window addSubview:self.bottomTableView];
}

#pragma mark - ZTBottomTableViewDelegate
- (void)sendSelectedFirstItemIndex:(NSString *)selectedFirstItemIndex
          SelectedFirstItemContent:(NSString *)selectedFirstItemContent
           SelectedSecondItemIndex:(NSString *)selectedSecondItemIndex
         SelectedSecondItemContent:(NSString *)selectedSecondItemContent
{
    NSString *title = [NSString stringWithFormat:@"%@%@", selectedFirstItemContent, selectedSecondItemContent];
    
    if (self.buttonClick == 10001) {
        self.selectedProviceIndex = selectedFirstItemIndex;
        self.selectedCityIndex = selectedSecondItemIndex;
        [self.chooseCityButton setTitle:title forState:UIControlStateNormal];
    }
    if (self.buttonClick == 10003) {
        self.selectedGradeIndex = selectedFirstItemIndex;
        self.selectedClassIndex = selectedSecondItemIndex;
        [self.chooseClassButton setTitle:selectedSecondItemContent forState:UIControlStateNormal];
    }
}

- (void)sendSelectedGradeArray:(NSArray *)selectedGradeArray
       SelectedGradeIndexArray:(NSArray *)selectedGradeIndexArray
            SelectedClassArray:(NSArray *)selectedClassArray
       SelectedClassIndexArray:(NSArray *)selectedClassIndexArray
{

}

#pragma mark - 创建BottomSelectedSingleView
- (void)creatBottomSelectedSingleView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bottomSelectedSingleView = [[ZTBottomSelectedSingleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bottomSelectedSingleView.hidden = YES;
    self.bottomSelectedSingleView.delegate = self;
    
    [window addSubview:self.bottomSelectedSingleView];
    
}

#pragma mark - ZTBottomSelectedSingleViewDelegate
- (void)singleViewSelectedCotent:(NSString *)selectedCount SelectedIndex:(NSInteger)selectedIndex
{
    [self.bottomSelectedSingleView.searchTextField resignFirstResponder];
    self.keyWord = self.bottomSelectedSingleView.searchTextField.text;
    //记录选择的班级的下标
    self.selectedSchoolIndex = [NSString stringWithFormat:@"%ld", selectedIndex];
    if (selectedCount.length == 0) {
        return;
    }
    [self.chooseSchoolButton setTitle:selectedCount forState:UIControlStateNormal];
    
}

- (void)singleViewSelectedCotentArray:(NSMutableArray *)selectedCotentArray SelectedIndexArray:(NSMutableArray *)selectedIndexArray
{
    
}

//搜索按钮
- (void)selectedSingleVSearchButtonAction
{
    //重新搜索学校列表
    self.keyWord = self.bottomSelectedSingleView.searchTextField.text;
    [self getSchoolByCity];
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
    
    self.clearDateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearDateButton setTitle:@"清除条件" forState:UIControlStateNormal];
    [self.clearDateButton setTitleColor:ZTTextLightGrayColor forState:UIControlStateNormal];
    self.clearDateButton.titleLabel.font = FONT(28);
    self.clearDateButton.adjustsImageWhenHighlighted = NO;
    self.clearDateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.clearDateButton.tag = 1212;
    [self.clearDateButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearDateButton];
    
    [self.clearDateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(GTW(-28));
        make.centerY.equalTo(self.dateFilterLabel);
    }];
    
    UILabel *dateLineLabel = [[UILabel alloc] init];
    dateLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:dateLineLabel];
    
    [dateLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateFilterLabel);
        make.right.equalTo(self.clearDateButton);
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
        make.right.equalTo(self.clearDateButton);
    }];
    
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
    
    //范围筛选
    self.rangeFilterLabel = [[UILabel alloc] init];
    self.rangeFilterLabel.text = @"范围筛选";
    self.rangeFilterLabel.backgroundColor = ZTOrangeColor;
    self.rangeFilterLabel.textColor = [UIColor whiteColor];
    self.rangeFilterLabel.font = FONT(26);
    self.rangeFilterLabel.textAlignment = NSTextAlignmentCenter;
    self.rangeFilterLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(136), GTH(48))];
    [self.view addSubview:self.rangeFilterLabel];
    
    [self.rangeFilterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endPickerView.mas_bottom).offset(GTH(20));
        make.left.equalTo(self.view).offset(GTW(28));
        make.size.mas_equalTo(CGSizeMake(GTW(136), GTH(48)));
    }];
    
    self.clearRangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearRangButton setTitle:@"清除条件" forState:UIControlStateNormal];
    [self.clearRangButton setTitleColor:ZTTextLightGrayColor forState:UIControlStateNormal];
    self.clearRangButton.titleLabel.font = FONT(28);
    self.clearRangButton.tag = 2323;
    self.clearRangButton.adjustsImageWhenHighlighted = NO;
    self.clearRangButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.clearRangButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearRangButton];
    
    [self.clearRangButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(GTW(-28));
        make.centerY.equalTo(self.rangeFilterLabel);
    }];
    
    UILabel *rangLineLabel = [[UILabel alloc] init];
    rangLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:rangLineLabel];
    
    [rangLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(dateLineLabel);
        make.top.equalTo(self.rangeFilterLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.cityLabel = [[UILabel alloc] init];
    self.cityLabel.text = @"地区";
    self.cityLabel.font = FONT(30);
    self.cityLabel.textColor = ZTTextGrayColor;
    [self.view addSubview:self.cityLabel];
    
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.width.mas_equalTo(GTW(100));
        make.height.mas_equalTo(GTH(90));
        make.top.equalTo(rangLineLabel.mas_bottom);
    }];
    
    self.chooseCityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseCityButton setTitle:@"全部" forState:UIControlStateNormal];
    [self.chooseCityButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.chooseCityButton.titleLabel.font = FONT(30);
    self.chooseCityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.chooseCityButton.tag = 10001;
    self.chooseCityButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.chooseCityButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chooseCityButton];
    
    [self.chooseCityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(GTH(90));
        make.right.equalTo(rangLineLabel);
        make.left.equalTo(self.cityLabel.mas_right).offset(GTW(30));
        make.top.equalTo(rangLineLabel.mas_bottom);
    }];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downButton setImage:[UIImage imageNamed:@"bt-paixu"] forState:UIControlStateNormal];
    [self.view addSubview:self.downButton];
    
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(13), GTH(7)));
        make.right.equalTo(rangLineLabel.mas_right).offset(GTW(-13));
        make.centerY.equalTo(self.chooseCityButton);
    }];
    
    UILabel *cityLineLabel = [[UILabel alloc] init];
    cityLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:cityLineLabel];
    
    [cityLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.equalTo(dateLineLabel);
        make.top.equalTo(self.chooseCityButton.mas_bottom);
        make.left.equalTo(self.chooseCityButton);
    }];
    
    self.schoolLabel = [[UILabel alloc] init];
    self.schoolLabel.text = @"学校";
    self.schoolLabel.font = FONT(30);
    self.schoolLabel.textColor = ZTTextGrayColor;
    [self.view addSubview:self.schoolLabel];
    
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.cityLabel);
        make.top.equalTo(cityLineLabel.mas_bottom);
    }];
    
    self.chooseSchoolButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseSchoolButton setTitle:@"全部" forState:UIControlStateNormal];
    [self.chooseSchoolButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.chooseSchoolButton.titleLabel.font = FONT(30);
    self.chooseSchoolButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.chooseSchoolButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.chooseSchoolButton.tag = 10002;
    [self.chooseSchoolButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chooseSchoolButton];
    
    [self.chooseSchoolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.chooseCityButton);
        make.left.equalTo(self.schoolLabel.mas_right).offset(GTW(30));
        make.top.equalTo(cityLineLabel.mas_bottom);
    }];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downButton setImage:[UIImage imageNamed:@"bt-paixu"] forState:UIControlStateNormal];
    [self.view addSubview:self.downButton];
    
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(13), GTH(7)));
        make.right.equalTo(rangLineLabel.mas_right).offset(GTW(-13));
        make.centerY.equalTo(self.chooseSchoolButton);
    }];
    
    UILabel *schoolLineLabel = [[UILabel alloc] init];
    schoolLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:schoolLineLabel];
    
    [schoolLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.equalTo(dateLineLabel);
        make.top.equalTo(self.chooseSchoolButton.mas_bottom);
        make.left.equalTo(self.chooseSchoolButton);
    }];
    
    self.classLabel = [[UILabel alloc] init];
    self.classLabel.text = @"班级";
    self.classLabel.font = FONT(30);
    self.classLabel.textColor = ZTTextGrayColor;
    [self.view addSubview:self.classLabel];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.schoolLabel);
        make.top.equalTo(schoolLineLabel.mas_bottom);
    }];
    
    self.chooseClassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseClassButton setTitle:@"全部" forState:UIControlStateNormal];
    [self.chooseClassButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.chooseClassButton.titleLabel.font = FONT(30);
    self.chooseClassButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.chooseClassButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.chooseClassButton.tag = 10003;
    [self.chooseClassButton addTarget:self action:@selector(chooseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chooseClassButton];
    
    [self.chooseClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.chooseSchoolButton);
        make.left.equalTo(self.classLabel.mas_right).offset(GTW(30));
        make.top.equalTo(schoolLineLabel.mas_bottom);
    }];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downButton setImage:[UIImage imageNamed:@"bt-paixu"] forState:UIControlStateNormal];
    [self.view addSubview:self.downButton];
    
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(13), GTH(7)));
        make.right.equalTo(rangLineLabel.mas_right).offset(GTW(-13));
        make.centerY.equalTo(self.chooseClassButton);
    }];
    
    UILabel *classLineLabel = [[UILabel alloc] init];
    classLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:classLineLabel];
    
    [classLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.height.equalTo(dateLineLabel);
        make.top.equalTo(self.chooseClassButton.mas_bottom);
        make.left.equalTo(self.chooseClassButton);
    }];
    
}

#pragma mark - 时间筛选 && 范围筛选 清楚
- (void)clearButtonAction:(UIButton *)button
{
    if (button.tag == 1212) {
        self.startStr = @"";
        self.endStr = @"";
        [self.startPickerView setPickerToNone];
        [self.endPickerView setPickerToNone];
    }
    if (button.tag == 2323) {
        
        self.selectedProviceIndex = @"";
        self.selectedCityIndex = @"";
        self.selectedSchoolIndex = @"";
        self.selectedGradeIndex = @"";
        self.selectedClassIndex = @"";

        [self.chooseCityButton setTitle:@"全部" forState:UIControlStateNormal];
        [self.chooseSchoolButton setTitle:@"全部" forState:UIControlStateNormal];
        [self.chooseClassButton setTitle:@"全部" forState:UIControlStateNormal];
    }
}

#pragma mark - ZTPickerViewDelegate
- (void)selectedPickerView:(ZTPickerView *)pickerView WithContent:(NSString *)content
{
    //开始日期
    if (pickerView.tag == 22333) {
        self.startStr = content;
//        NSLog(@"开始日期 = %@", content);
    }
    //结束日期
    if (pickerView.tag == 33444) {
        self.endStr = content;
//        NSLog(@"结束日期 = %@", content);
    }
}

#pragma mark - 显示view
- (void)chooseButton:(UIButton *)button
{
    if (button.tag == 10001) { //选择地区
        self.bottomTableView.isCanChooseMore = NO;
        //获取省的名字列表
        NSMutableArray *array = [NSMutableArray array];
        for (ProvinceModel *model in self.provinceArray) {
            [array addObject:model.provinceName];
        }
        //获取城市的名字列表
        NSMutableArray *cityArray = [NSMutableArray array];
        for (NSArray *array in self.cityArray) {
            NSMutableArray *littleArray = [NSMutableArray array];
            for (CityModel *cityModel in array) {
                [littleArray addObject:cityModel.cityName];
            }
            [cityArray addObject:littleArray];
        }
        NSString *string = [NSString string];
        if (self.selectedProviceIndex.length != 0) {
            string = array[[self.selectedProviceIndex integerValue]];
        }
        [self.bottomTableView createBottomTableViewWithArray:[NSArray arrayWithObjects:array, cityArray, nil] ItemTitleArray:@[@"省", @"市"] Title:@"选择地区" SelectedStr:string];

        self.bottomTableView.hidden = NO;

    }
    if (button.tag == 10002) {//选择学校
        //判断是否选择了地区
        if (self.selectedProviceIndex.length == 0 || self.selectedCityIndex.length == 0) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"请先选择地区" Time:3.0];
            return;
        }
        self.bottomSelectedSingleView.isCanChooseMore = NO;
        self.bottomSelectedSingleView.isShowSearchTextField = YES;
        self.bottomSelectedSingleView.hidden = NO;
        //如果改变了地区, 刷新学校列表
        if (self.buttonClick == 10001) {
            [self getSchoolByCity];
            
        } else {
            //重新赋值
            NSString *string = [NSString string];
            if (self.selectedSchoolIndex.length != 0) {
                string = self.schoolNameArray[[self.selectedSchoolIndex integerValue]];
            }
            [self.bottomSelectedSingleView setBottomSelectedSingleViewWithArray:self.schoolNameArray Title:@"选择学校" SelectedStr:string];
        }

    }
    if (button.tag == 10003) {
        //判断是否选择了学校
        if (self.selectedSchoolIndex.length == 0) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"请先选择学校" Time:3.0];
            return;
        }
        self.bottomTableView.isCanChooseMore = NO;
        self.bottomTableView.hidden = NO;
        //如果改变了学校, 刷新班级
        if (self.buttonClick != 10003) {
            [self getClassBySchoold];
            
        } else {
            //重新赋值
            NSString *string = [NSString string];
            if (self.selectedGradeIndex.length != 0) {
                string = self.gradeArray[[self.selectedGradeIndex integerValue]];
            }
            //获取班级的列表
            NSMutableArray *classArray = [NSMutableArray array];
            for (NSArray *array in self.classArray) {
                NSMutableArray *littleArray = [NSMutableArray array];
                for (MyClassModel *cityModel in array) {
                    [littleArray addObject:cityModel.my_className];
                }
                [classArray addObject:littleArray];
            }
            
            [self.bottomTableView createBottomTableViewWithArray:[NSArray arrayWithObjects:self.gradeArray, classArray, nil] ItemTitleArray:@[@"年级", @"班级"] Title:@"选择班级" SelectedStr:string];
        }

    }
    //记录点击的按钮
    self.buttonClick = button.tag;
    

}




@end
