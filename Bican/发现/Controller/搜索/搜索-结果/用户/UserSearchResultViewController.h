//
//  UserSearchResultViewController.h
//  Bican
//
//  Created by 迟宸 on 2018/1/16.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"
#import "FindSearchResultViewController.h"

@interface UserSearchResultViewController : ZTBaseViewController

@property (nonatomic, strong) FindSearchResultViewController *searchResultVC;
@property (nonatomic, strong) NSString *searhStr;

@end
