//
//  AddClassViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AddClassViewController.h"
#import "AddClassTableViewCell.h"
#import "ZTBottomTableView.h"
#import "ZTBottomSelectedSingleView.h"

#import "ClassComplainViewController.h"
#import "MineTeacherViewController.h"

@interface AddClassViewController () <UITableViewDelegate, UITableViewDataSource, ZTBottomTableViewDelegate, ZTBottomSelectedSingleViewDelegate>

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) NSMutableArray *gradeArray;
@property (nonatomic, strong) NSMutableArray *schoolNameArray;
@property (nonatomic, strong) NSMutableArray *schoolIdArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *provinceArray;

@property (nonatomic, strong) NSString *selectedProviceIndex;//选中的省(下标)
@property (nonatomic, strong) NSString *selectedProviceContent;//选中的省

@property (nonatomic, strong) NSString *selectedCityIndex;//选中的城市(下标)
@property (nonatomic, strong) NSString *selectedCityContent;//选中的城市

@property (nonatomic, strong) NSString *selectedGradeIndex;//选中的年级(下标)
@property (nonatomic, strong) NSString *selectedGradeContent;//选中的年级

@property (nonatomic, strong) NSString *selectedClassIndex;//选中的班级(下标)
@property (nonatomic, strong) NSString *selectedClassContent;//选中的班级

@property (nonatomic, strong) NSString *selectedSchoolIndex;//选中的学校(下标)
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, assign) NSInteger buttonClick;//记录点击的按钮

@property (nonatomic, strong) ZTBottomTableView *bottomTableView;
@property (nonatomic, strong) ZTBottomSelectedSingleView *bottomSelectedSingleView;

//接收传来的值
@property (nonatomic, strong) NSMutableArray *selectedClassArray;
@property (nonatomic, strong) NSMutableArray *selectedClassIndexArray;
@property (nonatomic, strong) NSMutableArray *selectedClassIdArray;

@end

@implementation AddClassViewController

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

- (NSMutableArray *)selectedClassArray
{
    if (!_selectedClassArray) {
        _selectedClassArray = [NSMutableArray array];
    }
    return _selectedClassArray;
}

- (NSMutableArray *)selectedClassIndexArray
{
    if (!_selectedClassIndexArray) {
        _selectedClassIndexArray = [NSMutableArray array];
    }
    return _selectedClassIndexArray;
}

- (NSMutableArray *)selectedClassIdArray
{
    if (!_selectedClassIdArray) {
        _selectedClassIdArray = [NSMutableArray array];
    }
    return _selectedClassIdArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"加入班级";
    
    if (self.isPassButton) {
        [self createRightNavigationItem:nil Title:@"跳过此步" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:10];
    } else {
        [self createRightNavigationItem:nil Title:@"申诉" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:10];
    }
    
    [self createAddButton];
    [self createTableView];
    [self createBottomTableView];
    [self createBottomSelectedSingleView];

    
}


#pragma mark - 右按钮
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    if (self.isPassButton) {
        //跳过此步 (回到我的页面)
        for (UIViewController *VC in self.navigationController.viewControllers) {
            if ([VC isKindOfClass:[MineTeacherViewController class]]) {
                [self popToVC:VC animated:YES];
                return;
            }
        }
        MineTeacherViewController *mineVC = [[MineTeacherViewController alloc] init];
        [self pushVC:mineVC animated:YES IsNeedLogin:YES];

    } else {
        //申诉
        [self showAlert];
    }
    

}

