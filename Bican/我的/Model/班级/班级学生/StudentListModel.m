//
//  StudentListModel.m
//  Bican
//
//  Created by bican on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "StudentListModel.h"

@implementation StudentListModel

- (NSString *)weekCount
{
    if (_weekCount == nil) {
        return @"";
    }
    if ([_weekCount isKindOfClass:[NSNumber class]]) {
        _weekCount = [NSString stringWithFormat:@"%@", _weekCount];
    }
    return _weekCount;
}


- (NSString *)allUnCommentCount
{
    if (_allUnCommentCount == nil) {
        return @"";
    }
    if ([_allUnCommentCount isKindOfClass:[NSNumber class]]) {
        _allUnCommentCount = [NSString stringWithFormat:@"%@", _allUnCommentCount];
    }
    return _allUnCommentCount;
}

- (NSString *)allCount
{
    if (_allCount == nil) {
        return @"";
    }
    if ([_allCount isKindOfClass:[NSNumber class]]) {
        _allCount = [NSString stringWithFormat:@"%@", _allCount];
    }
    return _allCount;
}


- (NSString *)unCommentCount
{
    if (_unCommentCount == nil) {
        return @"";
    }
    if ([_unCommentCount isKindOfClass:[NSNumber class]]) {
        _unCommentCount = [NSString stringWithFormat:@"%@", _unCommentCount];
    }
    return _unCommentCount;
}


@end
