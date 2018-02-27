
//
//  MessageModel.m
//  Bican
//
//  Created by bican on 2018/1/26.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (NSString *)wetherRead
{
    if (_wetherRead == nil) {
        return @"";
    }
    if ([_wetherRead isKindOfClass:[NSNumber class]]) {
        _wetherRead = [NSString stringWithFormat:@"%@", _wetherRead];
    }
    return _wetherRead;
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


- (NSString *)type
{
    if (_type == nil) {
        return @"";
    }
    if ([_type isKindOfClass:[NSNumber class]]) {
        _type = [NSString stringWithFormat:@"%@", _type];
    }
    return _type;
}


- (NSString *)messageId
{
    if (_messageId == nil) {
        return @"";
    }
    if ([_messageId isKindOfClass:[NSNumber class]]) {
        _messageId = [NSString stringWithFormat:@"%@", _messageId];
    }
    return _messageId;
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

@end
