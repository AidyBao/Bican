//
//  GetProvinceDataManager.m
//  Bican
//
//  Created by 迟宸 on 2018/1/15.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "GetProvinceDataManager.h"

@implementation GetProvinceDataManager

#pragma mark - 保存数组
+ (void)saveDataDicRealmWith:(NSArray *)dataArray
{
    RLMResults<ProvinceModel *> *dataDicModelArray = [ProvinceModel allObjects];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm deleteObjects:dataDicModelArray];
    [realm addObjects:dataArray];
    [realm commitWriteTransaction];
    
    //    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    //    NSString * string = [NSString stringWithFormat:@"%@",config.fileURL];
    //    NSLog(@"%@",string);
    
}

#pragma mark - 获取所有的省的数组model
+ (NSArray *)getAllProvinceModel
{
    NSMutableArray *newDataSourceArray = [NSMutableArray array];
    RLMResults<ProvinceModel *> *dataDicModelArray = [ProvinceModel allObjects];
   
    for (ProvinceModel *model in (NSArray *)dataDicModelArray) {
        [newDataSourceArray addObject:model];
    }
    return newDataSourceArray;

}

#pragma mark - 获取所有的城市model
+ (NSArray *)getAllCityModelArray
{
    NSMutableArray *newDataSourceArray = [NSMutableArray array];
    RLMResults<ProvinceModel *> *dataDicModelArray = [ProvinceModel allObjects];

    for (ProvinceModel *model in (NSArray *)dataDicModelArray) {
        [newDataSourceArray addObject:model.cityList];
    }
    return newDataSourceArray;
    
}


#pragma mark - 根据省的id, 获取城市的model数组
+ (NSArray *)getCityModelsWithProvinceId:(NSString *)provinceId
{
    NSMutableArray *newDataSourceArray = [NSMutableArray array];
    
    RLMResults<ProvinceModel *> *dataDicModelArray = [ProvinceModel allObjects];

    ProvinceModel *provinceModel = [[ProvinceModel alloc] init];
    for (ProvinceModel *model in (NSArray *)dataDicModelArray) {
        if ([model.provinceId isEqualToString:provinceId]) {
            provinceModel = model;
        }
    }
    [newDataSourceArray addObjectsFromArray:(NSArray *)provinceModel.cityList];
    
    [newDataSourceArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *string1 = ((CityModel *)obj1).cityId;
        NSString *string2 = ((CityModel *)obj2).cityId;
        return [string1 compare:string2];
    }];
    
    NSMutableArray *sortModelArray = [NSMutableArray array];
    for (CityModel *model in newDataSourceArray) {
        //        [sortModelArray addObject:model.cityName];
        [sortModelArray addObject:model];
    }
    
    return sortModelArray;
    
}

#pragma mark - 根据省的id, 获取省的名字
+ (NSString *)getProvinceNameWithProvinceId:(NSString *)provinceId
{
    RLMResults<ProvinceModel *> *dataDicModelArray = [ProvinceModel objectsWhere:[NSString stringWithFormat:@"provinceId = '%@'", provinceId]];
    if (dataDicModelArray.firstObject.provinceName.length == 0) {
        return @"";
    }
    return dataDicModelArray.firstObject.provinceName;
    
}

#pragma mark - 根据省的id, 城市的id, 获取城市的名字
+ (NSString *)getCityNameWithProvinceId:(NSString *)provinceId CityId:(NSString *)cityId
{
    NSMutableArray *newDataSourceArray = [NSMutableArray array];
    
    RLMResults<ProvinceModel *> *dataDicModelArray = [ProvinceModel objectsWhere:[NSString stringWithFormat:@"provinceId = '%@'", provinceId]];
    
    for (ProvinceModel *model in (NSArray *)dataDicModelArray) {
        for (CityModel *cityModel in (RLMArray *)model.cityList) {
            [newDataSourceArray addObject:cityModel];
        }        
    }

    NSString *cityName = [NSString string];
    for (CityModel *model in newDataSourceArray) {
        if ([[NSString stringWithFormat:@"%@", model.cityId] isEqualToString:cityId]) {
            cityName = [NSString stringWithFormat:@"%@", model.cityName];
            break;
        } else {
            cityName = @"";
        }
    }
    return cityName;

}





@end
