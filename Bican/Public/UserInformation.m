//
//  UserInformation.m
//  ZAInvestProject
//
//  Created by 迟宸 on 2017/7/17.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.my_id = (NSString *)value;
    }
}

- (NSString *)roleType
{
    if (_roleType == nil) {
        return @"";
    }
    if ([_roleType isKindOfClass:[NSNumber class]]) {
        _roleType = [NSString stringWithFormat:@"%@", _roleType];
    }
    return _roleType;
}

- (NSString *)provinceId
{
    if (_provinceId == nil) {
        return @"";
    }
    if ([_provinceId isKindOfClass:[NSNumber class]]) {
        _provinceId = [NSString stringWithFormat:@"%@", _provinceId];
    }
    return _provinceId;
}

- (NSString *)cityId
{
    if (_cityId == nil) {
        return @"";
    }
    if ([_cityId isKindOfClass:[NSNumber class]]) {
        _cityId = [NSString stringWithFormat:@"%@", _cityId];
    }
    return _cityId;
}

- (NSString *)schoolId
{
    if (_schoolId == nil) {
        return @"";
    }
    if ([_schoolId isKindOfClass:[NSNumber class]]) {
        _schoolId = [NSString stringWithFormat:@"%@", _schoolId];
    }
    return _schoolId;
}

- (NSString *)classId
{
    if (_classId == nil) {
        return @"";
    }
    if ([_classId isKindOfClass:[NSNumber class]]) {
        _classId = [NSString stringWithFormat:@"%@", _classId];
    }
    return _classId;
}

- (NSString *)schoolName
{
    if (_schoolName == nil) {
        return @"";
    }
    if ([_schoolName isKindOfClass:[NSNumber class]]) {
        _schoolName = [NSString stringWithFormat:@"%@", _schoolName];
    }
    return _schoolName;
}

- (NSString *)className
{
    if (_className == nil) {
        return @"";
    }
    if ([_className isKindOfClass:[NSNumber class]]) {
        _className = [NSString stringWithFormat:@"%@", _className];
    }
    return _className;
}

- (NSString *)currentGrade
{
    if (_currentGrade == nil) {
        return @"";
    }
    if ([_currentGrade isKindOfClass:[NSNumber class]]) {
        _currentGrade = [NSString stringWithFormat:@"%@", _currentGrade];
    }
    return _currentGrade;
}

- (NSString *)sex
{
    if (_sex == nil) {
        return @"";
    }
    if ([_sex isKindOfClass:[NSNumber class]]) {
        _sex = [NSString stringWithFormat:@"%@", _sex];
    }
    return _sex;
}

- (NSString *)token
{
    if (_token == nil) {
        return @"";
    }
    if ([_token isKindOfClass:[NSNumber class]]) {
        _token = [NSString stringWithFormat:@"%@", _token];
    }
    return _token;
}

- (NSString *)mobile
{
    if (_mobile == nil) {
        return @"";
    }
    if ([_mobile isKindOfClass:[NSNumber class]]) {
        _mobile = [NSString stringWithFormat:@"%@", _mobile];
    }
    return _mobile;
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

- (NSString *)lastName
{
    if (_lastName == nil) {
        return @"";
    }
    if ([_lastName isKindOfClass:[NSNumber class]]) {
        _lastName = [NSString stringWithFormat:@"%@", _lastName];
    }
    return _lastName;
}

- (NSString *)nickname
{
    if (_nickname == nil) {
        return @"";
    }
    if ([_nickname isKindOfClass:[NSNumber class]]) {
        _nickname = [NSString stringWithFormat:@"%@", _nickname];
    }
    return _nickname;
}

- (NSString *)firstName
{
    if (_firstName == nil) {
        return @"";
    }
    if ([_firstName isKindOfClass:[NSNumber class]]) {
        _firstName = [NSString stringWithFormat:@"%@", _firstName];
    }
    return _firstName;
}

- (NSString *)certificateNumber
{
    if (_certificateNumber == nil) {
        return @"";
    }
    if ([_certificateNumber isKindOfClass:[NSNumber class]]) {
        _certificateNumber = [NSString stringWithFormat:@"%@", _certificateNumber];
    }
    return _certificateNumber;
}

- (NSString *)my_id
{
    if (_my_id == nil) {
        return @"";
    }
    if ([_my_id isKindOfClass:[NSNumber class]]) {
        _my_id = [NSString stringWithFormat:@"%@", _my_id];
    }
    return _my_id;
}

- (NSString *)avatar
{
    if (_avatar == nil) {
        return @"";
    }
    if ([_avatar isKindOfClass:[NSNumber class]]) {
        _avatar = [NSString stringWithFormat:@"%@", _avatar];
    }
    return _avatar;
}

- (NSString *)goodReview
{
    if (_goodReview == nil) {
        return @"";
    }
    if ([_goodReview isKindOfClass:[NSNumber class]]) {
        _goodReview = [NSString stringWithFormat:@"%@", _goodReview];
    }
    return _goodReview;
}

- (NSString *)isMaxInvite
{
    if (_isMaxInvite == nil) {
        return @"";
    }
    if ([_isMaxInvite isKindOfClass:[NSNumber class]]) {
        _isMaxInvite = [NSString stringWithFormat:@"%@", _isMaxInvite];
    }
    return _isMaxInvite;
}

- (NSString *)draftCount
{
    if (_draftCount == nil) {
        return @"";
    }
    if ([_draftCount isKindOfClass:[NSNumber class]]) {
        _draftCount = [NSString stringWithFormat:@"%@", _draftCount];
    }
    return _draftCount;
}

- (NSString *)articleCount
{
    if (_articleCount == nil) {
        return @"";
    }
    if ([_articleCount isKindOfClass:[NSNumber class]]) {
        _articleCount = [NSString stringWithFormat:@"%@", _articleCount];
    }
    return _articleCount;
}

- (NSString *)reviewNumber
{
    if (_reviewNumber == nil) {
        return @"";
    }
    if ([_reviewNumber isKindOfClass:[NSNumber class]]) {
        _reviewNumber = [NSString stringWithFormat:@"%@", _reviewNumber];
    }
    return _reviewNumber;
}

- (NSString *)inviteNumber
{
    if (_inviteNumber == nil) {
        return @"";
    }
    if ([_inviteNumber isKindOfClass:[NSNumber class]]) {
        _inviteNumber = [NSString stringWithFormat:@"%@", _inviteNumber];
    }
    return _inviteNumber;
}

- (NSString *)unreadMessage
{
    if (_unreadMessage == nil) {
        return @"";
    }
    if ([_unreadMessage isKindOfClass:[NSNumber class]]) {
        _unreadMessage = [NSString stringWithFormat:@"%@", _unreadMessage];
    }
    return _unreadMessage;
}

- (NSString *)attentionCount
{
    if (_attentionCount == nil) {
        return @"";
    }
    if ([_attentionCount isKindOfClass:[NSNumber class]]) {
        _attentionCount = [NSString stringWithFormat:@"%@", _attentionCount];
    }
    return _attentionCount;
}

- (NSString *)unreadBulletin
{
    if (_unreadBulletin == nil) {
        return @"";
    }
    if ([_unreadBulletin isKindOfClass:[NSNumber class]]) {
        _unreadBulletin = [NSString stringWithFormat:@"%@", _unreadBulletin];
    }
    return _unreadBulletin;
}



@end
