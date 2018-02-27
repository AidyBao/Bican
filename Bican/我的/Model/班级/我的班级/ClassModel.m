//
//  ClassModel.m
//  Bican
//
//  Created by bican on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)studentCount
{
    if (_studentCount == nil) {
        return @"";
    }
    if ([_studentCount isKindOfClass:[NSNumber class]]) {
        _studentCount = [NSString stringWithFormat:@"%@", _studentCount];
    }
    return _studentCount;
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

@end
