//
//  CollectModel.m
//  Bican
//
//  Created by bican on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.collect_id = (NSString *)value;
    }
}

- (NSString *)articleId
{
    if (_articleId == nil) {
        return @"";
    }
    if ([_articleId isKindOfClass:[NSNumber class]]) {
        _articleId = [NSString stringWithFormat:@"%@", _articleId];
    }
    return _articleId;
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


- (NSString *)colletionMemberId
{
    if (_collectionMemberId == nil) {
        return @"";
    }
    if ([_collectionMemberId isKindOfClass:[NSNumber class]]) {
        _collectionMemberId = [NSString stringWithFormat:@"%@", _collectionMemberId];
    }
    return _collectionMemberId;
}


- (NSString *)collectionMemberId
{
    if (_collectionMemberId == nil) {
        return @"";
    }
    if ([_collectionMemberId isKindOfClass:[NSNumber class]]) {
        _collectionMemberId = [NSString stringWithFormat:@"%@", _collectionMemberId];
    }
    return _collectionMemberId;
}


- (NSString *)collect_id
{
    if (_collect_id == nil) {
        return @"";
    }
    if ([_collect_id isKindOfClass:[NSNumber class]]) {
        _collect_id = [NSString stringWithFormat:@"%@", _collect_id];
    }
    return _collect_id;
}


- (NSString *)schoolId
{
    if (_schoolId == nil) {
        return @"";
    }
    if ([_schoolId isKindOfClass:[NSNumber class]]) {
        _schoolId = [NSString stringWithFormat:@"%@", _schoolId];
    }
    return _schoolId;
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
