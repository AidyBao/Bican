//
//  UIButton+Extension.h
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval 0.1  //默认时间间隔

@interface UIButton (Extension)

@property (nonatomic, assign) NSTimeInterval timeInterval;/**设置点击时间间隔*/
@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end
