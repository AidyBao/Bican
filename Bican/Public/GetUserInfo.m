//
//  GetUserInfo.m
//  ZAInvestProject
//
//  Created by 迟宸 on 2017/7/17.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "GetUserInfo.h"

@implementation GetUserInfo


+ (UserInformation *)getUserInfoModel
{
    RLMResults<UserInformation *> *userArray = [UserInformation allObjects];
    UserInformation *userModel = (UserInformation *)userArray.firstObject;
    return userModel;
}

//添加整个model
+ (void)addUserInfoModel:(UserInformation *)userInfoModel
{
    RLMResults<UserInformation *> *userArray = [UserInformation allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:userArray];
    [realm addObject:userInfoModel];
    [realm commitWriteTransaction];
    
//    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
//    NSString *string = [NSString stringWithFormat:@"%@",config.fileURL];
    
}

+ (BOOL)judgIsloginByUserModel
{
    RLMResults<UserInformation *> *userArray = [UserInformation allObjects];
    UserInformation *userModel = (UserInformation *)userArray.firstObject;
    if (userModel == nil) {
        return NO;
    }else {
        return YES;
    }
}

+ (void)deleteUserModelInCache
{
    RLMResults<UserInformation *> *userResultls = [UserInformation allObjects];
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:userResultls];
    [realm commitWriteTransaction];
}

+ (void)updateUserinfoModelWithNewModel:(UserInformation *)newUserInfoModel
{
    RLMResults<UserInformation *> *userArray = [UserInformation allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:userArray];
    [realm addObject:newUserInfoModel];
    [realm commitWriteTransaction];
    
}

+ (void)updateUserinfoOfToken:(NSString *)token
{
    RLMResults<UserInformation *> * userResultes = [UserInformation allObjects];
    UserInformation *oldUserModel = (UserInformation *)userResultes.firstObject;
    RLMRealm * realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    oldUserModel.token = token;
    [realm commitWriteTransaction];
}



@end
