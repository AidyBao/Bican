//
//  MissionFilterViewController.h
//  Bican
//
//  Created by 迟宸 on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"

@protocol MissionFilterViewControllerDelegate <NSObject>

- (void)startDate:(NSString *)startDate
          EndDate:(NSString *)endDate
SelelctedClassIndex:(NSString *)selelctedClassIndex;

@end

@interface MissionFilterViewController : ZTBaseViewController

@property (nonatomic, strong) NSString *bengin_start;//开始时间区间
@property (nonatomic, strong) NSString *bengin_end;

@property (nonatomic, strong) NSString *end_start;//结束时间区间
@property (nonatomic, strong) NSString *end_end;

@property (nonatomic, assign) id <MissionFilterViewControllerDelegate> delegate;

@end
