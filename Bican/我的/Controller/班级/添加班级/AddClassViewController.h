//
//  AddClassViewController.h
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"

@interface AddClassViewController : ZTBaseViewController

@property (nonatomic, assign) BOOL isPassButton;//是否为跳过按钮, 否则是申诉按钮
@property (nonatomic, strong) NSString *oldProvinceCity;
@property (nonatomic, strong) NSString *oldSchool;

@end
