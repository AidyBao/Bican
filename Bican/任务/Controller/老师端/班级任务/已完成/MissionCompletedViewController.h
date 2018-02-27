//
//  MissionCompletedViewController.h
//  Bican
//
//  Created by bican on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"
#import "MissionClassViewController.h"

@interface MissionCompletedViewController : ZTBaseViewController

@property (nonatomic, strong) MissionClassViewController *missionClassVC;

@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *classId;

@end
