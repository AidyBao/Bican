//
//  ArticleModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : NSObject

@property (nonatomic, strong) NSString *appraiseStatus;//评论状态, 0-?, 1-?(number)
@property (nonatomic, strong) NSMutableArray *articleAnnotationList;//文章批注数组
@property (nonatomic, strong) NSMutableArray *articleConclusionList;//文章评论数组

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *bigTypeId;
@property (nonatomic, strong) NSString *bigTypeName;
@property (nonatomic, strong) NSString *collectionNumber;
@property (nonatomic, strong) NSString *commentNumber;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *praiseNumber;//赞
@property (nonatomic, strong) NSString *readNumber;
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *recommendDate;//推荐日期

@property (nonatomic, strong) NSString *praiseFlag;//是否已经赞?
@property (nonatomic, strong) NSString *collectFlag;//是否已经收藏???
@property (nonatomic, strong) NSString *isAbleComment;//是否能评论?
@property (nonatomic, strong) NSString *isAbleRecommend;//是否能推荐?
@property (nonatomic, strong) NSString *status;//?
@property (nonatomic, strong) NSString *parentId;//?

@end
