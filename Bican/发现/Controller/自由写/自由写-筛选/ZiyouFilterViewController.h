//
//  ZiyouFilterViewController.h
//  Bican
//
//  Created by 迟宸 on 2018/1/11.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"

@protocol ZiyouFilterViewControllerDelegate <NSObject>

- (void)startDate:(NSString *)startDate
          EndDate:(NSString *)endDate
  SelectedProvice:(NSString *)selectedProvice
     SelectedCity:(NSString *)selectedCity
   SelectedSchool:(NSString *)selectedSchool
    SelectedGrade:(NSString *)selectedGrade
    SelectedClass:(NSString *)selectedClass;

@end

@interface ZiyouFilterViewController : ZTBaseViewController
//传值时间选择器的选择范围
@property (nonatomic, strong) NSString *typeIdStr;//传值:类型的id
@property (nonatomic, strong) NSString *bigTypeId;//传值:自由写 || 命题作

@property (nonatomic, assign) id <ZiyouFilterViewControllerDelegate> delegate;

@end
