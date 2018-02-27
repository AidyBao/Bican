//
//  MissionModel.h
//  Bican
//
//  Created by bican on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MissionModel : NSObject

@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *schoolName;
@property (nonatomic, strong) NSMutableArray *classList;
@property (nonatomic, strong) NSString *endDate;


@end
