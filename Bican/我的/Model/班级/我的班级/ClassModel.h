//
//  ClassModel.h
//  Bican
//
//  Created by bican on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject

#pragma mark - 推荐作文选择范围 没有用到学生人数 
@property (nonatomic, strong) NSString *studentCount;//学生人数
@property (nonatomic, strong) NSString *classId;//班级id
@property (nonatomic, strong) NSString *className;//班级名称

@end
