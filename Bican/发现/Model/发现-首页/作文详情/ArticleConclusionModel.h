//
//  ArticleConclusionModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleConclusionModel : NSObject

@property (nonatomic, strong) NSString *sendDate;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *reviewFraction;//(number)
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *articleConclusion_id;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *developmentLevel;
@property (nonatomic, strong) NSString *develomentLabelIds;
@property (nonatomic, strong) NSString *conclusionLabelId;
@property (nonatomic, strong) NSString *commentMemberId;
@property (nonatomic, strong) NSString *basicLevel;
@property (nonatomic, strong) NSString *basicExpressLabelIds;
@property (nonatomic, strong) NSString *basicContentLabelIds;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *articleFraction;

@end
