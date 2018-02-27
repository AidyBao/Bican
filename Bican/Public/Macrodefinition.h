//
//  Macrodefinition.h
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#ifndef Macrodefinition_h
#define Macrodefinition_h

//BASE_URL(拼接)
//正式环境
//#define BASE_URL    @"http://www.fmbican.com:8080/bican_interface/"
//#define BASE_URL    @"http://www.fmbican.com:8089/bican_pc/"
//测试环境
#define BASE_URL    @"http://139.199.13.161:8080/bican_interface/"

#define TOKEN    @"-19"

#define weakify(var)   __weak typeof(var) weakSelf = var
#define strongify(var) __strong typeof(var) strongSelf = var

//色值RGB
#define RGBA(r,g,b,a) [UIColor colorWithRed:((float)r)/255.f green:((float)g)/255.f blue:((float)b)/255.f alpha:a]

#define ZTNavColor            RGBA(249, 249, 249, 1)    //主色调 - 导航栏背景色
#define ZTOrangeColor         RGBA(255, 210, 0, 1)      //主色调 - 橘黄色
#define ZTLightOrangeColor    RGBA(255, 247, 153, 1)    //主色调 - 标注橘黄色
#define ZTAlphaColor          RGBA(235, 235, 235, 1)    //主色调 - 透明色
#define ZTTextGrayColor       RGBA(112, 112, 112, 1)    //主色调 - 文字颜色(灰)
#define ZTTextLightGrayColor  RGBA(171, 171, 171, 1)    //主色调 - 文字颜色(浅灰)
#define ZTGrayColor           RGBA(210, 210, 210, 1)    //主色调 - 其他灰色
#define ZTLineGrayColor       RGBA(227, 227, 227, 1)    //主色调 - 分割线颜色(浅灰)
#define ZTTitleColor          RGBA(51, 51, 51, 1)       //主色调 - 标题颜色(黑色)
#define ZTBlueColor           RGBA(88, 151, 255, 1)     //主色调 - 标题颜色(黑色)
#define ZTRedColor            RGBA(255, 108, 108, 1)    //主色调 - 警告颜色(红色)
#define ZTDarkRedColor        RGBA(208, 32, 32, 1)      //主色调 - 提示颜色(深红色)

//屏幕宽度
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
//屏幕高度
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
//宽度、高度
#define iPhoneX         ((ScreenHeight >= 812)?YES:NO)
#define TABBAR_HEIGHT   (iPhoneX?83:49)
#define NAV_HEIGHT      (iPhoneX?88:64)
#define SafeBottom      (iPhoneX?34:0)
#define ZeroOffset      (iPhoneX?24:0)


//适配系数 基准设计图为360pt*640pt x和y为给出的实际像素值，参考设计图为1080*1920像素
#define GTW(x)      (int)(float)x/2.0*WidthScale
#define GTH(y)      (int)(float)y/2.0*HeightScale
#define WidthScale  ScreenWidth/360.0
#define HeightScale ScreenHeight/640.0
//传入像素值获取以宽度或高度为参考的字体大小
#define FONT(x) [UIFont systemFontOfSize:(float)x/2.0*WidthScale]

//获取当前ios版本
#define IOS [[[UIDevice currentDevice] systemVersion] floatValue]
//app 版本号 (当前项目)
#define APPVERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//友盟
#define UM_APPKEY    @"5a5ac746b27b0a773600056e"

//通用提示文案
#define NoNetworkNotifyMessage @"网络异常，请检查你的网络设置！"
#define NoServerFeedBackInfo @"抱歉，服务正在升级，客官请稍后再来！"
#define TokenNoEffectNotifyMessage @"登录失效，即将跳转重新登录..."


#endif /* Macrodefinition_h */
