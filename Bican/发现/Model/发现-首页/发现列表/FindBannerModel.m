//
//  FindBannerModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/15.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "FindBannerModel.h"

@implementation FindBannerModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (NSString *)bannerId
{
    if (_bannerId == nil) {
        _bannerId = @"";
    }
    if ([_bannerId isKindOfClass:[NSNumber class]]) {
        _bannerId = [NSString stringWithFormat:@"%@", _bannerId];
    }
    return _bannerId;
}

@end
