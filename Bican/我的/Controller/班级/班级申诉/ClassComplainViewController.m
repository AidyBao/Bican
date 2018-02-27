//
//  ClassComplainViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ClassComplainViewController.h"
#import "DetailsTableViewCell.h"
#import "ZTBottomTableView.h"
#import "ZTBottomSelectedSingleView.h"

@interface ClassComplainViewController ()<UITableViewDelegate, UITableViewDataSource, ZTBottomTableViewDelegate, ZTBottomSelectedSingleViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *placeholderArray;

@property (nonatomic, strong) UITextField *regionTextField;
@property (nonatomic, strong) UITextField *schoolTextField;
@property (nonatomic, strong) UITextField *classTextField;
@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) ZTBottomTableView *bottomTableView;
@property (nonatomic, strong) ZTBottomSelectedSingleView *bottomSelectedSingleView;

@property (nonatomic, strong) NSString *selectedProviceIndex;//选中的省(下标)
@property (nonatomic, strong) NSString *selectedProviceContent;//选中的省

@property (nonatomic, strong) NSString *selectedCityIndex;//选中的城市(下标)
@property (nonatomic, strong) NSString *selectedCityContent;//选中的城市

@property (nonatomic, strong) NSString *selectedGradeIndex;//选中的年级(下标)
@property (nonatomic, strong) NSString *selectedGradeContent;//选中的年级

@property (nonatomic, strong) NSString *selectedClassIndex;//选中的班级(下标)
@property (nonatomic, strong) NSString *selectedClassContent;//选中的班级

@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, assign) NSInteger buttonClick;//记录点击的按钮
@property (nonatomic, strong) NSString *selectedSchoolIndex;//选中的学校(下标)

@property (nonatomic, strong) NSMutableArray *classArray;
@property (nonatomic, strong) NSMutableArray *gradeArray;
@property (nonatomic, strong) NSMutableArray *schoolNameArray;
@property (nonatomic, strong) NSMutableArray *schoolIdArray;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) NSMutableArray *provinceArray;

//接收传来的值
@property (nonatomic, strong) NSMutableArray *selectedClassArray;
@property (nonatomic, strong) NSMutableArray *selectedClassIndexArray;
@property (nonatomic, strong) NSMutableArray *selectedClassIdArray;

@end

@implementation ClassComplainViewController

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


- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"地区", @"学校", @"班级", @"电话", nil];
    }
    return _titleArray;
}

- (NSMutableArray *)placeholderArray
{
    if (!_placeholderArray) {
        _placeholderArray = [NSMutableArray arrayWithObjects:@"请选择地区", @"请选择学校", @"请选择班级", @"请留下您的联系方式, 我们会及时处理", nil];
    }
    return _placeholderArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightNavigationItem:nil Title:@"提交" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:0];
    
    [self createTableView];
    [self createBottomTableView];
    [self createBottomSelectedSingleView];
    
}

#pragma mark - 提交申诉按钮
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    if ([NSString isEmptyOrWhitespace:self.regionTextField.text]) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请选择地区" Time:3.0];
        return;
    }
    if ([NSString isEmptyOrWhitespace:self.schoolTextField.text]) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请选择学校" Time:3.0];
        return;
    }
    if ([NSString isEmptyOrWhitespace:self.classTextField.text]) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请选择班级" Time:3.0];
        return;
    }
    if ([NSString isEmptyOrWhitespace:self.phoneTextField.text]) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请留下您的联系方式, 我们会及时处理" Time:3.0];
        return;
    }
    if (![NSString isValidatePhone:self.phoneTextField.text]) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请输入正确的电话" Time:3.0];
        return;
    }
    //提交申诉
    [self doAppeal];
    
}

#pragma mark - 申诉班级
- (void)doAppeal
{
    if (self.selectedClassIdArray.count == 0) {
        return;
    }
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.phoneTextField.text forKey:@"tel"];
    NSString *string = [self.selectedClassIdArray componentsJoinedByString:@","];
    [params setValue:string forKey:@"classIds"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/class/doAppeal", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            return;
        }
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
        self.bottomTableView.isDoAppeal = YES;
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
    if (selectedCount.length == 0) {
        return;
    }
    [self reloadTableView:self.tableView Row:1 Section:0];
    
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

        self.selectedGradeIndex = selectedGradeIndexArray[0];
        self.selectedGradeContent = selectedGradeArray[0];
        
        self.selectedClassIndex = [self.selectedClassIndexArray componentsJoinedByString:@","];
        self.selectedClassContent = [self.selectedClassArray componentsJoinedByString:@","];
        
        [self reloadTableView:self.tableView Row:2 Section:0];
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
        
        [self reloadTableView:self.tableView Row:0 Section:0];
    }
    if (self.buttonClick == 2) {
        self.selectedGradeIndex = selectedFirstItemIndex;
        self.selectedGradeContent = selectedFirstItemContent;
        
        self.selectedClassIndex = selectedSecondItemIndex;
        self.selectedClassContent = selectedSecondItemContent;
        
        [self reloadTableView:self.tableView Row:2 Section:0];
    }
}


- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.rowHeight = GTH(131);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *detailsCell = @"detailsCell";
    DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailsCell];
    if (!cell) {
        cell = [[DetailsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailsCell];
    }
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.nameLabel.text = self.titleArray[indexPath.row];
    cell.nameTextField.placeholder = self.placeholderArray[indexPath.row];
    UserInformation *user = [GetUserInfo getUserInfoModel];
    
    if (indexPath.row == 0) {
        //选择地区
        if (self.selectedProviceIndex.length == 0) {
            if (user.provinceId.length != 0) {
                NSString *province = [GetProvinceDataManager getProvinceNameWithProvinceId:user.provinceId];
                NSString *city = [GetProvinceDataManager getCityNameWithProvinceId:user.provinceId CityId:user.cityId];
                cell.nameTextField.text = [NSString stringWithFormat:@"%@%@", province, city];
                
            }
        } else {
            cell.nameTextField.textColor = ZTTitleColor;
            cell.nameTextField.text = [NSString stringWithFormat:@"%@%@", self.selectedProviceContent, self.selectedCityContent];
            
        }
        cell.nameTextField.enabled = false;
        self.regionTextField = cell.nameTextField;
    }
    //选择学校
    if (indexPath.row == 1) {
        if (self.selectedSchoolIndex.length == 0) {
            if (user.schoolName.length != 0) {
                cell.nameTextField.text = user.schoolName;
            }
        } else {
            cell.nameTextField.textColor = ZTTitleColor;
            cell.nameTextField.text = self.schoolNameArray[[self.selectedSchoolIndex integerValue]];
        }
        cell.nameTextField.enabled = false;
        self.schoolTextField = cell.nameTextField;
    }
    //选择班级
    if (indexPath.row == 2) {
        if (self.selectedGradeContent.length == 0 || self.selectedClassContent.length == 0) {
            cell.nameTextField.textColor = ZTTextLightGrayColor;
            cell.nameTextField.text = @"选择班级";
        } else {
            cell.nameTextField.textColor = ZTTitleColor;
            cell.nameTextField.text = self.selectedClassContent;
        }
        cell.nameTextField.enabled = false;
        self.classTextField = cell.nameTextField;
    }
    //俩系方式
    if (indexPath.row == 3) {
        if (user.mobile.length != 0) {
            cell.nameTextField.text = user.mobile;
        }
        self.phoneTextField = cell.nameTextField;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInformation *user = [GetUserInfo getUserInfoModel];

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
        if (user.provinceId.length == 0) {
            //判断是否选择了地区
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
        if (user.schoolName.length == 0) {
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




@end
