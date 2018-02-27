//
//  MissionClassModel.m
//  Bican
//
//  Created by bican on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MissionClassModel.h"

@implementation MissionClassModel

- (NSString *)totalCount
{
    if (_totalCount == nil) {
        return @"";
    }
    if ([_totalCount isKindOfClass:[NSNumber class]]) {
        _totalCount = [NSString stringWithFormat:@"%@", _totalCount];
    }
    return _totalCount;
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



- (NSString *)completeCount
{
    if (_completeCount == nil) {
        return @"";
    }
    if ([_completeCount isKindOfClass:[NSNumber class]]) {
        _completeCount = [NSString stringWithFormat:@"%@", _completeCount];
    }
    return _completeCount;
}

@end
