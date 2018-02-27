//
//  SelectCompositionModel.m
//  Bican
//
//  Created by bican on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "SelectCompositionModel.h"

@implementation SelectCompositionModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.composition_id = (NSString *)value;
    }
}

- (NSString *)composition_id
{
    if (_composition_id == nil) {
        return @"";
    }
    if ([_composition_id isKindOfClass:[NSNumber class]]) {
        _composition_id = [NSString stringWithFormat:@"%@", _composition_id];
    }
    return _composition_id;
}


- (NSString *)appraiseNumber
{
    if (_appraiseNumber == nil) {
        return @"";
    }
    if ([_appraiseNumber isKindOfClass:[NSNumber class]]) {
        _appraiseNumber = [NSString stringWithFormat:@"%@", _appraiseNumber];
    }
    return _appraiseNumber;
}


- (NSString *)appraiseStatus
{
    if (_appraiseStatus == nil) {
        return @"";
    }
    if ([_appraiseStatus isKindOfClass:[NSNumber class]]) {
        _appraiseStatus = [NSString stringWithFormat:@"%@", _appraiseStatus];
    }
    return _appraiseStatus;
}


- (NSString *)bigTypeId
{
    if (_bigTypeId == nil) {
        return @"";
    }
    if ([_bigTypeId isKindOfClass:[NSNumber class]]) {
        _bigTypeId = [NSString stringWithFormat:@"%@", _bigTypeId];
    }
    return _bigTypeId;
}



- (NSString *)isRecommend
{
    if (_isRecommend == nil) {
        return @"";
    }
    if ([_isRecommend isKindOfClass:[NSNumber class]]) {
        _isRecommend = [NSString stringWithFormat:@"%@", _isRecommend];
    }
    return _isRecommend;
}


- (NSString *)parentId
{
    if (_parentId == nil) {
        return @"";
    }
    if ([_parentId isKindOfClass:[NSNumber class]]) {
        _parentId = [NSString stringWithFormat:@"%@", _parentId];
    }
    return _parentId;
}


- (NSString *)smallTypeId
{
    if (_smallTypeId == nil) {
        return @"";
    }
    if ([_smallTypeId isKindOfClass:[NSNumber class]]) {
        _smallTypeId = [NSString stringWithFormat:@"%@", _smallTypeId];
    }
    return _smallTypeId;
}


- (NSString *)typeId
{
    if (_typeId == nil) {
        return @"";
    }
    if ([_typeId isKindOfClass:[NSNumber class]]) {
        _typeId = [NSString stringWithFormat:@"%@", _typeId];
    }
    return _typeId;
}

@end
