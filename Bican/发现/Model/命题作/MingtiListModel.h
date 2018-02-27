//
//  MingtiListModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MingtiListModel : NSObject

@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *source;//内容-上部显示
@property (nonatomic, strong) NSString *summary;//内容-下部显示
@property (nonatomic, strong) NSString *clicks;//查看数(number)
@property (nonatomic, strong) NSString *articleCount;//作文数(number)
@property (nonatomic, strong) NSString *provider;//@ + 提供人 + "提供"
@property (nonatomic, strong) NSString *typeId;

@property (nonatomic, strong) NSString *content;//(完成命题接口返回)

@end
