//
//  MessageModel.h
//  Bican
//
//  Created by bican on 2018/1/26.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *pubTime;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *wetherRead;//0-未读, 1-已读
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *messageId;
@property (nonatomic, strong) NSString *articleId;

@end
