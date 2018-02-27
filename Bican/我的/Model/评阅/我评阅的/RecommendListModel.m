//
//  RecommendListModel.m
//  Bican
//
//  Created by bican on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "RecommendListModel.h"

@implementation RecommendListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.recommend_id = (NSString *)value;
    }
}


- (NSString *)recommend_id
{
    if (_recommend_id == nil) {
        return @"";
    }
    if ([_recommend_id isKindOfClass:[NSNumber class]]) {
        _recommend_id = [NSString stringWithFormat:@"%@", _recommend_id];
    }
    return _recommend_id;
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


- (NSString *)memberId
{
    if (_memberId == nil) {
        return @"";
    }
    if ([_memberId isKindOfClass:[NSNumber class]]) {
        _memberId = [NSString stringWithFormat:@"%@", _memberId];
    }
    return _memberId;
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


- (NSString *)userId
{
    if (_userId == nil) {
        return @"";
    }
    if ([_userId isKindOfClass:[NSNumber class]]) {
        _userId = [NSString stringWithFormat:@"%@", _userId];
    }
    return _userId;
}


@end
