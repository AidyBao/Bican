//
//  MyClassModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/19.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyClassModel : NSObject

@property (nonatomic, strong) NSString *my_classId;
@property (nonatomic, strong) NSString *my_className;
@property (nonatomic, strong) NSString *hasTeacher;//是否有教师(1-有,2-无)(number)

@end
