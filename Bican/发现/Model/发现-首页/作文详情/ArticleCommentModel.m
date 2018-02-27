//
//  ArticleCommentModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//  回复

#import "ArticleCommentModel.h"

@implementation ArticleCommentModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.comment_id = (NSString *)value;
    }
}

- (NSString *)comment_id
{
    if (_comment_id == nil) {
        return @"";
    }
    if ([_comment_id isKindOfClass:[NSNumber class]]) {
        _comment_id = [NSString stringWithFormat:@"%@", _comment_id];
    }
    return _comment_id;
}

- (NSString *)replyMemberId
{
    if (_replyMemberId == nil) {
        return @"";
    }
    if ([_replyMemberId isKindOfClass:[NSNumber class]]) {
        _replyMemberId = [NSString stringWithFormat:@"%@", _replyMemberId];
    }
    return _replyMemberId;
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

- (NSString *)articleReplyId
{
    if (_articleReplyId == nil) {
        return @"";
    }
    if ([_articleReplyId isKindOfClass:[NSNumber class]]) {
        _articleReplyId = [NSString stringWithFormat:@"%@", _articleReplyId];
    }
    return _articleReplyId;
}

@end
