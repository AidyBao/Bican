//
//  ArticleAnnotationModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//  批注

#import "ArticleAnnotationModel.h"

@implementation ArticleAnnotationModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)annotationId
{
    if (_annotationId == nil) {
        return @"";
    }
    if ([_annotationId isKindOfClass:[NSNumber class]]) {
        _annotationId = [NSString stringWithFormat:@"%@", _annotationId];
    }
    return _annotationId;
}

- (NSString *)articleId
{
    if (_articleId == nil) {
        return @"";
    }
    if ([_articleId isKindOfClass:[NSNumber class]]) {
        _articleId = [NSString stringWithFormat:@"%@", _articleId];
    }
    return _articleId;
}

- (NSString *)endTxt
{
    if (_endTxt == nil) {
        return @"";
    }
    if ([_endTxt isKindOfClass:[NSNumber class]]) {
        _endTxt = [NSString stringWithFormat:@"%@", _endTxt];
    }
    return _endTxt;
}

- (NSString *)role
{
    if (_role == nil) {
        return @"";
    }
    if ([_role isKindOfClass:[NSNumber class]]) {
        _role = [NSString stringWithFormat:@"%@", _role];
    }
    return _role;
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

- (NSString *)startTxt
{
    if (_startTxt == nil) {
        return @"";
    }
    if ([_startTxt isKindOfClass:[NSNumber class]]) {
        _startTxt = [NSString stringWithFormat:@"%@", _startTxt];
    }
    return _startTxt;
}

- (NSString *)sourceTxt
{
    if (_sourceTxt == nil) {
        return @"";
    }
    if ([_sourceTxt isKindOfClass:[NSNumber class]]) {
        _sourceTxt = [NSString stringWithFormat:@"%@", _sourceTxt];
    }
    return _sourceTxt;
}


@end
