//
//  ZTBottomTableView.m
//  Bican
//
//  Created by 迟宸 on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTBottomTableView.h"
#import "WJItemsControlView.h"
#import "ZTBottomView.h"

@interface ZTBottomTableView () <UIScrollViewDelegate, ZTBottomViewDelegate>

@property (nonatomic, strong) WJItemsControlView *itemControlView;
@property (nonatomic, assign) NSInteger selectedIndex;//记录选中的位置
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) ZTBottomView *bottomView;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UIButton *topSureButton;
@property (nonatomic, strong) UIButton *topCancelButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSString *selectedGrade;//选中的年级
@property (nonatomic, strong) NSString *selectedGradeIndex;//选中的班级
@property (nonatomic, strong) NSMutableArray *selectedGradeArray;
@property (nonatomic, strong) NSMutableArray *selectedGradeIndexArray;

@property (nonatomic, strong) NSString *selectedClass;//选中的班级
@property (nonatomic, strong) NSString *selectedClassIndex;//选中的班级
@property (nonatomic, strong) NSMutableArray *selectedClassArray;
@property (nonatomic, strong) NSMutableArray *selectedClassIndexArray;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;//数组
@property (nonatomic, strong) NSMutableArray *itemArray;//数组

@end

@implementation ZTBottomTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSourceArray = [NSMutableArray array];
        self.itemArray = [NSMutableArray array];
        self.selectedClassArray = [NSMutableArray array];
        self.selectedClassIndexArray = [NSMutableArray array];
        self.selectedGradeArray = [NSMutableArray array];
        self.selectedGradeIndexArray = [NSMutableArray array];
        [self createSubViews];
    }
    return self;
}

#pragma mark - 有多个item
- (void)createBottomTableViewWithArray:(NSArray *)array ItemTitleArray:(NSArray *)itemTitleArray Title:(NSString *)title SelectedStr:(NSString *)selectedStr
{
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:array];
    
    [self.itemArray removeAllObjects];
    [self.itemArray addObjectsFromArray:itemTitleArray];
    
    for (UIView *view in self.centerView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat item_height = GTH(100);
    self.topTitleLabel.text = title;

    CGFloat scroll_height = GTH(800) - (GTH(100) * 2 + 1);
    //底部内容的scrollView
    self.bigScrollView = [[UIScrollView alloc] init];
    self.bigScrollView.frame = CGRectMake(0, GTH(100) * 2 + 1, ScreenWidth, scroll_height);
    self.bigScrollView.backgroundColor = [UIColor whiteColor];
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.bounces = NO;
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.delegate = self;
    //设置bigScrollView的contentSize
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth * itemTitleArray.count, scroll_height);
    [self.centerView addSubview:self.bigScrollView];

    //创建顶部的scrollView
    WJItemsConfig *config = [[WJItemsConfig alloc]init];
    config.selectedColor = ZTOrangeColor;
    config.textColor = ZTTitleColor;
    config.itemWidth = ScreenWidth / array.count;
    config.itemFont = FONT(26);
    config.linePercent = 0.3;
    
    self.itemControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, GTH(100), ScreenWidth, item_height)];
    self.itemControlView.tapAnimation = YES;
    self.itemControlView.config = config;
    self.itemControlView.backgroundColor = [UIColor whiteColor];
    self.itemControlView.titleArray = itemTitleArray;
    
    __weak typeof (_bigScrollView)weakScrollView = _bigScrollView;
    __weak typeof(self)weakSelf = self;
    [self.itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        _selectedIndex = index;
        [weakScrollView scrollRectToVisible:CGRectMake(index * weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width, weakScrollView.frame.size.height) animated:animation];
        weakSelf.selectedClassIndex = @"";
        weakSelf.selectedClass = @"";
        [weakSelf.selectedClassArray removeAllObjects];
        [weakSelf.selectedClassIndexArray removeAllObjects];
        
    }];
    [self.centerView addSubview:self.itemControlView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.centerView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.centerView);
        make.top.equalTo(self.itemControlView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    
    for (int i = 0; i < itemTitleArray.count; i++) {
        self.bottomView = [[ZTBottomView alloc] initWithFrame:CGRectMake(self.bigScrollView.frame.size.width * i, 0, self.bigScrollView.frame.size.width, self.bigScrollView.frame.size.height)];
        self.bottomView.tag = 10001 + i;
        self.bottomView.isCanChooseMore = self.isCanChooseMore;
        self.bottomView.delegate = self;
        //设置数组
        if (i == 0) {
            [self.bottomView setZTBottomViewWithArray:array[0] OldSelectedStr:selectedStr];
        }
        [self.bigScrollView addSubview:self.bottomView];
    }
    
}

