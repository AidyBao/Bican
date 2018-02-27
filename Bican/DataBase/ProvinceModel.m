//
//  ProvinceModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/15.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ProvinceModel.h"

@implementation ProvinceModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
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

@end
