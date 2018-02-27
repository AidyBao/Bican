//
//  ArticleCommentDetailModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ArticleCommentDetailModel.h"

@implementation ArticleCommentDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
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

- (NSString *)replayCommentId
{
    if (_replayCommentId == nil) {
        return @"";
    }
    if ([_replayCommentId isKindOfClass:[NSNumber class]]) {
        _replayCommentId = [NSString stringWithFormat:@"%@", _replayCommentId];
    }
    return _replayCommentId;
}

@end
