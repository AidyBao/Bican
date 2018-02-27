//
//  CityModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/15.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

RLM_ARRAY_TYPE(CityModel) // 定义RLMArray<CityModel>

@interface CityModel : RLMObject

@property (nonatomic, strong) NSString *cityId;//number类型
@property (nonatomic, strong) NSString *cityName;

@end