#pragma mark - ZTBottomViewDelegate
- (void)currentView:(ZTBottomView *)view
      SelectedArray:(NSArray *)selectedArray
  SelectedIndexArray:(NSArray *)selectedIndexArray
    SelectedContent:(NSString *)selectedContent
{
    if (view.tag == 10001) {
        [self.selectedGradeArray removeAllObjects];
        [self.selectedGradeArray addObjectsFromArray:selectedArray];
        
        [self.selectedGradeIndexArray removeAllObjects];
        [self.selectedGradeIndexArray addObjectsFromArray:selectedIndexArray];
        
        self.selectedGrade = selectedContent;
        
    } else {
        [self.selectedClassArray removeAllObjects];
        [self.selectedClassArray addObjectsFromArray:selectedArray];
        
        [self.selectedClassIndexArray removeAllObjects];
        [self.selectedClassIndexArray addObjectsFromArray:selectedIndexArray];
        
        self.selectedClass = selectedContent;
    }

}

- (void)currentView:(ZTBottomView *)view
      SelectedIndex:(NSInteger)selectedIndex
    SelectedContent:(NSString *)selectedContent
{
    if (view.tag == 10001) {
        self.selectedGrade = selectedContent;
        self.selectedGradeIndex = [NSString stringWithFormat:@"%ld", selectedIndex];
    } else {
        self.selectedClass = selectedContent;
        self.selectedClassIndex = [NSString stringWithFormat:@"%ld", selectedIndex];
    }
}

#pragma mark - 创建页面
- (void)createSubViews
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.24;
    [self addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(ScreenHeight);
    }];
    
    self.centerView = [[UIView alloc] init];
    self.centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.centerView];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(GTH(800));
    }];
    
    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(self.centerView.mas_top);
    }];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(GTH(100));
        make.left.right.top.equalTo(self.centerView);
    }];
    
    self.topTitleLabel = [[UILabel alloc] init];
    self.topTitleLabel.font = FONT(30);
    self.topTitleLabel.textColor = ZTTextGrayColor;
    self.topTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.topTitleLabel];
    
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.bottom.equalTo(self.topView);
    }];
    
    self.topSureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topSureButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.topSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.topSureButton setBackgroundColor:ZTOrangeColor];
    self.topSureButton.titleLabel.font = FONT(28);
    self.topSureButton.layer.cornerRadius = GTH(20);
    
    [self.topSureButton addTarget:self action:@selector(topSureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.topSureButton];
    
    [self.topSureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.topView);
        make.size.mas_equalTo(CGSizeMake(GTW(80), GTH(60)));
    }];
    
    self.topCancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.topCancelButton setImage:[UIImage imageNamed:@"close_icon"] forState:UIControlStateNormal];
    [self.topCancelButton addTarget:self action:@selector(topCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.topCancelButton];
    
    [self.topCancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.centerY.equalTo(self.topView);
        make.size.mas_equalTo(CGSizeMake(GTW(80), GTH(60)));
    }];

    
    
}

#pragma mark - 滚动之后
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView moveToIndex:offset];
    
    if (self.selectedGrade.length == 0) {
        [self.bottomView.classIdArray removeAllObjects];
        [self.bottomView setZTBottomViewWithArray:[NSArray array] OldSelectedStr:@""];
        return;
    }
    self.selectedClassIndex = @"";
    self.selectedClass = @"";
    [self.selectedClassArray removeAllObjects];
    [self.selectedClassIndexArray removeAllObjects];
    //如果可以多选
    if (self.isCanChooseMore == YES) {
        NSArray *selectedGradeArray = [self.selectedGrade componentsSeparatedByString:@","];
        
        NSArray *array = self.dataSourceArray[0];
        NSMutableArray *allArray = [NSMutableArray array];
        NSMutableArray *classIdArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSString *grade = array[i];
            for (int j = 0; j < selectedGradeArray.count; j++) {
                if ([grade isEqualToString:selectedGradeArray[j]]) {
                    [allArray addObjectsFromArray:self.dataSourceArray[1][i]];
                    [classIdArray addObjectsFromArray:self.classIdArray[i]];
                }
            }
        }
        self.bottomView.isDoAppeal = self.isDoAppeal;
        self.bottomView.classIdArray = classIdArray;
        [self.bottomView setZTBottomViewWithArray:allArray OldSelectedStr:self.selectedClass];
        
    } else {
        
        NSArray *array = self.dataSourceArray[0];
        for (int i = 0; i < array.count; i++) {
            NSString *grade = array[i];
            if ([grade isEqualToString:self.selectedGrade]) {
                [self.bottomView setZTBottomViewWithArray:self.dataSourceArray[1][i] OldSelectedStr:self.selectedClass];
            }
        }
    }

}

