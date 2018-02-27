//
//  MingtiPicShowViewController.h
//  Bican
//
//  Created by 迟宸 on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"

@interface MingtiPicShowViewController : ZTBaseViewController

@property (nonatomic, strong) NSString *allPicCount;//图片总个数
@property (nonatomic, strong) NSString *currentPicCount;//当前的图片
@property (nonatomic, strong) NSMutableArray *picArray;//图片的url数组

@end
