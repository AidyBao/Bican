//
//  NSDictionary+Extention.h
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Extention)

+ (NSString *)nsstringWithDictionary:(NSDictionary *)dict;
+ (NSString *)sorteStringWithDic:(NSDictionary *)dic;
+ (NSString *)md5:(NSString *)str;
+ (NSString *)time;

@end
