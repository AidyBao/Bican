//
//  StudentListModel.h
//  Bican
//
//  Created by bican on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentListModel : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *weekCount;
@property (nonatomic, strong) NSString *allUnCommentCount;//历史未评阅
@property (nonatomic, strong) NSString *allCount;//历史总共提交
@property (nonatomic, strong) NSString *unCommentCount;//本周提交文章

@end
