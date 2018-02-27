//
//  ZiyouViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/30.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZiyouViewController.h"
#import "WJItemsControlView.h"
#import "ZiyouView.h"
#import "ZiyouTypeModel.h"
#import "FindListModel.h"

#import "FindDetailViewController.h"
#import "ZiyouFilterViewController.h"

@interface ZiyouViewController () <UIScrollViewDelegate, ZiyouViewDelegate, ZiyouFilterViewControllerDelegate>

@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) NSInteger selectedIndex;//选中的位置

@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) ZiyouView *ziyouView;
@property (nonatomic, strong) WJItemsControlView *itemControlView;
@property (nonatomic, strong) UIButton *writeButton;//写作文按钮

@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *selectedProvice;
@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedSchool;
@property (nonatomic, strong) NSString *selectedGrade;
@property (nonatomic, strong) NSString *selectedClass;

@property (nonatomic, strong) NSString *typeId;//类型id

@end

@implementation ZiyouViewController

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createRightNavigationItem:nil Title:@"筛选" RithtTitleColor:ZTOrangeColor BackgroundColor:nil CornerRadius:0];

    [self getZiyouTypeList];
    [self createTopView];
    [self createWriteButton];
    
}

#pragma mark - 筛选
-(void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    ZiyouFilterViewController *ziyouFilterVC = [[ZiyouFilterViewController alloc] init];
    ziyouFilterVC.bigTypeId = @"1";
    ziyouFilterVC.typeIdStr = self.typeId;
    ziyouFilterVC.delegate = self;
    [self pushVC:ziyouFilterVC animated:YES IsNeedLogin:NO];
    
}

#pragma mark - ZiyouFilterViewControllerDelegate
- (void)startDate:(NSString *)startDate
          EndDate:(NSString *)endDate
  SelectedProvice:(NSString *)selectedProvice
     SelectedCity:(NSString *)selectedCity
   SelectedSchool:(NSString *)selectedSchool
    SelectedGrade:(NSString *)selectedGrade
    SelectedClass:(NSString *)selectedClass
{
    
    self.startDate = startDate;
    self.endDate = endDate;
    self.selectedProvice = selectedProvice;
    self.selectedCity = selectedCity;
    self.selectedGrade = selectedGrade;
    self.selectedClass = selectedClass;
    self.selectedSchool = selectedSchool;
    
    [self createWJItemsControlView];
}


#pragma mark - 获取自由写栏目列表
- (void)getZiyouTypeList
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:@"" forKey:@"keyWords"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/articleType/list", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        [self.titleArray removeAllObjects];
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            ZiyouTypeModel *model = [[ZiyouTypeModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.titleArray addObject:model];
        }
        [self createWJItemsControlView];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 创建WJItemsControlView
- (void)createWJItemsControlView
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WJItemsControlView class]] || [view isKindOfClass:[ZiyouView class]]) {
            [view removeFromSuperview];
        }
    }
    CGFloat buttonHeight = GTH(76);
    CGFloat imageHeight = GTH(229);
    
    //创建顶部的scrollView
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    config.selectedColor = ZTOrangeColor;
    config.textColor = ZTTitleColor;
    if (self.titleArray.count > 4) {
        config.itemWidth = ScreenWidth / 4.5;
    } else {
        config.itemWidth = ScreenWidth / self.titleArray.count;
    }
    config.itemFont = FONT(26);
    if (config.itemWidth * self.titleArray.count < ScreenWidth) {
        config.linePercent = 0.3;
    }
    
    self.itemControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, self.backView.frame.origin.y, ScreenWidth, buttonHeight)];
    self.itemControlView.tapAnimation = YES;
    self.itemControlView.config = config;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.titleArray.count; i++) {
        ZiyouTypeModel *model = self.titleArray[i];
        [array addObject:model.name];
    }
    self.itemControlView.titleArray = array;
    
    __weak typeof(self)weakSelf = self;
    __weak typeof (_bigScrollView)weakScrollView = _bigScrollView;
    [self.itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        //点击重新获取
        _selectedIndex = index;
        [weakScrollView scrollRectToVisible:CGRectMake(index * weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width, weakScrollView.frame.size.height) animated:animation];
        if (weakSelf.titleArray.count != 0) {
            ZiyouTypeModel *model = weakSelf.titleArray[index];
            weakSelf.typeId = model.typeId;
        }
        
    }];
    [self.view addSubview:self.itemControlView];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(GTW(30), self.itemControlView.frame.size.height + self.itemControlView.frame.origin.y, ScreenWidth - GTW(30) * 2, 1)];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.lineView];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        ZiyouTypeModel *model = self.titleArray[i];
        //创建view
        self.ziyouView = [[ZiyouView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight - buttonHeight - NAV_HEIGHT)];
        self.ziyouView.delegate = self;
        self.ziyouView.ziyouVC = self;
        //传值
        self.ziyouView.typeId = model.typeId;
        self.ziyouView.typeName = model.name;
        self.ziyouView.startDate = self.startDate;
        self.ziyouView.endDate = self.endDate;
        self.ziyouView.proviceId = self.selectedProvice;
        self.ziyouView.cityId = self.selectedCity;
        self.ziyouView.gradeName = self.selectedGrade;
        self.ziyouView.classId = self.selectedClass;
        
        self.ziyouView.schoolId = self.selectedSchool;

        [self.bigScrollView addSubview:self.ziyouView];
    }
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth * self.titleArray.count, ScreenHeight - NAV_HEIGHT - buttonHeight - imageHeight);
    
}


