//
//  SelectCompositionModel.h
//  Bican
//
//  Created by bican on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SelectCompositionModel : NSObject

@property (nonatomic, strong) NSString *appraiseNumber;
@property (nonatomic, strong) NSString *appraiseStatus;//评阅状态
@property (nonatomic, strong) NSString *appraiseStatusStr;//评阅状态文字
@property (nonatomic, strong) NSString *bigTypeId;
@property (nonatomic, strong) NSString *bigTypeName;
@property (nonatomic, strong) NSString *composition_id;
@property (nonatomic, strong) NSString *isRecommend;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *sendDate;
@property (nonatomic, strong) NSString *smallTypeId;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *typeName;

@property (nonatomic, strong) NSString *content;

@end
