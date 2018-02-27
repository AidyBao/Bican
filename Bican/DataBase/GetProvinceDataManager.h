//
//  GetProvinceDataManager.h
//  Bican
//
//  Created by 迟宸 on 2018/1/15.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetProvinceDataManager : NSObject

#pragma mark - 保存数组
+ (void)saveDataDicRealmWith:(NSArray *)dataArray;

#pragma mark - 获取所有的省的数组model
+ (NSArray *)getAllProvinceModel;

#pragma mark - 获取所有的城市model, 每个城市是一个数组, 最后返回大数组
+ (NSArray *)getAllCityModelArray;

#pragma mark - 根据省的id, 获取城市的model
+ (NSArray *)getCityModelsWithProvinceId:(NSString *)provinceId;

#pragma mark - 根据省的id, 获取省的名字
+ (NSString *)getProvinceNameWithProvinceId:(NSString *)provinceId;

#pragma mark - 根据省的id, 城市的id, 获取城市的名字
+ (NSString *)getCityNameWithProvinceId:(NSString *)provinceId CityId:(NSString *)cityId;

@end
