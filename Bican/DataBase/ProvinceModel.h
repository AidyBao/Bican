//
//  ProvinceModel.h
//  Bican
//
//  Created by 迟宸 on 2018/1/15.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface ProvinceModel : RLMObject

@property (nonatomic, strong) NSString *provinceId;//number类型
@property (nonatomic, strong) RLMArray<CityModel *><CityModel> *cityList;
@property (nonatomic, strong) NSString *provinceName;

@end
