
//
//  InviteGiftModel.m
//  Bican
//
//  Created by bican on 2018/1/19.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "InviteGiftModel.h"

@implementation InviteGiftModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.gift_id = (NSString *)value;
    }
}


- (NSString *)gift_id
{
    if (_gift_id == nil) {
        return @"";
    }
    if ([_gift_id isKindOfClass:[NSNumber class]]) {
        _gift_id = [NSString stringWithFormat:@"%@", _gift_id];
    }
    return _gift_id;
}


- (NSString *)currency
{
    if (_currency == nil) {
        return @"";
    }
    if ([_currency isKindOfClass:[NSNumber class]]) {
        _currency = [NSString stringWithFormat:@"%@", _currency];
    }
    return _currency;
}


- (NSString *)flowerId
{
    if (_flowerId == nil) {
        return @"";
    }
    if ([_flowerId isKindOfClass:[NSNumber class]]) {
        _flowerId = [NSString stringWithFormat:@"%@", _flowerId];
    }
    return _flowerId;
}


- (NSString *)inviteId
{
    if (_inviteId == nil) {
        return @"";
    }
    if ([_inviteId isKindOfClass:[NSNumber class]]) {
        _inviteId = [NSString stringWithFormat:@"%@", _inviteId];
    }
    return _inviteId;
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


- (NSString *)passiveMemberId
{
    if (_passiveMemberId == nil) {
        return @"";
    }
    if ([_passiveMemberId isKindOfClass:[NSNumber class]]) {
        _passiveMemberId = [NSString stringWithFormat:@"%@", _passiveMemberId];
    }
    return _passiveMemberId;
}

@end
