//
//  ArticleAnnotationModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleAnnotationModel : NSObject

@property (nonatomic, strong) NSString *annotationId;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *endTxt;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *sendDate;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *startTxt;
@property (nonatomic, strong) NSString *sourceTxt;

@end
