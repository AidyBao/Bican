//
//  GetUserInfo.h
//  ZAInvestProject
//
//  Created by 迟宸 on 2017/7/17.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInformation.h"

@interface GetUserInfo : NSObject

//获取个人信息的model
+ (UserInformation *)getUserInfoModel;

//增加新的个人信息, 同时删除原来的个人信息
+ (void)addUserInfoModel:(UserInformation *)userInfoModel;

//通过数据库中的userModel 是否存在判断 是否登录
+ (BOOL)judgIsloginByUserModel;

//删除数据库中的缓存model
+ (void)deleteUserModelInCache;

//更新model
+(void)updateUserinfoModelWithNewModel:(UserInformation *)newUserInfoModel;

//更新用户的token
+ (void)updateUserinfoOfToken:(NSString *)token;

@end
