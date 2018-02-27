//
//  AppDelegate.m
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "AppDelegate.h"
#import "ZTBaseTabBarController.h"
#import "HDYLaunchAdView.h"
#import "UMessage.h"
#import <Realm/Realm.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property (nonatomic, strong) NSMutableArray *provinceArray;

@end

@implementation AppDelegate

- (NSMutableArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [NSMutableArray array];
    }
    return _provinceArray;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置Realm数据库
    [self setRealm];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    //设置控制器
    ZTBaseTabBarController *baseTabBarC = [[ZTBaseTabBarController alloc] init];
    self.window.rootViewController = baseTabBarC;
    
    [self.window makeKeyAndVisible];

    //请求省市区的字典
    [self sys_qrydict_zaxy];
    //启动广告页
    [HDYLaunchAdView showLaunchAdView];
    
    //清空badge
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    
    //集成友盟推送
    [self UMessageWithLaunchOptions:launchOptions];

    
    return YES;
}

#pragma mark - Realm数据库
- (void)setRealm
{
    RLMRealmConfiguration *rlmconfig = [RLMRealmConfiguration defaultConfiguration];
    // 设置新的架构版本。这个版本号必须高于之前所用的版本号（如果您之前从未设置过架构版本，那么这个版本号设置为 0）
    rlmconfig.schemaVersion = 2;
    // 设置闭包，这个闭包将会在打开低于上面所设置版本号的 Realm 数据库的时候被自动调用
    rlmconfig.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
        if (oldSchemaVersion < 2) {
            // 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构
        }
    };
    // 告诉 Realm 为默认的 Realm 数据库使用这个新的配置对象
    [RLMRealmConfiguration setDefaultConfiguration:rlmconfig];
    
    // 现在我们已经告诉了 Realm 如何处理架构的变化，打开文件之后将会自动执行迁移
    [RLMRealm defaultRealm];
    
}

#pragma mark - 集成友盟推送
- (void)UMessageWithLaunchOptions:(NSDictionary *)launchOptions
{
    //友盟推送
    [UMessage startWithAppkey:UM_APPKEY launchOptions:launchOptions];
    [UMessage registerForRemoteNotifications];
    
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions types = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //允许推送
            } else {
                //不允许推送
            }
            
        }];
    } else {
        // Fallback on earlier versions
    }
    
    [UMessage setLogEnabled:YES];
    
    //推送注册
    //    [[UIApplication sharedApplication] registerForRemoteNotifications];
    //    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
}

//注册deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];
}


//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭U-Push自带的弹出框
    [UMessage setAutoAlert:NO];
    [UMessage didReceiveRemoteNotification:userInfo];
    
    //    self.userInfo = userInfo;
    //    //定制自定的的弹出框
    //    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    //    {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"标题"
    //                                                            message:@"Test On ApplicationStateActive"
    //                                                           delegate:self
    //                                                  cancelButtonTitle:@"确定"
    //                                                  otherButtonTitles:nil];
    //
    //        [alertView show];
    //
    //    }
}


//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于前台时的远程推送接受
            //关闭U-Push自带的弹出框
            [UMessage setAutoAlert:NO];
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
        }else{
            //应用处于前台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
    } else {
        // Fallback on earlier versions
    }
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于后台时的远程推送接受
            //必须加这句代码
            [UMessage didReceiveRemoteNotification:userInfo];
            
        }else{
            //应用处于后台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
}





#pragma mark - 程序将要被挂起(电话进来或者锁屏)
- (void)applicationWillResignActive:(UIApplication *)application
{
    
}


#pragma mark - 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

#pragma mark - 将要重新回到前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //清空badge
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

#pragma mark - 已经重新回到前台
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

#pragma mark - 程序手动被杀死
- (void)applicationWillTerminate:(UIApplication *)application
{
    
}


#pragma mark - 查询数据字典(省市区学校)
- (void)sys_qrydict_zaxy
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/sys/provinceAndCity", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.provinceArray removeAllObjects];
        
        if ([[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            NSMutableArray *array = [resultObject objectForKey:@"data"];
            
            for (NSMutableDictionary *dic in array) {
                NSMutableArray *new_cityArray = [NSMutableArray array];
                NSMutableArray *cityArray = [dic objectForKey:@"cityList"];
                for (NSMutableDictionary *cityDic in cityArray) {
                    CityModel *cityModel = [[CityModel alloc] init];
                    [cityModel setValuesForKeysWithDictionary:cityDic];
                    [new_cityArray addObject:cityModel];
                }
                ProvinceModel *model = [[ProvinceModel alloc] init];
                model.cityList = (RLMArray *)new_cityArray;
                model.provinceName = [dic objectForKey:@"provinceName"];
                model.provinceId = [dic objectForKey:@"provinceId"];
                [self.provinceArray addObject:model];
            }
            //存入 - 数据字典
            [GetProvinceDataManager saveDataDicRealmWith:(NSArray *)self.provinceArray];
        }

        
    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {

        
    }];
 
}

@end
