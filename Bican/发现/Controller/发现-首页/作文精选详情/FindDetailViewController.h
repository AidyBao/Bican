//
//  FindDetailViewController.h
//  Bican
//
//  Created by 迟宸 on 2018/1/11.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"

@interface FindDetailViewController : ZTBaseViewController

@property (nonatomic, strong) NSString *articleIdStr;//作文的id
@property (nonatomic, strong) NSString *isRecommend;//是否推荐 0 - 未推荐 1 - 已推荐
@property (nonatomic, strong) NSString *messageId;//消息id

@end
