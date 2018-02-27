//
//  UITextField+Extension.h
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)

//检测字符串是不是纯数字
- (BOOL)isNumber:(NSString *)num;

//检测字符串是不是纯数字或者小数点
- (BOOL)isNumberOrPoints:(NSString *)num;

//检测是否是手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum;

//检测字符串是否是数字或字母组成
- (BOOL)isNumberOrLetter:(NSString *)num;

//验证是否为空字符串
- (BOOL)isEmptyOrWhitespace:(NSString *)string;

//email
- (BOOL)validateEmail:(NSString *)email;

//phoneNumber
- (BOOL)validateMobile:(NSString *)mobile;

//用户名
- (BOOL)validateUserName:(NSString *)name;

//密码验证
- (BOOL)validatePassword:(NSString *)passWord;

@end
