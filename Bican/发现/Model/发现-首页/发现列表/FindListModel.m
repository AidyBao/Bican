//
//  FindListModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/16.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "FindListModel.h"

@implementation FindListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.list_id = (NSString *)value;
    }
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

- (NSString *)isRecommend
{
    if (_isRecommend == nil) {
        return @"";
    }
    if ([_isRecommend isKindOfClass:[NSNumber class]]) {
        _isRecommend = [NSString stringWithFormat:@"%@", _isRecommend];
    }
    return _isRecommend;
}

- (NSString *)recommendMemberId
{
    if (_recommendMemberId == nil) {
        return @"";
    }
    if ([_recommendMemberId isKindOfClass:[NSNumber class]]) {
        _recommendMemberId = [NSString stringWithFormat:@"%@", _recommendMemberId];
    }
    return _recommendMemberId;
}

- (NSString *)list_id
{
    if (_list_id == nil) {
        return @"";
    }
    if ([_list_id isKindOfClass:[NSNumber class]]) {
        _list_id = [NSString stringWithFormat:@"%@", _list_id];
    }
    return _list_id;
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

- (NSString *)memberId
{
    if (_memberId == nil) {
        return @"";
    }
    if ([_memberId isKindOfClass:[NSNumber class]]) {
        _memberId = [NSString stringWithFormat:@"%@", _memberId];
    }
    return _memberId;
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

- (NSString *)smallTypeId
{
    if (_smallTypeId == nil) {
        return @"";
    }
    if ([_smallTypeId isKindOfClass:[NSNumber class]]) {
        _smallTypeId = [NSString stringWithFormat:@"%@", _smallTypeId];
    }
    return _smallTypeId;
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
