//
//  ZTBottomSelectedSingleView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBottomSelectedSingleView.h"
#import "ZTBottomView.h"

@interface ZTBottomSelectedSingleView () <ZTBottomViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *dataSourceArray;//数据源
@property (nonatomic, assign) NSInteger selectedIndex;//选中的数组
@property (nonatomic, strong) NSString *selectedStr;//选中的
@property (nonatomic, strong) ZTBottomView *bottomView;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *topTitleLabel;
@property (nonatomic, strong) UIButton *topSureButton;
@property (nonatomic, strong) UIButton *topCancelButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableArray *selectedIndexArray;

@end

@implementation ZTBottomSelectedSingleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedIndexArray = [NSMutableArray array];
        self.selectedArray = [NSMutableArray array];
        [self createSubViews];
    }
    return self;
}

- (void)setBottomSelectedSingleViewWithArray:(NSArray *)array
                                       Title:(NSString *)title
                                 SelectedStr:(NSString *)selectedStr
{
    for (UIView *view in self.centerView.subviews) {
        [view removeFromSuperview];
    }


    self.topTitleLabel.text = title;

    //创建ZTBottomView
    self.bottomView = [[ZTBottomView alloc] init];
    //有搜索框
    if (self.isShowSearchTextField) {
        self.searchView.hidden = NO;
        self.bottomView.frame = CGRectMake(0, GTH(100) + 1 + GTH(60), ScreenWidth, GTH(800) - GTH(100) - 1 - GTH(60));
    } else {
        self.searchView.hidden = YES;
        self.bottomView.frame = CGRectMake(0, GTH(100) + 1, ScreenWidth, GTH(800)  - GTH(100) - 1);
    }
    self.bottomView.delegate = self;
    //设置是否可以多选cell
    self.bottomView.isCanChooseMore = self.isCanChooseMore;
    //设置数组
    [self.bottomView setZTBottomViewWithArray:array OldSelectedStr:selectedStr];
    [self.centerView addSubview:self.bottomView];
    
    
}


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
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.topView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    self.searchView = [[UIView alloc] init];
    self.searchView.backgroundColor = ZTLineGrayColor;
    self.searchView.layer.cornerRadius = GTH(10);
    [self addSubview:self.searchView];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.right.equalTo(self.mas_right).offset(GTW(-30));
        make.top.equalTo(self.lineView.mas_bottom).offset(GTH(10));
        make.height.mas_equalTo(GTH(60));
    }];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    [self.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.searchView addSubview:self.searchButton];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.searchView.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.searchView);
        make.width.height.mas_equalTo(GTH(27));
    }];
    
    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField.backgroundColor = ZTLineGrayColor;
    self.searchTextField.placeholder = @"搜索";
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.delegate = self;
    [self.searchTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchTextField setValue:FONT(24) forKeyPath:@"_placeholderLabel.font"];
    self.searchTextField.textColor = ZTTitleColor;
    self.searchTextField.font = FONT(24);
    [self.searchView addSubview:self.searchTextField];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchView.mas_left).offset(GTW(30));
        make.right.equalTo(self.searchButton.mas_left).offset(GTW(-30));
        make.top.bottom.equalTo(self.searchView);
    }];

}

#pragma mark - 搜索按钮
- (void)searchButtonAction
{
    [self.searchTextField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(selectedSingleVSearchButtonAction)]) {
        [self.delegate selectedSingleVSearchButtonAction];
    }
}

#pragma mark - 隐藏视图
- (void)controlAction
{
    [self.searchTextField resignFirstResponder];
    [self setHidden:YES];
}

#pragma mark - 取消按钮
- (void)topCancelButtonAction
{
    [self.searchTextField resignFirstResponder];
    [self setHidden:YES];
}

#pragma mark - 确认按钮, 传值+隐藏视图
- (void)topSureButtonAction
{
    [self.searchTextField resignFirstResponder];
    
    if (!self.isCanChooseMore) {
        if ([self.delegate respondsToSelector:@selector(singleViewSelectedCotent:SelectedIndex:)]) {
            [self.delegate singleViewSelectedCotent:self.selectedStr SelectedIndex:self.selectedIndex];
            [self setHidden:YES];
        }

    } else {
        if ([self.delegate respondsToSelector:@selector(singleViewSelectedCotentArray:SelectedIndexArray:)]) {
            [self.delegate singleViewSelectedCotentArray:self.selectedArray SelectedIndexArray:self.selectedIndexArray];
            [self setHidden:YES];
        }
    }

}

#pragma mark - ZTBottomViewDelegate
- (void)currentView:(ZTBottomView *)view
      SelectedIndex:(NSInteger)selectedIndex
    SelectedContent:(NSString *)selectedContent
{
    self.selectedStr = selectedContent;
    self.selectedIndex = selectedIndex;
}

- (void)currentView:(ZTBottomView *)view
      SelectedArray:(NSArray *)selectedArray
 SelectedIndexArray:(NSArray *)selectedIndexArray
    SelectedContent:(NSString *)selectedContent
{
    [self.selectedArray removeAllObjects];
    [self.selectedArray addObject:selectedArray];
    
    [self.selectedIndexArray removeAllObjects];
    [self.selectedIndexArray addObject:selectedIndexArray];
    
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
