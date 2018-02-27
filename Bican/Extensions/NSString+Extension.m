//
//  NSString+Extension.m
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "NSString+Extension.h"
#include <netdb.h>
#include <sys/socket.h>
#include <arpa/inet.h>

@implementation NSString (Extension)

+ (BOOL)isEmptyOrWhitespace:(NSString*)string
{
    if((id)string == [NSNull null] || string == nil || string == NULL)
        return YES;
    
    if(!string)
        return YES;
    
    if(string.length <= 0)
        return YES;
    
    if([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length <= 0)
        return YES;
    
    return NO;
}

+(CGFloat)widthWithStr:(NSString *)str height:(CGFloat)height font:(UIFont *)font minWidth:(CGFloat)minWidth
{
//    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *titelAttributes = @{NSFontAttributeName:font};
    CGSize Size = CGSizeMake(0, height);
    CGSize size = [str boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:titelAttributes context:nil].size;
    CGFloat width = size.width;
    if (width < minWidth) {
        width = minWidth;
    }
//    NSLog(@"%lf",width);
    return width;
}

+ (CGFloat)heightWithStr:(NSString *)str width:(CGFloat)width font:(UIFont *)font minHeight:(CGFloat)minHeight
{
    
//    UIFont *font = [UIFont systemFontOfSize:fontSize];
    NSDictionary *titelAttributes = @{NSFontAttributeName:font};
    CGSize Size = CGSizeMake(width, CGFLOAT_MAX);
    CGSize size = [str boundingRectWithSize:Size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading |NSStringDrawingTruncatesLastVisibleLine attributes:titelAttributes context:nil].size;
    CGFloat height = size.height;
    if (height < minHeight) {
        height = minHeight;
    }
    return height;
}

+(NSMutableAttributedString *)setStringColorLine:(NSString *)str inRange:(NSString *)rangstr withColor:(UIColor *)color
{
    NSRange range=[str  rangeOfString:rangstr];
    NSMutableAttributedString *attriString=[[NSMutableAttributedString alloc]initWithString:str];
    
    [attriString setAttributes:@{NSForegroundColorAttributeName:color}
                         range:range];
    
    [attriString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
     
                        range:range];
    
    return attriString;
}

+ (NSMutableAttributedString *)setStringFontColor:(NSString *)str inRange:(NSString *)rangstr fontsize:(UIFont *)font withColor:(UIColor *)color
{
    NSRange range = [str rangeOfString:rangstr];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc]initWithString:str];
    [attriString setAttributes:@{NSForegroundColorAttributeName:color}
                         range:range];
    [attriString addAttribute:NSFontAttributeName
                        value:font
                        range:range];
    return attriString;
}

#pragma mark - 从字符串获取时间
+ (NSDate *)dateFromString:(NSString *)dateString formatter:(NSString *)formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *date = [[NSDate alloc] init];
    [dateFormatter setDateFormat:formatter];
    date = [dateFormatter dateFromString:dateString];
    return date;
}

#pragma mark - 获取当前时间的字符串
+ (NSString *)stringFromNowWithFormatter:(NSString *)formatter
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *dateString;
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

