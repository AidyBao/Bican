//
//  InviteModel.h
//  Bican
//
//  Created by bican on 2018/1/19.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteModel : NSObject

@property (nonatomic, strong) NSString *articleId;//文章id
@property (nonatomic, strong) NSString *avatar;//头像
@property (nonatomic, strong) NSString *bigTypeId;//作文类型 1 - 自由写 2 - 命题作
@property (nonatomic, strong) NSString *bigTypeName;//写作类型名字
@property (nonatomic, strong) NSString *firstName;//姓
@property (nonatomic, strong) NSMutableArray *flowerList;
@property (nonatomic, strong) NSString *frequency;//赠送数量
@property (nonatomic, strong) NSString *invite_id;//评阅ID
@property (nonatomic, strong) NSString *identityRole;//1 - 我的学生 2 - 其他学生
@property (nonatomic, strong) NSString *isProcess;//正在评阅 0
@property (nonatomic, strong) NSString *isReceive;//收到评阅 1
@property (nonatomic, strong) NSString *isRecommend;//0 - 没有推荐 1 已经推荐
@property (nonatomic, strong) NSString *memberId;//??ID
@property (nonatomic, strong) NSString *nickname;//昵称
@property (nonatomic, strong) NSString *passiveMemberId;//??ID
@property (nonatomic, strong) NSString *receiveDatetime;//评阅的时间
@property (nonatomic, strong) NSString *relation;
@property (nonatomic, strong) NSString *schoolId;//学校ID
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSString *sendDatetime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusStr;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *typeName;

@end
