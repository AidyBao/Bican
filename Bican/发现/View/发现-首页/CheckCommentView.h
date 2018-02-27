//
//  CheckCommentView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/13.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckCommentViewController.h"

@interface CheckCommentView : BaseView

@property (nonatomic, assign) BOOL isShowAll;//是否显示所有
@property (nonatomic, strong) NSString *articleIdStr;
@property (nonatomic, strong) NSString *annotationUserIdStr;
@property (nonatomic, strong) CheckCommentViewController *checkVC;

@end