#pragma mark - 获取之前某个时间的日期字符串
+ (NSString *)stringFromNowWithFormatter:(NSString *)formatter interval:(NSTimeInterval)interval
{
    NSDate *targetDate = [NSDate dateWithTimeIntervalSinceNow:interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return [dateFormatter stringFromDate:targetDate];
}

#pragma mark - 改变日期字符串的格式
+ (NSString *)dateStringChangeFormatter:(NSString *)dateString oriFormatter:(NSString *)oriFormatter curFormatter:(NSString *)curFormatter
{
    if (dateString == nil ||dateString.length < 1) {
        return @"--";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:oriFormatter];
    NSDate *date = [formatter dateFromString:dateString];
    //转变日期格式
    NSDateFormatter *secondFormatter = [[NSDateFormatter alloc] init];
    [secondFormatter setDateFormat:curFormatter];
    return [secondFormatter stringFromDate:date];
}

#pragma mark -  获取指定距离指定开始时间多少秒的指定格式的时间字符串
+ (NSString *)dateWithTimeInterval:(NSTimeInterval)interval sinceDate:(NSString *)dateString dateFormatter:(NSString *)dateFormatter
{
    if (dateString == nil ||dateString.length < 1 || [dateString isEqualToString:@"--"]) {
        return @"--";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatter];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSDate *sinceDate = [formatter dateFromString:dateString];
    NSDate *targetDate = [NSDate dateWithTimeInterval:interval sinceDate:sinceDate];
    return [formatter stringFromDate:targetDate];
}

#pragma mark - 数字格式化之后的字符串
+ (NSString *)numberStringWithNumberFormatterStyle:(NSNumberFormatterStyle)numberFormatterStyle integerNum:(NSInteger)integerValue
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = numberFormatterStyle;
    return [numberFormatter stringFromNumber:[NSNumber numberWithInteger:integerValue]];
}

//获取距离当前日期几个月, 几天, 几年的日期
+ (NSString *)getDateBeforOrAfterCurrentDateWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day DateReturn:(NSString *)dateReturn
{
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if ([dateReturn isEqualToString:@"year"]) {
        [dateFormatter setDateFormat:@"yyyy"];
        
    } else if ([dateReturn isEqualToString:@"month"]) {
        [dateFormatter setDateFormat:@"MM"];
        
    } else if ([dateReturn isEqualToString:@"day"]) {
        [dateFormatter setDateFormat:@"dd"];
        
    } else if ([dateReturn isEqualToString:@"toMonth"]) {
        [dateFormatter setDateFormat:@"yyyyMM"];
        
    } else if ([dateReturn isEqualToString:@"all"]) {
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = nil;
    comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:currentDate];
    
    NSDateComponents *adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:year];
    [adcomps setMonth:month];
    [adcomps setDay:day];
    
    NSDate *newDate = [calendar dateByAddingComponents:adcomps toDate:currentDate options:0];
    NSString *newdateStr = [dateFormatter stringFromDate:newDate];
    
    return newdateStr;
    
}

+ (NSDate *)DateFromString:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date;
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    date = [formatter dateFromString:dateString];
    
    return date;
}

+ (NSString *)stringFromNow
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateString;
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateString = [formatter stringFromDate:date];
    
    return dateString;
}

+ (NSString *)stringFromNowNoTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateString;
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    dateString = [formatter stringFromDate:date];
    
    return dateString;
}

//获取当前年月日, 时分秒
+ (NSString *)stringFromNowOnlyCount
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateString;
    
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    dateString = [formatter stringFromDate:date];
    
    return dateString;
}

//获取当前年份
+ (NSString *)stringToNowYear
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitYear fromDate:now];
    NSInteger year = [dateComponent year];
    
    return [NSString stringWithFormat:@"%ld", (long)year];
}

//获取当前月份
+ (NSString *)stringToNowMonth
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitMonth fromDate:now];
    NSInteger month = [dateComponent month];
    if (month >= 10) {
        return [NSString stringWithFormat:@"%ld", (long)month];
    } else {
        return [NSString stringWithFormat:@"0%ld", (long)month];
    }
}

//获取当前日
+ (NSString *)stringToNowDay
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:NSCalendarUnitDay fromDate:now];
    NSInteger day = [dateComponent day];
    if (day >= 10) {
        return [NSString stringWithFormat:@"%ld", (long)day];
    } else {
        return [NSString stringWithFormat:@"0%ld", (long)day];
    }
}

//获取当前年, 当前月的前几个月, 或者后几个月
+ (NSString *)stringToGetMonthSpaceWith:(NSInteger)space
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMM"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *lastMonthComps = [[NSDateComponents alloc] init];
    [lastMonthComps setMonth:space];
    NSDate *newdate = [calendar dateByAddingComponents:lastMonthComps toDate:currentDate options:0];
    NSString *dateStr = [formatter stringFromDate:newdate];
    
    return dateStr;
}

