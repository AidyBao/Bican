//
//  CheckLoginOutManager.h
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckLoginOutManager : NSObject

+ (instancetype)checkManager;

//校验token是否过期
- (void)toCheckIsLoginOutWithStatus:(NSString *)status UrlString:(NSString *)urlString completion:(void (^)(BOOL isShow))completion;

@end
