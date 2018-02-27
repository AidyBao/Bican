//
//  NSString+Extension.h
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)
/**
 *  判断字符串是否为空
 *
 *  @param string NSString
 *
 *  @return NSString
 */
+ (BOOL)isEmptyOrWhitespace:(NSString*)string;

+ (CGFloat)widthWithStr:(NSString *)str height:(CGFloat)height font:(UIFont *)font minWidth:(CGFloat)minWidth;

+ (CGFloat)heightWithStr:(NSString *)str width:(CGFloat)width font:(UIFont *)font minHeight:(CGFloat)minHeight;

+ (NSMutableAttributedString *)setStringColorLine:(NSString *)str inRange:(NSString *)rangstr withColor:(UIColor *)color;

+ (NSMutableAttributedString *)setStringFontColor:(NSString *)str  inRange:(NSString *)rangstr fontsize:(UIFont *)font  withColor:(UIColor *)color;

/**
 *  将日期字符串格式转换为日期格式
 *
 *  @param dateString dateString NSString
 *  @param formatter  NSDateFormatter
 *
 *  @return NSDate
 */
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter;

/**
 *  将当前日期转换为字符串格式
 *
 *  @param formatter  NSDateFormatter
 *
 *  @return  NSString
 */
+ (NSString *)stringFromNowWithFormatter:(NSString *)formatter;

/**
 *获取距离现在之前多少时间的时间字符串
 *
 * @param formatter  返回的时间字符串格式
 *
 * @param interval   距离现在多少秒
 *
 * @return  NSString
 */
+ (NSString *)stringFromNowWithFormatter:(NSString *)formatter interval:(NSTimeInterval)interval;

/**
 *  改变日期字符串的格式
 *
 *  @param dateString   日期字符串
 *  @param oriFormatter 原来的日期格式
 *  @param curFormatter 目标的日期格式
 *
 *  @return 改变格式后的日期字符串
 */
+ (NSString *)dateStringChangeFormatter:(NSString *)dateString oriFormatter:(NSString *)oriFormatter curFormatter:(NSString *)curFormatter;


/**
 获取指定距离指定开始时间多少秒的指定格式的时间字符串
 
 @param interval 间隔秒数
 @param dateString 开始时间字符串
 @param dateFormatter 指定时间格式
 @return 时间字符串
 */
+ (NSString *)dateWithTimeInterval:(NSTimeInterval)interval sinceDate:(NSString *)dateString dateFormatter:(NSString *)dateFormatter;

/**
 *  根据数字格式化样式获取字符串
 *
 *  @param numberFormatterStyle 数字格式化样式
 *  @param integerValue         参数
 *
 *  @return 数字格式化之后的字符串
 */
+ (NSString *)numberStringWithNumberFormatterStyle:(NSNumberFormatterStyle)numberFormatterStyle integerNum:(NSInteger)integerValue;

/**
 *  将日期字符串格式转换为日期格式
 *
 *  @param dateString NSString
 *
 *  @return NSDate
 */
+ (NSDate*)DateFromString:(NSString*)dateString;

/**
 *  将当前日期转换为字符串格式
 *
 *  @return  NSString
 */
+ (NSString*)stringFromNow;
+ (NSString *)stringFromNowNoTime;
+ (NSString *)stringFromNowOnlyCount;
/**
 *  获取当前年份, 月份 , 日
 *
 *  @return  NSString
 */
+ (NSString *)stringToNowYear;
+ (NSString *)stringToNowMonth;
+ (NSString *)stringToNowDay;

//获取当前年, 当前月的前几个月, 或者后几个月
+ (NSString *)stringToGetMonthSpaceWith:(NSInteger)space;

/**
 *  获取指定年月的, 每月天数
 *
 *  @return  NSInteger
 */
+ (NSInteger)getDaysInThisYear:(NSInteger)year Month:(NSInteger)month;

/**
 *  判断输入的是不是数字
 *
 
 */
+ (BOOL)checkInputIsNumber:(NSString *)string;

/**
 *  判断输入定投金额是否合法   只能输入正整数或者正浮点数
 *
 */
+ (BOOL)checkInvestFloatIsLegalWithString:(NSString *)floatValue;

/**
 *  判断输入的是不是邮件格式
 *  邮箱验证
 */
+ (BOOL)isValidateEmail:(NSString *)emailString;

/**
 *  判断输入的是不是电话号码
 *
 
 */
+ (BOOL)isValidatePhone:(NSString *)phoneString;

//检测字符串是否是数字或字母组成
+ (BOOL)isNumberOrLetter:(NSString *)num;

//判断是否为网址
+ (BOOL)isUrlString:(NSString *)string;

