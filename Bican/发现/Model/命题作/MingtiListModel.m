//
//  MingtiListModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MingtiListModel.h"

@implementation MingtiListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)typeId
{
    if (_typeId == nil) {
        _typeId = @"";
    }
    if ([_typeId isKindOfClass:[NSNumber class]]) {
        _typeId = [NSString stringWithFormat:@"%@", _typeId];
    }
    return _typeId;
}

- (NSString *)articleCount
{
    if (_articleCount == nil) {
        _articleCount = @"";
    }
    if ([_articleCount isKindOfClass:[NSNumber class]]) {
        _articleCount = [NSString stringWithFormat:@"%@", _articleCount];
    }
    return _articleCount;
}

- (NSString *)clicks
{
    if (_clicks == nil) {
        _clicks = @"";
    }
    if ([_clicks isKindOfClass:[NSNumber class]]) {
        _clicks = [NSString stringWithFormat:@"%@", _clicks];
    }
    return _clicks;
}

@end
