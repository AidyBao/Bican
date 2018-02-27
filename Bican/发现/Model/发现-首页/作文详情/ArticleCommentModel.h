//
//  ArticleCommentModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleCommentModel : NSObject

@property (nonatomic, strong) NSString *sendDate;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *comment_id;
@property (nonatomic, strong) NSString *replyMemberId;
@property (nonatomic, strong) NSString *commentMemberId;
@property (nonatomic, strong) NSMutableDictionary *comment;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *articleReplyId;

@end
