//
//  WallectModel.h
//  Bican
//
//  Created by bican on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WallectModel : NSObject

@property (nonatomic, strong) NSString *unit;//朵
@property (nonatomic, strong) NSString *own;//个人帐号拥有数量
@property (nonatomic, strong) NSString *name;//花的名字
@property (nonatomic, strong) NSString *flowerId;// 花的Id
@property (nonatomic, strong) NSString *currency;//文币价值
@property (nonatomic, strong) NSString *type;//1为学生赠送 2为老师赠送
@property (nonatomic, strong) NSString *picture;//花的图片

@end