#pragma mark - 申诉的提示框
- (void)showAlert
{
    UIAlertController *complaintAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"如任教的班级已有其他老师加入,您可以向我们提交班级申诉,我们会在72小时内核实情况,并反馈处理结果" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *goComplaintAction = [UIAlertAction actionWithTitle:@"去申诉" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        ClassComplainViewController *classComplainVC = [[ClassComplainViewController alloc] init];
        [self pushVC:classComplainVC animated:YES IsNeedLogin:YES];
        
        
    }];
    [goComplaintAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
    [complaintAlert addAction:goComplaintAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [cancelAction setValue:ZTTitleColor forKey:@"titleTextColor"];
    [complaintAlert addAction:cancelAction];
    [self presentViewController:complaintAlert animated:YES completion:nil];
    
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
    } else {
        cityId = [GetUserInfo getUserInfoModel].cityId;
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
    } else {
        schoolId = [GetUserInfo getUserInfoModel].schoolId;
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
        
//        NSString *string = [NSString string];
//        if (self.selectedGradeIndex.length != 0) {
//            string = self.gradeArray[[self.selectedGradeIndex integerValue]];
//        }
        //获取班级的列表
        NSMutableArray *classArray = [NSMutableArray array];
        NSMutableArray *classIdArray = [NSMutableArray array];
        for (NSArray *array in self.classArray) {
            NSMutableArray *littleArray = [NSMutableArray array];
            NSMutableArray *littleIdArray = [NSMutableArray array];
            for (MyClassModel *cityModel in array) {
                [littleArray addObject:cityModel.my_className];
                [littleIdArray addObject:cityModel.my_classId];
            }
            [classArray addObject:littleArray];
            [classIdArray addObject:littleIdArray];
        }
        self.bottomTableView.classIdArray = classIdArray;
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


#pragma mark - 创建单个item
- (void)createBottomSelectedSingleView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bottomSelectedSingleView = [[ZTBottomSelectedSingleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bottomSelectedSingleView.hidden = YES;
    self.bottomSelectedSingleView.isShowSearchTextField = NO;
    self.bottomSelectedSingleView.delegate = self;
    
    [window addSubview:self.bottomSelectedSingleView];
}

#pragma mark - ZTBottomSelectedSingleViewDelegate
- (void)singleViewSelectedCotent:(NSString *)selectedCount SelectedIndex:(NSInteger)selectedIndex
{
    //记录选择的班级的下标
    self.selectedSchoolIndex = [NSString stringWithFormat:@"%ld", selectedIndex];
    self.keyWord = self.bottomSelectedSingleView.searchTextField.text;
    self.selectedClassContent = selectedCount;
    
    [self reloadTableView:self.tableView Row:1 Section:0];
    [self reloadTableView:self.tableView Row:2 Section:0];
    
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

#pragma mark - 创建ZTBottomTableView
- (void)createBottomTableView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bottomTableView = [[ZTBottomTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bottomTableView.hidden = YES;
    self.bottomTableView.delegate = self;
    
    [window addSubview:self.bottomTableView];
    
    
}

#pragma mark - ZTBottomTableViewDelegate
- (void)sendSelectedGradeArray:(NSArray *)selectedGradeArray
       SelectedGradeIndexArray:(NSArray *)selectedGradeIndexArray
            SelectedClassArray:(NSArray *)selectedClassArray
       SelectedClassIndexArray:(NSArray *)selectedClassIndexArray
{
    [self.selectedClassArray removeAllObjects];
    [self.selectedClassArray addObjectsFromArray:selectedClassArray];

    [self.selectedClassIndexArray removeAllObjects];
    [self.selectedClassIndexArray addObjectsFromArray:selectedClassIndexArray];
    
    [self.selectedClassIdArray removeAllObjects];
    NSMutableArray *littleArray = [NSMutableArray array];
    //通过index获取id
    if (self.classArray.count != 0 && self.selectedClassIndexArray.count != 0) {
        for (int k = 0; k < selectedGradeIndexArray.count; k++) {
            [littleArray addObjectsFromArray:self.classArray[[selectedGradeIndexArray[k] integerValue]]];
        }
        for (int i = 0; i < littleArray.count; i++) {
            MyClassModel *myClassModel = [[MyClassModel alloc] init];
            myClassModel = (MyClassModel *)littleArray[i];

            for (int j = 0; j < self.selectedClassIndexArray.count; j++) {
                NSString *index = self.selectedClassIndexArray[j];
                if (i == [index integerValue]) {
                    MyClassModel *myClassModel = [[MyClassModel alloc] init];
                    myClassModel = (MyClassModel *)littleArray[[index integerValue]];
                    [self.selectedClassIdArray addObject:myClassModel.my_classId];
                }
            }
        }
    }
    //班级
    if (self.buttonClick == 2) {
        if (selectedGradeIndexArray.count == 0 || selectedGradeArray.count == 0) {
            return;
        }
        self.selectedGradeIndex = selectedGradeIndexArray[0];
        self.selectedGradeContent = selectedGradeArray[0];
        
        self.selectedClassIndex = [self.selectedClassIndexArray componentsJoinedByString:@","];
        self.selectedClassContent = [self.selectedClassArray componentsJoinedByString:@","];
        
        [self reloadTableView:self.tableView Row:2 Section:0];
    }
    
    if (self.selectedProviceIndex.length != 0 &&
        self.selectedCityIndex.length != 0 &&
        self.selectedSchoolIndex.length != 0 &&
        self.selectedGradeIndex.length != 0 &&
        self.selectedClassIndex.length != 0) {
    }

}

- (void)sendSelectedFirstItemIndex:(NSString *)selectedFirstItemIndex
          SelectedFirstItemContent:(NSString *)selectedFirstItemContent
           SelectedSecondItemIndex:(NSString *)selectedSecondItemIndex
         SelectedSecondItemContent:(NSString *)selectedSecondItemContent
{
    if (self.buttonClick == 0) {
        
        self.selectedProviceIndex = selectedFirstItemIndex;
        self.selectedProviceContent = selectedFirstItemContent;
        
        self.selectedCityIndex = selectedSecondItemIndex;
        self.selectedCityContent = selectedSecondItemContent;
        //清空原来的数据
        self.oldSchool = @"";
        self.selectedSchoolIndex = @"";
        self.selectedClassIndex = @"";
        self.selectedClassContent = @"";

    }
    if (self.buttonClick == 2) {
        self.selectedGradeIndex = selectedFirstItemIndex;
        self.selectedGradeContent = selectedFirstItemContent;

        self.selectedClassIndex = selectedSecondItemIndex;
        self.selectedClassContent = selectedSecondItemContent;

    }
    [self.tableView reloadData];

}



#pragma mark - 创建底部加入按钮
- (void)createAddButton
{
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitle:@"加入" forState:UIControlStateNormal];
    [self.addButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    [self.addButton setBackgroundColor:ZTOrangeColor];
    self.addButton.titleLabel.font = FONT(28);
    [self.addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(GTH(100));
    }];
    
}

#pragma mark - 完善班级信息班级按钮
- (void)addButtonAction
{
    if (self.oldProvinceCity.length == 0 && self.selectedProviceIndex.length == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请选择地区" Time:3.0];
        return;
    }
    if (self.oldSchool.length == 0 && self.selectedSchoolIndex.length == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请选择学校" Time:3.0];
        return;
    }
    if (self.selectedClassIdArray.count == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请选择班级" Time:3.0];
        return;
    }
    if (self.oldProvinceCity.length != 0 || self.oldSchool.length != 0) {
        [self showTipAlert];
        return;
    }
    [self completeClassInfo];
}

#pragma mark - 创建TableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = GTH(125);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.bottom.equalTo(self.view).offset(GTH(-100));
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"addClassCell";
    AddClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[AddClassTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        if (self.selectedProviceContent.length == 0 || self.selectedCityContent.length == 0) {
            if (self.oldProvinceCity.length != 0) {
                cell.titleLabel.textColor = ZTTitleColor;
                cell.titleLabel.text = self.oldProvinceCity;
            } else {
                cell.titleLabel.text = @"选择地区";
                cell.titleLabel.textColor = ZTTextLightGrayColor;
            }
            
        } else {
            cell.titleLabel.textColor = ZTTitleColor;
            cell.titleLabel.text = [NSString stringWithFormat:@"%@%@", self.selectedProviceContent, self.selectedCityContent];
        }
    }
    if (indexPath.row == 1) {
        if (self.selectedSchoolIndex.length == 0) {
            if (self.oldSchool.length != 0) {
                cell.titleLabel.textColor = ZTTitleColor;
                cell.titleLabel.text = self.oldSchool;
            } else {
                cell.titleLabel.text = @"选择学校";
                cell.titleLabel.textColor = ZTTextLightGrayColor;
            }
        } else {
            cell.titleLabel.textColor = ZTTitleColor;
            cell.titleLabel.text = self.schoolNameArray[[self.selectedSchoolIndex integerValue]];
        }
    }
    if (indexPath.row == 2) {
        if (self.selectedGradeContent.length == 0 || self.selectedClassContent.length == 0) {
            cell.titleLabel.text = @"选择班级";
            cell.titleLabel.textColor = ZTTextLightGrayColor;
        } else {
            cell.titleLabel.textColor = ZTTitleColor;
            cell.titleLabel.text = self.selectedClassContent;
        }
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //选择地区
    if (indexPath.row == 0) {
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
        NSString *stirng = [NSString string];
        if (self.selectedProviceIndex.length != 0) {
            stirng = array[[self.selectedProviceIndex integerValue]];
        }
        [self.bottomTableView createBottomTableViewWithArray:[NSArray arrayWithObjects:array, cityArray, nil] ItemTitleArray:@[@"省", @"市"] Title:@"选择地区" SelectedStr:stirng];
        
        self.bottomTableView.hidden = NO;
    }
    //选择学校
    if (indexPath.row == 1) {
        //判断是否选择了地区
        if (self.oldProvinceCity.length == 0) {
            if (self.selectedProviceIndex.length == 0 || self.selectedCityIndex.length == 0) {
                [ZTToastUtils showToastIsAtTop:NO Message:@"请先选择地区" Time:3.0];
                return;
            }
        }
        self.bottomSelectedSingleView.isCanChooseMore = NO;
        self.bottomSelectedSingleView.isShowSearchTextField = YES;
        self.bottomSelectedSingleView.hidden = NO;
        if (self.buttonClick == 0) {
            //如果改变了地区, 刷新学校列表
            [self getSchoolByCity];
            
        } else if (self.buttonClick == 2) {
            //如果改变了学校, 刷新班级
            [self getClassBySchoold];
            
        } else {
            //重新赋值
            NSString *stirng = [NSString string];
            if (self.selectedSchoolIndex.length != 0) {
                stirng = self.schoolNameArray[[self.selectedSchoolIndex integerValue]];
            }
            [self.bottomSelectedSingleView setBottomSelectedSingleViewWithArray:self.schoolNameArray Title:@"选择学校" SelectedStr:stirng];
        }
    }
    //选择班级
    if (indexPath.row == 2) {
        //判断是否选择了学校
        if (self.oldSchool.length == 0) {
            if (self.selectedSchoolIndex.length == 0) {
                [ZTToastUtils showToastIsAtTop:NO Message:@"请先选择学校" Time:3.0];
                return;
            }
        }
        [self getClassBySchoold];
        self.bottomTableView.isCanChooseMore = YES;
        self.bottomTableView.hidden = NO;
   
    }
    
    //记录选中的行
    self.buttonClick = indexPath.row;
    
}

#pragma mark - 提示信息
- (void)showTipAlert
{
    NSString *titleStr = @"提示";
    NSString *messageStr = @"切换地址或者学校会退出已加入的全部班级";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //这是按钮的背景颜色
    [cancelAction setValue:ZTTitleColor forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        //完善班级信息
        [self completeClassInfo];

    }];
    [sureAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 完善班级接口(加入班级)
- (void)completeClassInfo
{
    [self showLoading];
    
    UserInformation *user = [GetUserInfo getUserInfoModel];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:user.roleType forKey:@"roleType"];

    NSString *string = [self.selectedClassIdArray componentsJoinedByString:@","];
    [params setValue:string forKey:@"classIds"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/user/completeClassInfo", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        UserInformation *model = [[UserInformation alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [GetUserInfo updateUserinfoModelWithNewModel:model];
        //更新model
        [self popVCAnimated:YES];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

@end
