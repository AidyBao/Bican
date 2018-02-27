//
//  SearchHistoryModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/16.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "SearchHistoryModel.h"

@implementation SearchHistoryModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.key_id = (NSString *)value;
    }
}

- (NSString *)key_id
{
    if (_key_id == nil) {
        return @"";
    }
    if ([_key_id isKindOfClass:[NSNumber class]]) {
        _key_id = [NSString stringWithFormat:@"%@", _key_id];
    }
    return _key_id;
}



@end
