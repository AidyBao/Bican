//
//  AttentionModel.h
//  Bican
//
//  Created by bican on 2018/1/21.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionModel : NSObject

@property (nonatomic, strong) NSString *goodReview;//评分
@property (nonatomic, strong) NSString *reviewNumber;//评阅文章
@property (nonatomic, strong) NSString *schoolName;//学校名称
@property (nonatomic, strong) NSString *nickName;//昵称
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *grade;//年级
@property (nonatomic, strong) NSString *roleType;//角色类型；1：学生，2：老师，0：所有
@property (nonatomic, strong) NSString *isMyTeacher;//是否是我的班级老师
@property (nonatomic, strong) NSString *inviteNumber;//受邀次数
@property (nonatomic, strong) NSString *avatar;//头像
@property (nonatomic, strong) NSString *teacherName;//老师名字

@end