//获取指定年,指定月的,每月天数
+ (NSInteger)getDaysInThisYear:(NSInteger)year Month:(NSInteger)month
{
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12)) {
        
        return 31;
    }
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11)) {
        
        return 30;
    }
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3)) {
        
        return 28;
    }
    
    if(year % 400 == 0) {
        
        return 29;
    }
    
    if(year % 100 == 0) {
        
        return 28;
    }
    
    return 29;
}

+ (BOOL)checkInputIsNumber:(NSString *)string
{
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - 判断输入定投金额是否合法   只能输入正整数或者正浮点数
+ (BOOL)checkInvestFloatIsLegalWithString:(NSString *)floatValue
{
    
    NSString *valueRegex = @"^[1-9]\\d*\\.\\d*|0\\.\\d*[1-9]\\d*$";
    NSPredicate *valueTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", valueRegex];
    BOOL isLegal = [valueTest evaluateWithObject:floatValue];
    
    NSString *valueRegex2nd = @"^[1-9]\\d*$";
    NSPredicate *valueTest2nd = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", valueRegex2nd];
    BOOL isLegal2nd = [valueTest2nd evaluateWithObject:floatValue];
    
    return isLegal||isLegal2nd;
}

#pragma mark - 验证邮箱
+ (BOOL)isValidateEmail:(NSString *)emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmail = [emailTest evaluateWithObject:emailString];
    return isEmail;
}

#pragma mark - 验证手机号码
+ (BOOL)isValidatePhone:(NSString *)phoneString
{
    if ([self isEmptyOrWhitespace:phoneString]) {
        return NO;
    }
    NSString *phoneRegex = @"^[1][3,4,5,7,8][0-9]{9}$";
//    NSString * phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL isMatch = [pred evaluateWithObject:phoneString];
    return isMatch;
}

