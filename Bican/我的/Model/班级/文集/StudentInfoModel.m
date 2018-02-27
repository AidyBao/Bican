//
//  StudentInfoModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/26.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "StudentInfoModel.h"

@implementation StudentInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)articleCount
{
    if (_articleCount == nil) {
        return @"";
    }
    if ([_articleCount isKindOfClass:[NSNumber class]]) {
        _articleCount = [NSString stringWithFormat:@"%@", _articleCount];
    }
    return _articleCount;
}

- (NSString *)attentionCount
{
    if (_attentionCount == nil) {
        return @"";
    }
    if ([_attentionCount isKindOfClass:[NSNumber class]]) {
        _attentionCount = [NSString stringWithFormat:@"%@", _attentionCount];
    }
    return _attentionCount;
}

- (NSString *)certificateNumber
{
    if (_certificateNumber == nil) {
        return @"";
    }
    if ([_certificateNumber isKindOfClass:[NSNumber class]]) {
        _certificateNumber = [NSString stringWithFormat:@"%@", _certificateNumber];
    }
    return _certificateNumber;
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

- (NSString *)classId
{
    if (_classId == nil) {
        return @"";
    }
    if ([_classId isKindOfClass:[NSNumber class]]) {
        _classId = [NSString stringWithFormat:@"%@", _classId];
    }
    return _classId;
}

- (NSString *)draftCount
{
    if (_draftCount == nil) {
        return @"";
    }
    if ([_draftCount isKindOfClass:[NSNumber class]]) {
        _draftCount = [NSString stringWithFormat:@"%@", _draftCount];
    }
    return _draftCount;
}

- (NSString *)inviteNumber
{
    if (_inviteNumber == nil) {
        return @"";
    }
    if ([_inviteNumber isKindOfClass:[NSNumber class]]) {
        _inviteNumber = [NSString stringWithFormat:@"%@", _inviteNumber];
    }
    return _inviteNumber;
}

- (NSString *)isAttention
{
    if (_isAttention == nil) {
        return @"";
    }
    if ([_isAttention isKindOfClass:[NSNumber class]]) {
        _isAttention = [NSString stringWithFormat:@"%@", _isAttention];
    }
    return _isAttention;
}

- (NSString *)isMyTeacher
{
    if (_isMyTeacher == nil) {
        return @"";
    }
    if ([_isMyTeacher isKindOfClass:[NSNumber class]]) {
        _isMyTeacher = [NSString stringWithFormat:@"%@", _isMyTeacher];
    }
    return _isMyTeacher;
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

- (NSString *)reviewNumber
{
    if (_reviewNumber == nil) {
        return @"";
    }
    if ([_reviewNumber isKindOfClass:[NSNumber class]]) {
        _reviewNumber = [NSString stringWithFormat:@"%@", _reviewNumber];
    }
    return _reviewNumber;
}

- (NSString *)roleType
{
    if (_roleType == nil) {
        return @"";
    }
    if ([_roleType isKindOfClass:[NSNumber class]]) {
        _roleType = [NSString stringWithFormat:@"%@", _roleType];
    }
    return _roleType;
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

- (NSString *)sex
{
    if (_sex == nil) {
        return @"";
    }
    if ([_sex isKindOfClass:[NSNumber class]]) {
        _sex = [NSString stringWithFormat:@"%@", _sex];
    }
    return _sex;
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
