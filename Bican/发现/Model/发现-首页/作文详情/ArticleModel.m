//
//  ArticleModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
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

- (NSString *)bigTypeId
{
    if (_bigTypeId == nil) {
        return @"";
    }
    if ([_bigTypeId isKindOfClass:[NSNumber class]]) {
        _bigTypeId = [NSString stringWithFormat:@"%@", _bigTypeId];
    }
    return _bigTypeId;
}

- (NSString *)collectionNumber
{
    if (_collectionNumber == nil) {
        return @"";
    }
    if ([_collectionNumber isKindOfClass:[NSNumber class]]) {
        _collectionNumber = [NSString stringWithFormat:@"%@", _collectionNumber];
    }
    return _collectionNumber;
}

- (NSString *)commentNumber
{
    if (_commentNumber == nil) {
        return @"";
    }
    if ([_commentNumber isKindOfClass:[NSNumber class]]) {
        _commentNumber = [NSString stringWithFormat:@"%@", _commentNumber];
    }
    return _commentNumber;
}

- (NSString *)praiseNumber
{
    if (_praiseNumber == nil) {
        return @"";
    }
    if ([_praiseNumber isKindOfClass:[NSNumber class]]) {
        _praiseNumber = [NSString stringWithFormat:@"%@", _praiseNumber];
    }
    return _praiseNumber;
}

- (NSString *)readNumber
{
    if (_readNumber == nil) {
        return @"";
    }
    if ([_readNumber isKindOfClass:[NSNumber class]]) {
        _readNumber = [NSString stringWithFormat:@"%@", _readNumber];
    }
    return _readNumber;
}

- (NSString *)typeId
{
    if (_typeId == nil) {
        return @"";
    }
    if ([_typeId isKindOfClass:[NSNumber class]]) {
        _typeId = [NSString stringWithFormat:@"%@", _typeId];
    }
    return _typeId;
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

- (NSString *)praiseFlag
{
    if (_praiseFlag == nil) {
        return @"";
    }
    if ([_praiseFlag isKindOfClass:[NSNumber class]]) {
        _praiseFlag = [NSString stringWithFormat:@"%@", _praiseFlag];
    }
    return _praiseFlag;
}

- (NSString *)collectFlag
{
    if (_collectFlag == nil) {
        return @"";
    }
    if ([_collectFlag isKindOfClass:[NSNumber class]]) {
        _collectFlag = [NSString stringWithFormat:@"%@", _collectFlag];
    }
    return _collectFlag;
}

- (NSString *)isAbleComment
{
    if (_isAbleComment == nil) {
        return @"";
    }
    if ([_isAbleComment isKindOfClass:[NSNumber class]]) {
        _isAbleComment = [NSString stringWithFormat:@"%@", _isAbleComment];
    }
    return _isAbleComment;
}

- (NSString *)isAbleRecommend
{
    if (_isAbleRecommend == nil) {
        return @"";
    }
    if ([_isAbleRecommend isKindOfClass:[NSNumber class]]) {
        _isAbleRecommend = [NSString stringWithFormat:@"%@", _isAbleRecommend];
    }
    return _isAbleRecommend;
}

- (NSString *)status
{
    if (_status == nil) {
        return @"";
    }
    if ([_status isKindOfClass:[NSNumber class]]) {
        _status = [NSString stringWithFormat:@"%@", _status];
    }
    return _status;
}

- (NSString *)parentId
{
    if (_parentId == nil) {
        return @"";
    }
    if ([_parentId isKindOfClass:[NSNumber class]]) {
        _parentId = [NSString stringWithFormat:@"%@", _parentId];
    }
    return _parentId;
}


@end
