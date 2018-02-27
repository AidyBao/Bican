//
//  UserSearchResultModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/16.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "UserSearchResultModel.h"

@implementation UserSearchResultModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
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



@end
