//
//  AddCommentViewController.h
//  Bican
//
//  Created by 迟宸 on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"

@interface AddCommentViewController : ZTBaseViewController

@property (nonatomic, strong) NSString *cotentStr;//原文
@property (nonatomic, strong) NSString *articleIdStr;
@property (nonatomic, strong) NSString *startIndex;
@property (nonatomic, strong) NSString *endIndex;
@property (nonatomic, strong) NSString *comment;//批注内容
@property (nonatomic, strong) NSString *annotationIdStr;//批注id

@end
