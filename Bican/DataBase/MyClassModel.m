//
//  MyClassModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/19.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MyClassModel.h"

@implementation MyClassModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"classId"]) {
        self.my_classId = (NSString *)value;
    }
    if ([key isEqualToString:@"className"]) {
        self.my_className = (NSString *)value;
    }
}

- (NSString *)my_classId
{
    if (_my_classId == nil) {
        return @"";
    }
    if ([_my_classId isKindOfClass:[NSNumber class]]) {
        _my_classId = [NSString stringWithFormat:@"%@", _my_classId];
    }
    return _my_classId;
}

- (NSString *)hasTeacher
{
    if (_hasTeacher == nil) {
        return @"";
    }
    if ([_hasTeacher isKindOfClass:[NSNumber class]]) {
        _hasTeacher = [NSString stringWithFormat:@"%@", _hasTeacher];
    }
    return _hasTeacher;
}

@end