#pragma mark - 创建头部
- (void)createTopView
{
    CGFloat buttonHeight = GTH(76);
    CGFloat imageHeight = GTH(229);

    self.topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ziyouxie_banner"]];
    self.topImageView.frame = CGRectMake(0, NAV_HEIGHT, ScreenWidth, imageHeight);
    [self.view addSubview:self.topImageView];

    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(0, self.topImageView.frame.size.height + self.topImageView.frame.origin.y, ScreenWidth, buttonHeight);
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];

    //底部内容的scrollView
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.backView.frame.origin.y + self.backView.frame.size.height, ScreenWidth, ScreenHeight - NAV_HEIGHT - buttonHeight - imageHeight)];
    self.bigScrollView.backgroundColor = [UIColor whiteColor];
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.bounces = NO;
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.delegate = self;
    [self.view addSubview:self.bigScrollView];

}

#pragma mark - 创建写文章按钮
- (void)createWriteButton
{
    CGFloat width = GTH(120);
    
    self.writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.writeButton.frame = CGRectMake(ScreenWidth - width - GTW(30), ScreenHeight - width - TABBAR_HEIGHT, width, width);
    [self.writeButton setImage:[UIImage imageNamed:@"suspension"] forState:UIControlStateNormal];
    self.writeButton.adjustsImageWhenHighlighted = NO;
    [self.writeButton addTarget:self action:@selector(gotoWriteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.writeButton];
    
    if ([[GetUserInfo getUserInfoModel].roleType isEqualToString:@"2"]) {
        //老师端 - 隐藏
        self.writeButton.hidden = YES;
    } else {
        //未登录 && 学生端 - 显示
        self.writeButton.hidden = NO;
    }
    [self.view bringSubviewToFront:self.writeButton];
    
}

#pragma mark - 写作文按钮
- (void)gotoWriteButtonAction
{
    //学生登录 - 写作文
    if ([[GetUserInfo getUserInfoModel].roleType isEqualToString:@"1"]) {
//        NSLog(@"写作文");
    }
    //未登录 - 跳转登录
    if ([GetUserInfo getUserInfoModel].roleType.length == 0) {
        [self pushToLoginVC];
    }

}

#pragma mark - 跳转到作文详情页面
- (void)pushToDetailVCWithArticleIdStr:(NSString *)articleIdStr IsRecommend:(NSString *)isRecommend
{
    FindDetailViewController *findDetailVC = [[FindDetailViewController alloc] init];
    findDetailVC.articleIdStr = articleIdStr;
    findDetailVC.isRecommend = isRecommend;
    [self pushVC:findDetailVC animated:YES IsNeedLogin:NO];
    
}

#pragma mark - 滚动之后
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView moveToIndex:offset];

}

#pragma mark - 拖拽之后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView endMoveToIndex:offset];
    
}



@end
