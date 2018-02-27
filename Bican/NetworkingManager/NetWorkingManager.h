//
//  NetWorkingManager.h
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SuccessWithIndexBlock)(id resultObject, NSInteger index);
typedef void (^SuccessBlock)(id resultObject);
typedef void (^FailsureBlock)(NSError *error);
typedef void (^ReloadDataBlock)(BOOL isReload);

@interface NetWorkingManager : NSObject
/**
 *  get网络请求
 *
 *  @param urlString  url
 *  @param success    成功回调
 *  @param failsure   失败回调
 *  @param reload     刷新回调
 */
+ (void)getWithUrlStr:(NSString *)urlString
      successHandler:(SuccessBlock)success
        errorHandler:(FailsureBlock)failsure
        reloadHandler:(ReloadDataBlock)reload;

/**
 *  post网络请求
 *
 *  @param urlString  url
 *  @param params     参数
 *  @param params_ext 附加参数
 *  @param success    成功回调
 *  @param failsure   失败回调
 *  @param reload     刷新回调
 */
+ (void)postWithUrlStr:(NSString *)urlString
                 token:(NSString *)token
                params:(NSDictionary *)params
            params_ext:(NSDictionary *)params_ext
        successHandler:(SuccessBlock)success
          errorHandler:(FailsureBlock)failsure
         reloadHandler:(ReloadDataBlock)reload;


+ (void)postWithIndexStr:(NSInteger)indexStr
                  UrlStr:(NSString *)urlString
                   token:(NSString *)token
                  params:(NSDictionary *)params
              params_ext:(NSDictionary *)params_ext
          successHandler:(SuccessWithIndexBlock)success
            errorHandler:(FailsureBlock)failsure
           reloadHandler:(ReloadDataBlock)reload;

@end
