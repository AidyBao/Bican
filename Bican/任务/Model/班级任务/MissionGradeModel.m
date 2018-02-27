//
//  MissionGradeModel.m
//  Bican
//
//  Created by bican on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MissionGradeModel.h"

@implementation MissionGradeModel

- (NSString *)studentId
{
    if (_studentId == nil) {
        return @"";
    }
    if ([_studentId isKindOfClass:[NSNumber class]]) {
        _studentId = [NSString stringWithFormat:@"%@", _studentId];
    }
    return _studentId;
}


- (NSString *)inviteCount
{
    if (_inviteCount == nil) {
        return @"";
    }
    if ([_inviteCount isKindOfClass:[NSNumber class]]) {
        _inviteCount = [NSString stringWithFormat:@"%@", _inviteCount];
    }
    return _inviteCount;
}


- (NSString *)wordCount
{
    if (_wordCount == nil) {
        return @"";
    }
    if ([_wordCount isKindOfClass:[NSNumber class]]) {
        _wordCount = [NSString stringWithFormat:@"%@", _wordCount];
    }
    return _wordCount;
}

@end
