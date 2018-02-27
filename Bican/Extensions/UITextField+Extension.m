//
//  UITextField+Extension.m
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

//检测字符串是否是纯数字
- (BOOL)isNumber:(NSString *)num
{
    NSString *number = @"0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:number] invertedSet];
    NSString *filtered = [[num componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [num isEqualToString:filtered];
    return basic;
}

//检测字符串是数字包含小数点
- (BOOL)isNumberOrPoints:(NSString *)num
{
    NSString *number = @"0123456789.";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:number] invertedSet];
    NSString *filtered = [[num componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [num isEqualToString:filtered];
    return basic;
    
    //    NSString *postalcodeRegex = @"^[0-9]+([.]{0,1}[0-9]+){0,1}$";
    //    NSPredicate *postalcodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",postalcodeRegex];
    //    return [postalcodeTest evaluateWithObject:num];
    
}

//检测字符串是否是数字或字母组成
- (BOOL)isNumberOrLetter:(NSString *)num
{
    NSString *numberOrLetter = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:numberOrLetter] invertedSet];
    NSString *filtered = [[num componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [num isEqualToString:filtered];
    return basic;
}

//检测是否是手机号码
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * mobile = @"^1[34578]\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    if ([regextestmobile evaluateWithObject:mobileNum] == YES) {
        return YES;
    }else {
        return NO;
    }
}


//判断字符串是否为空或者都是空格
- (BOOL)isEmptyOrWhitespace:(NSString *)string
{
    if (string == nil){
        return YES;
    }
    if (string == NULL){
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]){
        return YES;
    }
    //判断字符串是否全部为空格（[NSCharacterSet whitespaceAndNewlineCharacterSet]去掉字符串两端的空格)
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0){
        return YES;
    }
    return NO;
}
//邮箱验证
- (BOOL)validateEmail:(NSString *)email
{
    //    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *emailRegex = @"[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}

- (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
    
}

- (BOOL)validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
    
}

- (BOOL)validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}





@end
