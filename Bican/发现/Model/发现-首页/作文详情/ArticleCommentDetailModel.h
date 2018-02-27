//
//  ArticleCommentDetailModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleCommentDetailModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *replayCommentId;
@property (nonatomic, strong) NSString *replyMemberId;
@property (nonatomic, strong) NSString *commentMemberId;
@property (nonatomic, strong) NSString *nickname;

@end
