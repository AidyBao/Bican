//
//  NSDictionary+Extention.m
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "NSDictionary+Extention.h"

@implementation NSDictionary (Extention)

+ (NSString *)nsstringWithDictionary:(NSDictionary *)dict
{
    NSArray *arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
//        return result==NSOrderedAscending;//升序
        return result==NSOrderedDescending;
    }];
    
    
    NSString *string = @"";
    for (int i = 0; i< arr.count; i++) {
        NSString *key = arr[i];
        NSString *value = [NSString stringWithFormat:@"%@",[dict objectForKey:key]];
        
        if ([key isEqualToString:@"sign"]) {
            
        } else if ([value isEqualToString:@""] || value == nil) {
            string = [NSString stringWithFormat:@"%@\"%@\":\"%@\",", string, key, @""];

        } else {
            string = [NSString stringWithFormat:@"%@\"%@\":\"%@\",", string, key, value];

        }
    }
    return string;
    
}

#pragma mark - 将字典排序后拼接成字符串返回
+ (NSString *)sorteStringWithDic:(NSDictionary *)dic {
    if (dic.allKeys.count < 1 || dic == nil) return nil;
//    NSArray *result = [dic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch|NSNumericSearch]; //升序
//    }];
    
    NSArray *result = [dic allKeys];
    result = [result sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    if (result.count < 1 || result == nil) return nil;
    NSString *jsonStr = [[NSString alloc] init];
    for (NSString *item in result) {
        NSString *string;
        NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:item]];
        if ([item isEqualToString:@"_sign"]) {
            continue;
        } else if ([value isEqualToString:@""]||value ==nil) {
            string = [NSString stringWithFormat:@"%@=%@&",item,@""];
        }
        else{
            string = [NSString stringWithFormat:@"%@=%@&",item,value];
        }
        jsonStr = [jsonStr stringByAppendingString:string];
    }
    jsonStr = [jsonStr substringToIndex:jsonStr.length - 1];
    return jsonStr;
}


+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)time
{
//    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYYMMddHHSSS"];
////    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];//直接指定时区
//    NSString *defaultTimeZoneStr = [formatter stringFromDate:date];
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return [NSString stringWithFormat:@"%llu", recordTime];
//    return defaultTimeZoneStr;
    //    NSDate *date = [NSDate date];
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    //    NSString *Time = [formatter stringFromDate:date];
    //
    //    return Time;
}


@end
