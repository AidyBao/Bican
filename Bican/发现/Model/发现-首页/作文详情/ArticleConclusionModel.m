//
//  ArticleConclusionModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//  总评

#import "ArticleConclusionModel.h"

@implementation ArticleConclusionModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.articleConclusion_id = (NSString *)value;
    }
}

- (NSString *)developmentLevel
{
    _developmentLevel =  [_developmentLevel stringByReplacingOccurrencesOfString:@"##" withString:@","];
    _developmentLevel =  [_developmentLevel stringByReplacingOccurrencesOfString:@"#" withString:@""];

    return _developmentLevel;
}

- (NSString *)basicLevel
{
    _basicLevel =  [_basicLevel stringByReplacingOccurrencesOfString:@"##" withString:@","];
    _basicLevel =  [_basicLevel stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    return _basicLevel;
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

- (NSString *)reviewFraction
{
    if (_reviewFraction == nil) {
        return @"";
    }
    if ([_reviewFraction isKindOfClass:[NSNumber class]]) {
        _reviewFraction = [NSString stringWithFormat:@"%@", _reviewFraction];
    }
    return _reviewFraction;
}

- (NSString *)articleConclusion_id
{
    if (_articleConclusion_id == nil) {
        return @"";
    }
    if ([_articleConclusion_id isKindOfClass:[NSNumber class]]) {
        _articleConclusion_id = [NSString stringWithFormat:@"%@", _articleConclusion_id];
    }
    return _articleConclusion_id;
}

- (NSString *)commentMemberId
{
    if (_commentMemberId == nil) {
        return @"";
    }
    if ([_commentMemberId isKindOfClass:[NSNumber class]]) {
        _commentMemberId = [NSString stringWithFormat:@"%@", _commentMemberId];
    }
    return _commentMemberId;
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

- (NSString *)articleFraction
{
    if (_articleFraction == nil) {
        return @"";
    }
    if ([_articleFraction isKindOfClass:[NSNumber class]]) {
        _articleFraction = [NSString stringWithFormat:@"%@", _articleFraction];
    }
    return _articleFraction;
}




@end
