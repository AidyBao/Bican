//
//  UserSearchResultModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/16.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSearchResultModel : NSObject

@property (nonatomic, strong) NSString *isAttention;//是否关注, 0-未关注, 1-已关注(number)
@property (nonatomic, strong) NSString *goodReview;//好评率
@property (nonatomic, strong) NSString *reviewNumber;//评论数(number)
@property (nonatomic, strong) NSString *schoolName;//学校名称
@property (nonatomic, strong) NSString *nickName;//昵称
@property (nonatomic, strong) NSString *userId;//(number)
@property (nonatomic, strong) NSString *grade;//班级
@property (nonatomic, strong) NSString *roleType;//(number)
@property (nonatomic, strong) NSString *isMyTeacher;//是否为我的老师(0-不是, 1-是)(number)
@property (nonatomic, strong) NSString *inviteNumber;//(number)
@property (nonatomic, strong) NSString *avatar;//
@property (nonatomic, strong) NSString *teacherName;//

@end
