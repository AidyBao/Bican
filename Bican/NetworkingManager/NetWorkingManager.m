//
//  NetWorkingManager.m
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "NetWorkingManager.h"
#import <AFNetworking.h>
#import "NSDictionary+Extention.h"

@implementation NetWorkingManager

+ (void)getWithUrlStr:(NSString *)urlString
       successHandler:(SuccessBlock)success
         errorHandler:(FailsureBlock)failsure
        reloadHandler:(ReloadDataBlock)reload
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置网络请求超时时间
    manager.requestSerializer.timeoutInterval = 15.0;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
            NSString *status = [responseObject objectForKey:@"status"];
            //校验token是否过期
            [[CheckLoginOutManager checkManager] toCheckIsLoginOutWithStatus:status UrlString:urlString completion:^(BOOL isShow) {
                
                reload(YES);
                
            }];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请检查网络连接后重试" Time:3.0];
        reload(NO);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }];

    
}


+ (void)postWithUrlStr:(NSString *)urlString
                 token:(NSString *)token
                params:(NSDictionary *)params
            params_ext:(NSDictionary *)params_ext
        successHandler:(SuccessBlock)success
          errorHandler:(FailsureBlock)failsure
         reloadHandler:(ReloadDataBlock)reload
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置网络请求超时时间
    manager.requestSerializer.timeoutInterval = 15.0;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    if (params != nil) {
        parameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        NSArray *tempArray = [params allValues];
        NSString *valueStr = [parameters objectForKey:@"userId"];
        //如果外面没有传userId
        if (![tempArray containsObject:valueStr]) {
            NSString *userId = [NSString string];
            if ([GetUserInfo getUserInfoModel].userId.length == 0 || [[GetUserInfo getUserInfoModel].roleType isEqualToString:@"1"]) {
                userId = @"-1";
            } else {
                userId = [GetUserInfo getUserInfoModel].userId;
            }
            [parameters setValue:userId forKey:@"userId"];
        }
        //将token, timestamp, userId加入字段中
        NSString *tokenStr = [NSString string];
        if ([GetUserInfo getUserInfoModel].token.length == 0) {
            tokenStr = token;
        } else {
            tokenStr = [GetUserInfo getUserInfoModel].token;
        }
        [parameters setValue:tokenStr forKey:@"token"];
        [parameters setValue:[NSDictionary time] forKey:@"timestamp"];
        //生成sign
        NSString *string = [NSDictionary nsstringWithDictionary:parameters];
        NSString *StrFor = [string substringToIndex:string.length-1];
        // 参数 + "bicanobject" + 用户token;
        NSString *newStr = [NSString stringWithFormat:@"{%@}bicanobject%@", StrFor, tokenStr];
        NSString *Md5String = [NSDictionary md5:newStr];
        [parameters setValue:[Md5String uppercaseString] forKey:@"sign"];
        [parameters setValue:[NSDictionary time] forKey:@"timestamp"];
        [parameters setValue:tokenStr forKey:@"token"];
        [parameters removeObjectForKey:@"key"];
    }
    NSLog(@"parameters = %@", parameters);

    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success(responseObject);
            NSString *status = [responseObject objectForKey:@"status"];
            //校验token是否过期
            [[CheckLoginOutManager checkManager] toCheckIsLoginOutWithStatus:status UrlString:urlString completion:^(BOOL isShow) {
                
                reload(YES);
                
            }];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请检查网络连接后重试" Time:3.0];
        reload(NO);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    
}

+ (void)postWithIndexStr:(NSInteger)indexStr
                  UrlStr:(NSString *)urlString
                   token:(NSString *)token
                  params:(NSDictionary *)params
              params_ext:(NSDictionary *)params_ext
          successHandler:(SuccessWithIndexBlock)success
            errorHandler:(FailsureBlock)failsure
           reloadHandler:(ReloadDataBlock)reload
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //设置网络请求超时时间
    manager.requestSerializer.timeoutInterval = 15.0;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    if (params != nil) {
        parameters = [NSMutableDictionary dictionaryWithDictionary:params];
        
        NSArray *tempArray = [params allValues];
        NSString *valueStr = [parameters objectForKey:@"userId"];
        //如果外面没有传userId
        if (![tempArray containsObject:valueStr]) {
            NSString *userId = [NSString string];
            if ([GetUserInfo getUserInfoModel].userId.length == 0 || [[GetUserInfo getUserInfoModel].roleType isEqualToString:@"1"]) {
                userId = @"-1";
            } else {
                userId = [GetUserInfo getUserInfoModel].userId;
            }
            [parameters setValue:userId forKey:@"userId"];
        }
        //将token, timestamp, userId加入字段中
        NSString *tokenStr = [NSString string];
        if ([GetUserInfo getUserInfoModel].token.length == 0) {
            tokenStr = token;
        } else {
            tokenStr = [GetUserInfo getUserInfoModel].token;
        }
        [parameters setValue:tokenStr forKey:@"token"];
        [parameters setValue:[NSDictionary time] forKey:@"timestamp"];
        //生成sign
        NSString *string = [NSDictionary nsstringWithDictionary:parameters];
        NSString *StrFor = [string substringToIndex:string.length-1];
        // 参数 + "bicanobject" + 用户token;
        NSString *newStr = [NSString stringWithFormat:@"{%@}bicanobject%@", StrFor, tokenStr];
        NSString *Md5String = [NSDictionary md5:newStr];
        [parameters setValue:[Md5String uppercaseString] forKey:@"sign"];
        [parameters setValue:[NSDictionary time] forKey:@"timestamp"];
        [parameters setValue:tokenStr forKey:@"token"];
        [parameters removeObjectForKey:@"key"];
    }
    NSLog(@"parameters = %@", parameters);
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            success(responseObject, indexStr);
            NSString *status = [responseObject objectForKey:@"status"];
            //校验token是否过期
            [[CheckLoginOutManager checkManager] toCheckIsLoginOutWithStatus:status UrlString:urlString completion:^(BOOL isShow) {
                
                reload(YES);
                
            }];
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请检查网络连接后重试" Time:3.0];
        reload(NO);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    }];
    
    
}


@end
