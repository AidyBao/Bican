//
//  StudentCorrectViewController.h
//  Bican
//
//  Created by bican on 2018/1/28.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"
#import "StudentCompositionsViewController.h"

@interface StudentCorrectViewController : ZTBaseViewController

@property (nonatomic, strong) StudentCompositionsViewController *studentCompostionsVC;
@property (nonatomic, strong) NSString *studentIdStr;
@property (nonatomic, strong) NSString *startDate;
@property (nonatomic, strong) NSString *endDate;

@end
