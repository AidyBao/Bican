//
//  NoticeModel.m
//  Bican
//
//  Created by bican on 2018/1/26.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel

- (NSString *)bullitenId
{
    if (_bullitenId == nil) {
        return @"";
    }
    if ([_bullitenId isKindOfClass:[NSNumber class]]) {
        _bullitenId = [NSString stringWithFormat:@"%@", _bullitenId];
    }
    return _bullitenId;
}


@end
