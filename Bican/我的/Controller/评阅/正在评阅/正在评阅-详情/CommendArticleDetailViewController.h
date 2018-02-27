//
//  CommendArticleDetailViewController.h
//  Bican
//
//  Created by 迟宸 on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"
#import "InviteModel.h"

@protocol CommendArticleDelegate <NSObject>

- (void)saveCommendSuccess;

@end

@interface CommendArticleDetailViewController : ZTBaseViewController

@property (nonatomic, assign) id <CommendArticleDelegate> delegate;
@property (nonatomic, strong) InviteModel *inviteModel;
//1.从邀请评阅进入, 下面只有查看批注 2.从文集进入, 下面@[@"查看批注", @"总评"]
@property (nonatomic, assign) BOOL isFromInvite;

@end
