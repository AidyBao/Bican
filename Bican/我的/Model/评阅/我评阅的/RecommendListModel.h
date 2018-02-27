//
//  RecommendListModel.h
//  Bican
//
//  Created by bican on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendListModel : NSObject

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *bigTypeId;
@property (nonatomic, strong) NSString *bigTypeName;
@property (nonatomic, strong) NSString *recommend_id;
@property (nonatomic, strong) NSString *isRecommend;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *memberNickname;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *recommendDate;
@property (nonatomic, strong) NSString *smallTypeId;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *userId;

@end
