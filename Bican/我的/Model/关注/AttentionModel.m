//
//  AttentionModel.m
//  Bican
//
//  Created by bican on 2018/1/21.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AttentionModel.h"

@implementation AttentionModel

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