//检测字符串是否是数字或字母组成
+ (BOOL)isNumberOrLetter:(NSString *)num
{
    NSString *numberOrLetter = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:numberOrLetter] invertedSet];
    NSString *filtered = [[num componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [num isEqualToString:filtered];
    return basic;
}

//判断是否为网址
+ (BOOL)isUrlString:(NSString *)string
{
    NSString *emailRegex = @"[a-zA-z]+://.*";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
    
}

#pragma mark - 除了特殊符号, 可以输入中文, 英文, 数字
/**
 pattern中,输入需要验证的通过的字符
 小写a-z
 大写A-Z
 汉字\u4E00-\u9FA5
 数字\u0030-\u0039
 @param str 要过滤的字符
 @return YES 只允许输入字母和汉字
 */
+ (BOOL)isInputRuleAndNumber:(NSString *)str
{
    NSString *pattern = @"^(([\u4e00-\u9fa5]{2,8})|([a-zA-Z]{2,16}))$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:str];
    return isMatch;
}


//字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
////身份证号
//+ (BOOL) validateIdentityCard: (NSString *)identityCard
//{
//
//    identityCard = [identityCard stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if ([identityCard length] != 18) {
//        return NO;
//    }
//    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
//    NSString *leapMmdd = @"0229";
//    NSString *year = @"(19|20)[0-9]{2}";
//    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
//    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
//    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
//    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
//    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
//    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
//    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if (![regexTest evaluateWithObject:identityCard]) {
//        return NO;
//    }
//    return YES;
//}


+ (BOOL)validateIdentityCard:(NSString *)identityString
{
    
    if (identityString.length == 15) {
        // 加权因子
        int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
        // 校验码
        unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
        // 将15位身份证号转换成18位
        NSMutableString *mString = [NSMutableString stringWithString:identityString];
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        const char *pid = [mString UTF8String];
        for (int i=0; i<=16; i++)
        {
            p += (pid[i]-48) * R[i];
        }
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        //            carid = mString;
        identityString = mString;
    }
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return YES;
        }else {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL)validatePostalcode:(NSString *)postalcode
{
    NSString *postalcodeRegex = @"^[1-9]\\d{5}(?!\\d)$";
    NSPredicate *postalcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",postalcodeRegex];
    return [postalcodeTest evaluateWithObject:postalcode];
}

/**
 *  防止SQL注入
 *
 *  @param string 传入字符串
 *
 *  @return 正则表达式屏蔽掉SQL注入可能的字符串
 */
+ (NSString *)defenseSQL:(NSString *)string
{
    NSString * regExpStr = @"(?:')|(?:--)|\\*|=|\\s|%|(/\\*(?:.|[\\n\\r])*?\\*/)|(\\b(SELECT|UPDATE|AND|OR|DELETE|INSERT|TRANCATE|CHAR|INTO|SUBSTR|ASCII|DECLARE|EXEC|COUNT|MASTER|INTO|DROP|EXECUTE)\\b)";
    NSString * replacement = @"";
    // 创建 NSRegularExpression 对象,匹配 正则表达式
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive|NSRegularExpressionAnchorsMatchLines|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSString *resultStr = string;
    // 替换匹配的字符串为 searchStr
    resultStr = [regExp stringByReplacingMatchesInString:string
                                                 options:NSMatchingReportCompletion
                                                   range:NSMakeRange(0, string.length)
                                            withTemplate:replacement];
    return resultStr;
}

+ (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

//获取设备UUID
+ (NSString *)getUUIDString
{
    return [[UIDevice currentDevice].identifierForVendor UUIDString];
}

#pragma mark - 获取浮点数的金额字符串 例如： 100,000.00 (千位符, 小数点)
/* !! 没有保留原来的"+"
 * .4444    ->  0.44
 *    0.    ->  0.00
 * 4234     ->  4,234
 * -44899.3 ->  -44,899.30
 * +9.99    ->  9.99
 */
+ (NSString *)stringToMoneyString:(NSString *)digitString
{
    if (digitString.length == 0) {
        return @"--";
    }
    double string = digitString.doubleValue;
    digitString = [NSString stringWithFormat:@"%.2f",string];
    
    //    int minus = 0;
    //    if (string < 0) {
    //        minus = -1;
    //        string = minus * string;
    //    }
    
    if ((digitString.length <= 5 && string > 0) || (digitString.length <= 7 && string < 0)) {
        return digitString;
        
    }else if (string == 0) {
        return [NSString stringWithFormat:@"0.00"];
    }else {
        NSString *xiaoshuString = [digitString substringFromIndex:digitString.length - 3];
        NSString *fengeString = [digitString substringToIndex:digitString.length - 3];
        NSMutableString *processString = [NSMutableString stringWithString:fengeString];
        NSInteger location = processString.length - 3;
        NSMutableArray *processArray = [NSMutableArray array];
        
        while (location >= 0) {
            NSString *temp = [processString substringWithRange:NSMakeRange(location, 3)];
            [processArray addObject:temp];
            
            if (location < 3 && location > 0) {
                NSString *t = [processString substringWithRange:NSMakeRange(0, location)];
                [processArray addObject:t];
            }
            location -= 3;
        }
        
        NSMutableArray *resultsArray = [NSMutableArray array];
        int k = 0;
        for (NSString *str in processArray) {
            k++;
            NSMutableString *tmp = [NSMutableString stringWithString:str];
            if (str.length > 2 && k < processArray.count) {
                [tmp insertString:@"," atIndex:0];
                [resultsArray addObject:tmp];
                
            } else {
                [resultsArray addObject:tmp];
            }
        }
        
        NSMutableString *resultString = [NSMutableString string];
        for (NSInteger i = resultsArray.count - 1 ; i >= 0; i--) {
            NSString *tmp = [resultsArray objectAtIndex:i];
            [resultString appendString:tmp];
            
        }
        [resultString appendString:xiaoshuString];
        //        if (minus == -1) {
        //            resultString = [NSMutableString stringWithFormat:@"-%@",resultString];
        //        }
        return resultString;
    }
    //    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    //    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    //    double money = [string doubleValue];
    //    NSNumber * moneyNumber = [NSNumber numberWithDouble:money];
    //    NSString *newAmount = [formatter stringFromNumber:moneyNumber];
    //    return [[[newAmount stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@"￥" withString:@""] stringByReplacingOccurrencesOfString:@"US" withString:@""];
    
}

#pragma mark - 获取整数的金额字符串  例如： 100,000
/* !! 没有保留原来的"+"
 * .4444    ->  0
 *    0.    ->  0
 * 4234     ->  4,234
 * -44899.3 ->  -44,899
 * +9.99    ->  9
 */
+ (NSString *)getIntegerMoneyString:(NSString *)string
{
    if (string.length == 0) {
        return @"--";
    }
    double doubleString = string.doubleValue;
    string = [NSString stringWithFormat:@"%.2f",doubleString];
    
    if (![string containsString:@"."]) {
        
        return string;
        
    } else {
        
        NSString *fengeString = [string substringToIndex:string.length - 3];
        NSMutableString *processString = [NSMutableString stringWithString:fengeString];
        NSInteger location = processString.length - 3;
        NSMutableArray *processArray = [NSMutableArray array];
        
        if (location < 0) {
            
            return [NSString stringWithFormat:@"%ld", (long)[string integerValue]];
        }
        
        while (location >= 0) {
            NSString *temp = [processString substringWithRange:NSMakeRange(location, 3)];
            [processArray addObject:temp];
            
            if (location < 3 && location > 0) {
                NSString *t = [processString substringWithRange:NSMakeRange(0, location)];
                [processArray addObject:t];
            }
            location -= 3;
        }
        
        NSMutableArray *resultsArray = [NSMutableArray array];
        int k = 0;
        for (NSString *str in processArray) {
            k++;
            NSMutableString *tmp = [NSMutableString stringWithString:str];
            if (str.length > 2 && k < processArray.count) {
                [tmp insertString:@"," atIndex:0];
                [resultsArray addObject:tmp];
                
            } else {
                [resultsArray addObject:tmp];
            }
        }
        
        NSMutableString *resultString = [NSMutableString string];
        for (NSInteger i = resultsArray.count - 1 ; i >= 0; i--) {
            NSString *tmp = [resultsArray objectAtIndex:i];
            [resultString appendString:tmp];
            
        }
        return resultString;
    }
    
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
//    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
//    NSInteger money = [string integerValue];
//    NSNumber * moneyNumber = [NSNumber numberWithInteger:money];
//    NSString *newAmount = [formatter stringFromNumber:moneyNumber];
//    return [[[[newAmount stringByReplacingOccurrencesOfString:@"$" withString:@""] stringByReplacingOccurrencesOfString:@"￥" withString:@""] stringByReplacingOccurrencesOfString:@"US" withString:@""] stringByReplacingOccurrencesOfString:@".00" withString:@""];
    
}

+ (NSString *)weekdayStringFromDate:(NSDate*)inputDate
{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null],@"(周日)",@"(周一)", @"(周二)", @"(周三)", @"(周四)", @"(周五)",@"(周六)",nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

+ (NSString *)newStringDateFromString:(NSString *)string
{
    if (string.length == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date;
    [formatter setDateFormat:@"yyyyMMdd"];
    date = [formatter dateFromString:string];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *newStrDate = [formatter stringFromDate:date];
    return newStrDate;
}

+ (NSString *)newStringDateNoLineFromString:(NSString *)string
{
    if (string.length == 0) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    date = [formatter dateFromString:string];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *newStrDate = [formatter stringFromDate:date];
    return newStrDate;
}

+ (NSString *)getYearAndMonthAndDayDateFromString:(NSString *)string
{
    if (string.length < 6) {
        return string;
    }
    NSString *year = [string substringWithRange:NSMakeRange(0, 4)];

    NSString *month = [string substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [string substringWithRange:NSMakeRange(string.length - 2, 2)];
    NSString *newString = [NSString stringWithFormat:@"%@年%@月%@日", year, month, day];
    return newString;
}

+ (NSString *)getYearAndMonthDateFromString:(NSString *)string
{
    if (string.length < 6) {
        return string;
    }
    NSString *year = [string substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [string substringWithRange:NSMakeRange(4, 2)];
    NSString *newString = [NSString stringWithFormat:@"%@年%@月", year, month];
    
    return newString;
}

+ (NSString *)getPointYearAndMonthDateFromString:(NSString *)string
{
    if (string.length < 6) {
        return string;
    }
    NSString *year = [string substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [string substringWithRange:NSMakeRange(4, 2)];
    NSString *newString = [NSString stringWithFormat:@"%@.%@", year, month];
    
    return newString;
}

+ (NSString *)getLineYearAndMonthDateFromString:(NSString *)string
{
    if (string.length < 6) {
        return string;
    }
    NSString *year = [string substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [string substringWithRange:NSMakeRange(4, 2)];
    NSString *newString = [NSString stringWithFormat:@"%@-%@", year, month];
    
    return newString;
}

+ (NSString *)getMonthDayWithLine:(NSString *)string
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateString;
    
    [formatter setDateFormat:@"yyyyMMdd"];
    dateString = [formatter stringFromDate:date];
    NSString *currentYear = [dateString substringWithRange:NSMakeRange(0, 4)];
    
    NSString *year = [string substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [string substringWithRange:NSMakeRange(string.length - 4, 2)];
    NSString *day = [string substringWithRange:NSMakeRange(string.length - 2, 2)];
    NSString *m = [month integerValue] < 10 ? [NSString stringWithFormat:@"0%ld",(long)[month integerValue]] : month;
    NSString *d = [day integerValue] < 10 ? [NSString stringWithFormat:@"0%ld",(long)[day integerValue]] : day;
    if ([year integerValue] == [currentYear integerValue]) {
        NSString *newString = [NSString stringWithFormat:@"%@-%@",m,d];
        return newString;
    }else {
        NSString *newyear = [string substringWithRange:NSMakeRange(2, 2)];
        NSString *y = [newyear integerValue] < 10 ? [NSString stringWithFormat:@"0%ld",(long)[newyear integerValue]] : newyear;
        NSString *newString = [NSString stringWithFormat:@"%@-%@-%@",y,m,d];
        return newString;
    }
    
}

+ (NSString *)getTimeFromString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date;
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    date = [formatter dateFromString:string];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *newStrDate = [formatter stringFromDate:date];
    return newStrDate;
}

+ (NSString *)getStringFromTime:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    date = [formatter dateFromString:string];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *newStrDate = [formatter stringFromDate:date];
    return newStrDate;
}

+ (NSString *)getStringFromSecond:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    date = [formatter dateFromString:string];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *newStrDate = [formatter stringFromDate:date];
    return newStrDate;
}

//输入 日期字符串、日期格式 查询输入日期是星期几
+ (NSString *)weekdayStringFromDateString:(NSString *)dateString dateFormatter:(NSString *)dateFormatter
{
    if (dateString == nil ||dateString.length < 1 || [dateString isEqualToString:@"--"]) {
        return @"--";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormatter];
    NSDate *date = [formatter dateFromString:dateString];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null],@"周日",@"周一", @"周二", @"周三", @"周四", @"周五",@"周六",nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)getNoWhiteSpaceString:(NSString *)string
{
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}

//判断字符串是否为html字符串
+ (BOOL)isHtmlString:(NSString *)string
{
    if ([string containsString:@"<p>"]) {
        return YES;
    }
    if ([string containsString:@"</p>"]) {
        return YES;
    }
    if ([string containsString:@"&nbsp"]) {
        return YES;
    }
    return NO;
}

#pragma mark - 校验密码 6-8位数字或字母
+ (BOOL)validateStringIsPaswdString:(NSString *)paswdString
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,16}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    if (![passWordPredicate evaluateWithObject:paswdString]) {
        return NO;
    }
    return YES;
}

//根据身份证判断年龄是否小于18岁
+ (BOOL)judgCurrentCustomerAgeIsLessThan18WithCertifino:(NSString *)certifino
{
    NSString *year = nil;
    NSString *month = nil;
    NSString *day = nil;
    if (certifino.length == 18) {
        year = [certifino substringWithRange:NSMakeRange(6, 4)];
        month = [certifino substringWithRange:NSMakeRange(10, 2)];
        day = [certifino substringWithRange:NSMakeRange(12, 2)];
        NSString *result = [NSString stringWithFormat:@"%@%@%@",year,month,day];
        NSInteger age = [self calculateAge:result];
        if (age < 18) {
            return YES;
        }
    }else {
        year = [certifino substringWithRange:NSMakeRange(6, 2)];
        month = [certifino substringWithRange:NSMakeRange(8, 2)];
        day = [certifino substringWithRange:NSMakeRange(10, 2)];
        NSString *result = [NSString stringWithFormat:@"19%@%@%@",year,month,day];
        NSInteger age = [self calculateAge:result];
        if (age < 18) {
            return YES;
        }
    }
    return NO;
}

//根据出生日期计算年龄
+ (NSInteger)calculateAge:(NSString *)birthday
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];//直接指定时区
    formatter.dateFormat = @"yyyyMMdd";
    NSDate *tempDate = [formatter dateFromString:birthday];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger birthdayDateYear = [calendar component:NSCalendarUnitYear fromDate:tempDate];
    NSInteger birthdayDateMonth = [calendar component:NSCalendarUnitMonth fromDate:tempDate];
    NSInteger birthdayDateDay = [calendar component:NSCalendarUnitDay fromDate:tempDate];
    
    //获取系统当前的年月日
    NSInteger currentDateYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateMonth = [calendar component:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSInteger currentDateDay = [calendar component:NSCalendarUnitDay fromDate:[NSDate date]];
    
    NSInteger age = currentDateYear - birthdayDateYear - 1;
    if ((currentDateMonth > birthdayDateMonth) || (currentDateMonth == birthdayDateMonth && currentDateDay >= birthdayDateDay)) {
        age += 1;
    }
    return age;
    
}

