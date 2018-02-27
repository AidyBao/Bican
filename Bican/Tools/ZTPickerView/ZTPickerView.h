//
//  ZTPickerView.h
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTPickerView;
@protocol ZTPickerViewDelegate <NSObject>

@optional
////返回选择的位置
//- (void)selectedWithIndex:(NSInteger)selectedIndex;
//返回选择的内容
- (void)selectedPickerView:(ZTPickerView *)pickerView WithContent:(NSString *)content;

@end

@interface ZTPickerView : BaseView

- (void)setPickerViewWithStartDate:(NSString *)startDate
                           EndDate:(NSString *)endDate
                             Title:(NSString *)title
                   ComponentsCount:(NSInteger)componentsCount;

- (void)setPickerToNone;

@property (nonatomic, assign) id <ZTPickerViewDelegate> delegate;

@end
