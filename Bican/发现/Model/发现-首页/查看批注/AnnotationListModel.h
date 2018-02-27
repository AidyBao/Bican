//
//  AnnotationListModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnotationListModel : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *annotationId;
@property (nonatomic, strong) NSString *role;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *startTxt;
@property (nonatomic, strong) NSString *sourceTxt;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *endTxt;

@end