#pragma mark - 除了特殊符号, 可以输入中文, 英文, 数字
+ (BOOL)isInputRuleAndNumber:(NSString *)str;

/**
 *  身份证验证
 *
 *  @param identityCard identityCard description
 *
 *  @return return value description
 */
+ (BOOL)validateIdentityCard:(NSString *)identityCard;

/**
 *  中国邮政编码验证
 *
 *  @param postalcode 邮政编码
 *
 *  @return BOOL value
 */
+ (BOOL)validatePostalcode:(NSString *)postalcode;


/**
 通过16进制代码获取颜色
 
 @param hexColor 16进制代码 ex:"ffffff"
 @return 返回颜色实例
 */
+ (UIColor *)getColor:(NSString*)hexColor;

/**
 *  防止SQL注入
 *
 *  @param string 传入字符串
 *
 *  @return 正则表达式屏蔽掉SQL注入可能的字符串
 */
+ (NSString *)defenseSQL:(NSString *)string;

/*
 *  获取设备UUID
 */
+ (NSString *)getUUIDString;

#pragma mark - 获取浮点数的金额字符串 例如： 100,000.00 (千位符, 小数点)
+ (NSString *)stringToMoneyString:(NSString *)digitString;

#pragma mark - 获取整数的金额字符串  例如： 100,000
+ (NSString *)getIntegerMoneyString:(NSString *)string;

#pragma mark - 获取浮点数的金额字符串 例如： 100,000.00 (千位符, 截取小数点后两位)
+ (NSString *)getInterceptStringForTwo:(NSString *)string;


//当前日期获取weekday
+ (NSString *)weekdayStringFromDate:(NSDate *)inputDate;
// 20161128 - 2016-11-28
+ (NSString *)newStringDateFromString:(NSString *)string;
// 2016-11-28 - 20161128
+ (NSString *)newStringDateNoLineFromString:(NSString *)string;
//20161128 - 2016年11月28日
+ (NSString *)getYearAndMonthAndDayDateFromString:(NSString *)string;
//201611 - 2016年11月
+ (NSString *)getYearAndMonthDateFromString:(NSString *)string;
//201611 - 2016.11
+ (NSString *)getPointYearAndMonthDateFromString:(NSString *)string;
//201611 - 2016-11
+ (NSString *)getLineYearAndMonthDateFromString:(NSString *)string;
//20161128 ---11-28
+ (NSString *)getMonthDayWithLine:(NSString *)string;
//20161218152303 --- 2016-11-28(时间格式化)
+ (NSString *)getTimeFromString:(NSString *)string;
// 2016-11-28 13:23:23 --- 20161128
+ (NSString *)getStringFromTime:(NSString *)string;
// 2016-11-28 13:23 --- 20161128
+ (NSString *)getStringFromSecond:(NSString *)string;

//判断字符串是否为html字符串
+ (BOOL)isHtmlString:(NSString *)string;

//获取距离当前日期几个月, 几天, 几年的日期 (返回的格式: 截止到年, 或者月, 或者日)
/* DateReturn
 * all     : yyyyMMdd
 * toMonth : yyyyMM
 * year    : yyyy
 * month   : MM
 * day     : dd
 * nil     : yyyy-MM-dd
 */
+ (NSString *)getDateBeforOrAfterCurrentDateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day DateReturn:(NSString *)dateReturn;


//输入 日期字符串、日期格式 查询输入日期是星期几

/**
 查询当前日期是星期几
 
 @param dateString 日期字符串
 @param dateFormatter 日期格式字符串
 @return 星期几字符串
 */
+ (NSString *)weekdayStringFromDateString:(NSString *)dateString dateFormatter:(NSString *)dateFormatter;

//计算两个日期之间相隔多少天
+ (NSInteger)getDifferenceByStart:(NSString *)start End:(NSString *)end;
//计算两个日期之间相隔多少小时
+ (NSInteger)getTimesByStart:(NSString *)start End:(NSString *)end;

//返回去除空格的字符串
+ (NSString *)getNoWhiteSpaceString:(NSString *)string;


/**
 校验输入的字符串是否符合密码要求 (6-8位数字或字母)
 
 @param paswdString 密码字符串
 @return YES/NO
 */
+ (BOOL)validateStringIsPaswdString:(NSString *)paswdString;


//用身份证号码去获取当前客户年龄是否小于18岁
+ (BOOL)judgCurrentCustomerAgeIsLessThan18WithCertifino:(NSString *)certifino;

//字典转json格式字符串：
+ (NSString *)dictionaryToJson:(NSDictionary *)dic;

//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//动态获取云服务器上的ip地址
+ (NSString*)getIPWithHostName:(const NSString *)hostName;


@end
