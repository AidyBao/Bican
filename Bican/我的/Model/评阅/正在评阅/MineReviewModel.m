//
//  MineReviewModel.m
//  Bican
//
//  Created by chichen on 2018/1/22.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MineReviewModel.h"

@implementation MineReviewModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.review_id = (NSString *)value;
    }
}

- (NSString *)review_id
{
    if (_review_id == nil) {
        return @"";
    }
    if ([_review_id isKindOfClass:[NSNumber class]]) {
        _review_id = [NSString stringWithFormat:@"%@", _review_id];
    }
    return _review_id;
}


- (NSString *)articleConclusionId
{
    if (_articleConclusionId == nil) {
        return @"";
    }
    if ([_articleConclusionId isKindOfClass:[NSNumber class]]) {
        _articleConclusionId = [NSString stringWithFormat:@"%@", _articleConclusionId];
    }
    return _articleConclusionId;
}

- (NSString *)articleFraction
{
    if (_articleFraction == nil) {
        return @"";
    }
    if ([_articleFraction isKindOfClass:[NSNumber class]]) {
        _articleFraction = [NSString stringWithFormat:@"%@", _articleFraction];
    }
    return _articleFraction;
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

- (NSString *)identityRole
{
    if (_identityRole == nil) {
        return @"";
    }
    if ([_identityRole isKindOfClass:[NSNumber class]]) {
        _identityRole = [NSString stringWithFormat:@"%@", _identityRole];
    }
    return _identityRole;
}


- (NSString *)isProcess
{
    if (_isProcess == nil) {
        return @"";
    }
    if ([_isProcess isKindOfClass:[NSNumber class]]) {
        _isProcess = [NSString stringWithFormat:@"%@", _isProcess];
    }
    return _isProcess;
}

- (NSString *)isReceive
{
    if (_isReceive == nil) {
        return @"";
    }
    if ([_isReceive isKindOfClass:[NSNumber class]]) {
        _isReceive = [NSString stringWithFormat:@"%@", _isReceive];
    }
    return _isReceive;
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


- (NSString *)passiveMemberId
{
    if (_passiveMemberId == nil) {
        return @"";
    }
    if ([_passiveMemberId isKindOfClass:[NSNumber class]]) {
        _passiveMemberId = [NSString stringWithFormat:@"%@", _passiveMemberId];
    }
    return _passiveMemberId;
}


- (NSString *)reviewFraction
{
    if (_reviewFraction == nil) {
        return @"";
    }
    if ([_reviewFraction isKindOfClass:[NSNumber class]]) {
        _reviewFraction = [NSString stringWithFormat:@"%@", _reviewFraction];
    }
    return _reviewFraction;
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


- (NSString *)status
{
    if (_status == nil) {
        return @"";
    }
    if ([_status isKindOfClass:[NSNumber class]]) {
        _status = [NSString stringWithFormat:@"%@", _status];
    }
    return _status;
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