//计算两个日期之间相隔多少天
+ (NSInteger)getDifferenceByStart:(NSString *)start End:(NSString *)end
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    
    NSInteger dayCount = [comps day];
    if (dayCount < 0) {
        dayCount = ~(dayCount - 1);
    }
    return dayCount;
    
}

//计算两个日期之间相隔多少小时
+ (NSInteger)getTimesByStart:(NSString *)start End:(NSString *)end
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitHour;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    
    NSInteger hourCount = [comps hour];
    if (hourCount < 0) {
        hourCount = ~(hourCount - 1);
    }
    return hourCount;
    
}

//json格式字符串转字典：
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
//        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}

//截取小数点后两位
+ (NSString *)getInterceptStringForTwo:(NSString *)string
{
    if([string containsString:@"."]) {
        NSString *newString = [NSString string];
        NSRange range = [string rangeOfString:@"."];
        newString = [string substringWithRange:NSMakeRange(0, range.location + range.length + 2)];
        return newString;
    }
    return string;
}

//  颜色转换为背景图片
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (NSString*)getIPWithHostName:(const NSString *)hostName
{
    const char *hostN = [hostName UTF8String];
    struct hostent *phot;
    
    @try {
        phot = gethostbyname(hostN);
        if (phot == nil) {
            return nil;
        }
    }
    @catch (NSException *exception) {
        return nil;
    }
    
    struct in_addr ip_addr;
    memcpy(&ip_addr, phot->h_addr_list[0], 4);
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString *strIPAddress = [NSString stringWithUTF8String:ip];
    return strIPAddress;
    
}



@end
