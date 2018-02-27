//
//  UserInformation.h
//  ZAInvestProject
//
//  Created by 迟宸 on 2017/7/17.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface UserInformation : RLMObject

/********* 用户信息中共返回有27个参数  ************/

//身份标示 (1-学生, 2-老师)
@property (nonatomic, strong) NSString *roleType;

@property (nonatomic, strong) NSString *provinceId;//省id
@property (nonatomic, strong) NSString *cityId;//城市id
@property (nonatomic, strong) NSString *schoolId;//学校id
@property (nonatomic, strong) NSString *classId;//班级id
@property (nonatomic, strong) NSString *schoolName;//学校名称
@property (nonatomic, strong) NSString *className;//班级名称
@property (nonatomic, strong) NSString *currentGrade;//当前的年级

@property (nonatomic, strong) NSString *sex;//性别
@property (nonatomic, strong) NSString *token;//用户token
@property (nonatomic, strong) NSString *mobile;//手机号
@property (nonatomic, strong) NSString *userId;//用户id
@property (nonatomic, strong) NSString *lastName;//名字
@property (nonatomic, strong) NSString *nickname;//昵称
@property (nonatomic, strong) NSString *firstName;//姓
@property (nonatomic, strong) NSString *certificateNumber;//教师资格证编号
@property (nonatomic, strong) NSString *my_id;//什么id?

@property (nonatomic, strong) NSString *avatar;//头像地址
@property (nonatomic, strong) NSString *goodReview;//好评?(貌似是分数)
@property (nonatomic, strong) NSString *isMaxInvite;//是否已到达最高推荐(0-?, 1-?)
@property (nonatomic, strong) NSString *draftCount;//草稿个数?
@property (nonatomic, strong) NSString *articleCount;//文章数?
@property (nonatomic, strong) NSString *reviewNumber;//好评数?
@property (nonatomic, strong) NSString *inviteNumber;//邀请数?
@property (nonatomic, strong) NSString *unreadMessage;//未读信息个数?
@property (nonatomic, strong) NSString *attentionCount;//关注数?收藏数?
@property (nonatomic, strong) NSString *unreadBulletin;//是否有未读公告?(0-?,1-?)

@end
