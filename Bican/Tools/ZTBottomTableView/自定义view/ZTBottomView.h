//
//  ZTBottomView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTBottomView;
@protocol ZTBottomViewDelegate <NSObject>
//传值:选中的view  数组 内容
- (void)currentView:(ZTBottomView *)view
      SelectedArray:(NSArray *)selectedArray
 SelectedIndexArray:(NSArray *)selectedIndexArray
    SelectedContent:(NSString *)selectedContent;

- (void)currentView:(ZTBottomView *)view
      SelectedIndex:(NSInteger)selectedIndex
    SelectedContent:(NSString *)selectedContent;

@end

@interface ZTBottomView : BaseView

- (void)setZTBottomViewWithArray:(NSArray *)array OldSelectedStr:(NSString *)oldSelectedStr;

@property (nonatomic, assign) BOOL isCanChooseMore;//是否能多选
@property (nonatomic, assign) BOOL isDoAppeal;//是否为申诉
@property (nonatomic, assign) id <ZTBottomViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *classIdArray;

@end
