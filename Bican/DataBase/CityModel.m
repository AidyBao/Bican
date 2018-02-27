//
//  CityModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/15.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
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

@end
