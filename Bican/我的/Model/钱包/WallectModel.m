//
//  WallectModel.m
//  Bican
//
//  Created by bican on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "WallectModel.h"

@implementation WallectModel

- (NSString *)own
{
    if (_own == nil) {
        return @"";
    }
    if ([_own isKindOfClass:[NSNumber class]]) {
        _own = [NSString stringWithFormat:@"%@", _own];
    }
    return _own;
}


- (NSString *)flowerId
{
    if (_flowerId == nil) {
        return @"";
    }
    if ([_flowerId isKindOfClass:[NSNumber class]]) {
        _flowerId = [NSString stringWithFormat:@"%@", _flowerId];
    }
    return _flowerId;
}


- (NSString *)currency
{
    if (_currency == nil) {
        return @"";
    }
    if ([_currency isKindOfClass:[NSNumber class]]) {
        _currency = [NSString stringWithFormat:@"%@", _currency];
    }
    return _currency;
}


- (NSString *)type
{
    if (_type == nil) {
        return @"";
    }
    if ([_type isKindOfClass:[NSNumber class]]) {
        _type = [NSString stringWithFormat:@"%@", _type];
    }
    return _type;
}


@end
