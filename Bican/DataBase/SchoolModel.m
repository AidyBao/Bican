//
//  SchoolModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/18.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "SchoolModel.h"

@implementation SchoolModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.school_id = (NSString *)value;
    }
}

- (NSString *)cityId
{
    if (_cityId == nil) {
        return @"";
    }
    if ([_cityId isKindOfClass:[NSNumber class]]) {
        _cityId = [NSString stringWithFormat:@"%@", _cityId];
    }
    return _cityId;
}

- (NSString *)provinceId
{
    if (_provinceId == nil) {
        return @"";
    }
    if ([_provinceId isKindOfClass:[NSNumber class]]) {
        _provinceId = [NSString stringWithFormat:@"%@", _provinceId];
    }
    return _provinceId;
}

- (NSString *)school_id
{
    if (_school_id == nil) {
        return @"";
    }
    if ([_school_id isKindOfClass:[NSNumber class]]) {
        _school_id = [NSString stringWithFormat:@"%@", _school_id];
    }
    return _school_id;
}


@end
