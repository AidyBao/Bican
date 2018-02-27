//
//  InvistToRecommedModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/23.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvistToRecommedModel : NSObject

@property (nonatomic, strong) NSString *invite_id;

@property (nonatomic, strong) NSString *articleConclusionId;//总评id
@property (nonatomic, strong) NSString *articleFraction;//分数
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *basicLevel;
@property (nonatomic, strong) NSString *bigTypeId;
@property (nonatomic, strong) NSString *bigTypeName;
@property (nonatomic, strong) NSString *developmentLevel;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSMutableArray *flowerList;
@property (nonatomic, strong) NSString *frequency;
@property (nonatomic, strong) NSString *identityRole;
@property (nonatomic, strong) NSString *isProcess;
@property (nonatomic, strong) NSString *isReceive;
@property (nonatomic, strong) NSString *isRecommend;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *passiveMemberId;
@property (nonatomic, strong) NSString *receiveDatetime;
@property (nonatomic, strong) NSString *relation;
@property (nonatomic, strong) NSString *reviewFraction;
@property (nonatomic, strong) NSString *schoolId;
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSString *sendDatetime;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *statusStr;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *typeId;

@end
