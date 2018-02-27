//
//  AnnotationListModel.m
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AnnotationListModel.h"

@implementation AnnotationListModel

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


@end
