//
//  CheckLoginOutManager.m
//  Bican
//
//  Created by 迟宸 on 2018/1/17.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CheckLoginOutManager.h"

@interface CheckLoginOutManager ()

@property (nonatomic, assign) BOOL isHave;//是否已经存在

@end

@implementation CheckLoginOutManager

static CheckLoginOutManager *checkManager = nil;

+ (instancetype)checkManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checkManager = [[self alloc] init];
    });
    return checkManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        checkManager = [super allocWithZone:zone];
    });
    return checkManager;
}

- (void)toCheckIsLoginOutWithStatus:(NSString *)status UrlString:(NSString *)urlString completion:(void (^)(BOOL isShow))completion
{
    if ([status isEqualToString:@"100003"] && ![urlString containsString:@"provinceAndCity"]) {
        //如果没有登录, 就不提示
        if (![GetUserInfo judgIsloginByUserModel]) {
            return;
        }
        //如果已经提示过, 清空用户信息, 并且不提示
        if (self.isHave) {
            return;
        }
        [GetUserInfo deleteUserModelInCache];
        //创建弹出的view
        [LoginTimeOutView createCustomPromptViewWithTitle:@"提示" Content:@"您的登录状态已失效, 请重新登录 !" SureButtonTitle:@"重新登录" SureHandler:^(id sure) {
            
            self.isHave = YES;
            completion(YES);
            
        } RemoveHandler:^(id remove) {
            
            self.isHave = YES;
            //如果没有进入登录页面, 直接移除用户信息
            [GetUserInfo deleteUserModelInCache];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changTabBarChildController" object:nil];
            
        }];
    }

}

@end