#pragma mark - 拖拽之后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView moveToIndex:offset];
    
    if (self.selectedGrade.length == 0) {
        [self.bottomView.classIdArray removeAllObjects];
        [self.bottomView setZTBottomViewWithArray:[NSArray array] OldSelectedStr:@""];
        return;
    }
    self.selectedClassIndex = @"";
    self.selectedClass = @"";
    [self.selectedClassArray removeAllObjects];
    [self.selectedClassIndexArray removeAllObjects];
    
    //如果可以多选
    if (self.isCanChooseMore == YES) {
        NSArray *selectedGradeArray = [self.selectedGrade componentsSeparatedByString:@","];
        
        NSArray *array = self.dataSourceArray[0];
        NSMutableArray *allArray = [NSMutableArray array];
        NSMutableArray *classIdArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSString *grade = array[i];
            for (int j = 0; j < selectedGradeArray.count; j++) {
                if ([grade isEqualToString:selectedGradeArray[j]]) {
                    [allArray addObjectsFromArray:self.dataSourceArray[1][i]];
                    [classIdArray addObjectsFromArray:self.classIdArray[i]];
                }
            }
        }
        self.bottomView.isDoAppeal = self.isDoAppeal;
        self.bottomView.classIdArray = classIdArray;
        [self.bottomView setZTBottomViewWithArray:allArray OldSelectedStr:self.selectedClass];
        
    } else {
        
        NSArray *array = self.dataSourceArray[0];
        for (int i = 0; i < array.count; i++) {
            NSString *grade = array[i];
            if ([grade isEqualToString:self.selectedGrade]) {
                [self.bottomView setZTBottomViewWithArray:self.dataSourceArray[1][i] OldSelectedStr:self.selectedClass];
            }
        }
    }

}

#pragma mark - 隐藏视图
- (void)controlAction
{
    self.selectedGradeIndex = @"";
    self.selectedClassIndex = @"";
    self.selectedGrade = @"";
    self.selectedClass = @"";
    
    [self.selectedGradeArray removeAllObjects];
    [self.selectedClassArray removeAllObjects];
    [self.selectedGradeIndexArray removeAllObjects];
    [self.selectedClassIndexArray removeAllObjects];
    
    [self setHidden:YES];
}

#pragma mark - 取消按钮
- (void)topCancelButtonAction
{
    self.selectedGradeIndex = @"";
    self.selectedClassIndex = @"";
    self.selectedGrade = @"";
    self.selectedClass = @"";
    
    [self.selectedGradeArray removeAllObjects];
    [self.selectedClassArray removeAllObjects];
    [self.selectedGradeIndexArray removeAllObjects];
    [self.selectedClassIndexArray removeAllObjects];

    [self setHidden:YES];
}

#pragma mark - 确认按钮, 传值+隐藏视图
- (void)topSureButtonAction
{
    if (!self.isCanChooseMore) {
        if ([self.delegate respondsToSelector:@selector(sendSelectedFirstItemIndex:SelectedFirstItemContent:SelectedSecondItemIndex:SelectedSecondItemContent:)]) {
            
            NSString *string = [NSString string];
            if (self.selectedGrade.length == 0) {
                string = [NSString stringWithFormat:@"请选择%@", self.itemArray[0]];
                [ZTToastUtils showToastIsAtTop:NO Message:string Time:3.0];
                return;
            }
            if (self.selectedClass.length == 0) {
                string = [NSString stringWithFormat:@"请选择%@", self.itemArray[1]];
                [ZTToastUtils showToastIsAtTop:NO Message:string Time:3.0];
                return;
            }
            
            [self.delegate sendSelectedFirstItemIndex:self.selectedGradeIndex
                             SelectedFirstItemContent:self.selectedGrade
                              SelectedSecondItemIndex:self.selectedClassIndex
                            SelectedSecondItemContent:self.selectedClass];
            
            [self setHidden:YES];
        }
        
    } else {
        if ([self.delegate respondsToSelector:@selector(sendSelectedGradeArray:SelectedGradeIndexArray:SelectedClassArray:SelectedClassIndexArray:)]) {
            
            NSString *string = [NSString string];
            if (self.selectedGrade.length == 0) {
                string = [NSString stringWithFormat:@"请选择%@", self.itemArray[0]];
                [ZTToastUtils showToastIsAtTop:NO Message:string Time:3.0];
                return;
            }
            if (self.selectedClass.length == 0) {
                string = [NSString stringWithFormat:@"请选择%@", self.itemArray[1]];
                [ZTToastUtils showToastIsAtTop:NO Message:string Time:3.0];
                return;
            }
            
            [self.delegate sendSelectedGradeArray:(NSArray *)self.selectedGradeArray SelectedGradeIndexArray:(NSArray *)self.selectedGradeIndexArray SelectedClassArray:(NSArray *)self.selectedClassArray SelectedClassIndexArray:(NSArray *)self.selectedClassIndexArray];
            [self setHidden:YES];
        }
    }
    
    
}



@end
