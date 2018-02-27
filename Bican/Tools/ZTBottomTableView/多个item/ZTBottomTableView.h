//
//  ZTBottomTableView.h
//  Bican
//
//  Created by 迟宸 on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZTBottomTableViewDelegate <NSObject>

- (void)sendSelectedGradeArray:(NSArray *)selectedGradeArray
       SelectedGradeIndexArray:(NSArray *)selectedGradeIndexArray
            SelectedClassArray:(NSArray *)selectedClassArray
       SelectedClassIndexArray:(NSArray *)selectedClassIndexArray;

//传值: 下标
- (void)sendSelectedFirstItemIndex:(NSString *)selectedFirstItemIndex
          SelectedFirstItemContent:(NSString *)selectedFirstItemContent
           SelectedSecondItemIndex:(NSString *)selectedSecondItemIndex
         SelectedSecondItemContent:(NSString *)selectedSecondItemContent;

@end

@interface ZTBottomTableView : BaseView

- (void)createBottomTableViewWithArray:(NSArray *)array ItemTitleArray:(NSArray *)itemTitleArray Title:(NSString *)title SelectedStr:(NSString *)selectedStr;

@property (nonatomic, assign) BOOL isCanChooseMore;//是否为多选的cell
@property (nonatomic, assign) BOOL isDoAppeal;//是否为申诉
@property (nonatomic, assign) id <ZTBottomTableViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *classIdArray;//班级id数组

@end
