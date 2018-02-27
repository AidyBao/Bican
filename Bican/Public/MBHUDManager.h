//
//  MBHUDManager.h
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>
//static NSString *const kLoadingMessage = @"";
static CGFloat const   kShowTime  = 3.0;

@interface MBHUDManager : NSObject

/**
 *  是否显示变淡效果，默认为YES，  PS：只为 showPermanentAlert:(NSString *) alert 和 showLoading 方法添加
 */
//@property (nonatomic, assign) BOOL isShowGloomy;
/**
 *  显示“加载中”，待圈圈，若要修改直接修改kLoadingMessage的值即可
 */
+ (void)showLoading;
/**
 *  显示简短的提示语，默认2秒钟，时间可直接修改kShowTime
 *
 *  @param alert 提示信息
 */
+ (void)showBriefAlert:(NSString *) alert;
/**
 *  隐藏alert
 */
+(void)hideAlert;

@end
