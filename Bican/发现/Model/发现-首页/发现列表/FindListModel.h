//
//  FindListModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/16.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindListModel : NSObject

@property (nonatomic, strong) NSString *articleId;//number
@property (nonatomic, strong) NSString *avatar;//头像图片
@property (nonatomic, strong) NSString *nickname;//学生昵称
@property (nonatomic, strong) NSString *schoolName;//学校

@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *summary;//总结(列表显示)
@property (nonatomic, strong) NSString *content;//内容(详情页面显示, html字符串)

/* 类型 : 自由写 - 青春 */
@property (nonatomic, strong) NSString *bigTypeId;//number
@property (nonatomic, strong) NSString *bigTypeName;
@property (nonatomic, strong) NSString *typeId;//number
@property (nonatomic, strong) NSString *typeName;

/* 列表底部 */
@property (nonatomic, strong) NSString *readNumber;//阅读个数(number)
@property (nonatomic, strong) NSString *praiseNumber;//赞个数(number)
@property (nonatomic, strong) NSString *collectionNumber;//收藏个数(number)
@property (nonatomic, strong) NSString *commentNumber;//评论个数(number)

/* 推荐相关参数 */
@property (nonatomic, strong) NSString *isRecommend;//是否推荐(number)
@property (nonatomic, strong) NSString *recommendDate;//推荐日期
@property (nonatomic, strong) NSString *recommendMemberId;//推荐人id(number)
@property (nonatomic, strong) NSString *recommendMemberNickName;//推荐人昵称


@property (nonatomic, strong) NSString *list_id;//文章id(number)
@property (nonatomic, strong) NSString *userId;//number
@property (nonatomic, strong) NSString *sendDate;//发送日期

@property (nonatomic, strong) NSString *memberId;//?(number)
@property (nonatomic, strong) NSString *parentId;//?(number)
@property (nonatomic, strong) NSString *status;//?(number)
@property (nonatomic, strong) NSString *smallTypeId;//?(number)
@property (nonatomic, strong) NSString *wordCount;//文字个数number


@end
