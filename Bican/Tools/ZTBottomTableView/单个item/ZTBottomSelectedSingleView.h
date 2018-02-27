//
//  ZTBottomSelectedSingleView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZTBottomSelectedSingleViewDelegate <NSObject>
//传值:(内容和下标)
- (void)singleViewSelectedCotent:(NSString *)selectedCount SelectedIndex:(NSInteger)selectedIndex;
//多选时, 传数组
- (void)singleViewSelectedCotentArray:(NSMutableArray *)selectedCotentArray
                   SelectedIndexArray:(NSMutableArray *)selectedIndexArray;


//搜索按钮
- (void)selectedSingleVSearchButtonAction;

@end

@interface ZTBottomSelectedSingleView : BaseView

- (void)setBottomSelectedSingleViewWithArray:(NSArray *)array Title:(NSString *)title SelectedStr:(NSString *)selectedStr;

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, assign) BOOL isShowSearchTextField;//是否显示搜索框
@property (nonatomic, assign) BOOL isCanChooseMore;//是否能多选
@property (nonatomic, assign) id <ZTBottomSelectedSingleViewDelegate> delegate;

@end
