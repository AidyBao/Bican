//
//  ZTBaseTabBarController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTBaseTabBarController.h"
#import "ZTBaseTabBar.h"
#import "ZTBaseNavigationController.h"
#import "ViewController.h"
#import "FindViewController.h"//发现
#import "MissionTeacherViewController.h"//任务-老师端
//#import "MineStudentViewController.h"//任务学生端
#import "WriteViewController.h"//写作文
//#import "MessageViewController.h"
#import "InformationViewController.h"//消息
#import "MineLoginViewController.h"
#import "MineNoLoginViewController.h"//我的-未登录
#import "MineTeacherViewController.h"//我的-老师端
//#import "MissionStudentViewController.h"//我的-学生端

@interface ZTBaseTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) ZTBaseTabBar *baseTabBar;

@end

@implementation ZTBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建TabBar
    [self createTabBar];

    
}

#pragma mark - 创建TabBar
- (void)createTabBar
{
    self.baseTabBar = [[ZTBaseTabBar alloc] init];
    //字体颜色
    self.baseTabBar.tintColor = RGBA(112, 112, 112, 1);
    //透明设置为NO，显示白色，view的高度到tabbar顶部截止，YES的话到底部
    self.baseTabBar.translucent = NO;
    //利用KVC 将自己的tabbar赋给系统tabBar
    [self setValue:self.baseTabBar forKeyPath:@"tabBar"];

    self.delegate = self;
    
    [self addChildViewControllers];
    
}

- (void)changTabBarChildController
{
    
    //判断是否登录
    ZTBaseNavigationController *baseNav = [self.viewControllers objectAtIndex:3];
    if ([GetUserInfo judgIsloginByUserModel]) {
        
        MineTeacherViewController *mineTeacherVC = [[MineTeacherViewController alloc] init];
        [self addChildrenWithViewController:mineTeacherVC Title:@"我的" ImageName:@"tab_4" SelectImage:@"tab_4A"];
        [baseNav setViewControllers:@[mineTeacherVC] animated:NO];
        

    } else {
        MineNoLoginViewController *NoLoginVC = [[MineNoLoginViewController alloc] init];
        [self addChildrenWithViewController:NoLoginVC Title:@"我的" ImageName:@"tab_4" SelectImage:@"tab_4A"];
        [baseNav setViewControllers:@[NoLoginVC] animated:NO];
    }

}


#pragma mark - 添加子控制器
- (void)addChildViewControllers
{
    FindViewController *findVC = [[FindViewController alloc] init];
    [self addChildrenWithViewController:findVC Title:@"发现" ImageName:@"tab_1" SelectImage:@"tab_1A"];
    ZTBaseNavigationController *findBaseNav = [[ZTBaseNavigationController alloc] initWithRootViewController:findVC];
    [self addChildViewController:findBaseNav];
    
    MissionTeacherViewController *missionVC = [[MissionTeacherViewController alloc] init];
    [self addChildrenWithViewController:missionVC Title:@"任务" ImageName:@"tab_2" SelectImage:@"tab_2A"];
    ZTBaseNavigationController *missionBaseNav = [[ZTBaseNavigationController alloc] initWithRootViewController:missionVC];
    [self addChildViewController:missionBaseNav];
    
//    //中间这个不设置，只占位
//    [self addChildrenWithViewController:[[WriteViewController alloc] init] Title:@"" ImageName:@"" SelectImage:@""];

    InformationViewController *informationVC = [[InformationViewController alloc] init];
    [self addChildrenWithViewController:informationVC Title:@"消息" ImageName:@"tab_3" SelectImage:@"tab_3A"];
    ZTBaseNavigationController *informationBaseNav = [[ZTBaseNavigationController alloc] initWithRootViewController:informationVC];
    [self addChildViewController:informationBaseNav];
    
    //判断是否登录
    if ([GetUserInfo judgIsloginByUserModel]) {
        MineTeacherViewController *mineTeacherVC = [[MineTeacherViewController alloc] init];
        [self addChildrenWithViewController:mineTeacherVC Title:@"我的" ImageName:@"tab_4" SelectImage:@"tab_4A"];
        ZTBaseNavigationController *mineTeacherBaseNav = [[ZTBaseNavigationController alloc] initWithRootViewController:mineTeacherVC];
        [self addChildViewController:mineTeacherBaseNav];

    } else {
        MineNoLoginViewController *mineNoLoginVC = [[MineNoLoginViewController alloc] init];
        [self addChildrenWithViewController:mineNoLoginVC Title:@"我的" ImageName:@"tab_4" SelectImage:@"tab_4A"];
        ZTBaseNavigationController *mineNoLoginBaseNav = [[ZTBaseNavigationController alloc] initWithRootViewController:mineNoLoginVC];
        [self addChildViewController:mineNoLoginBaseNav];
    }

    //通知
    //发现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToFind) name:@"jumpToFind" object:nil];
    //任务
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToMission) name:@"jumpToMission" object:nil];
    //消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToMessage) name:@"jumpToMessage" object:nil];
    //我的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToMine) name:@"jumpToMine" object:nil];
    //改变tabbar
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changTabBarChildController) name:@"changTabBarChildController" object:nil];


    
}

#pragma makr - 发现
- (void)jumpToFind
{
    self.selectedIndex = 0;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //移除window上，比如AlertView之类的弹框视图
    for (UIView *view in window.subviews) {
        if (![view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
            [view removeFromSuperview];
        }
    }
}

#pragma makr - 任务
- (void)jumpToMission
{
    self.selectedIndex = 1;
}

#pragma makr - 消息
- (void)jumpToMessage
{
    self.selectedIndex = 2;
}

#pragma makr - 我的
- (void)jumpToMine
{
    self.selectedIndex = 3;
}


#pragma mark - 设置样式
- (void)addChildrenWithViewController:(UIViewController *)childVC
                                Title:(NSString *)title
                            ImageName:(NSString *)imageName
                          SelectImage:(NSString *)selectedImage
{
    childVC.tabBarItem.title = title;
    //UIImageRenderingMode不设置, 无法显示图片
    childVC.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (![childVC isKindOfClass:[FindViewController class]]) {
        childVC.title = title;
    }


}

#pragma mark - 点击任务和消息, 跳转登录
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (![GetUserInfo judgIsloginByUserModel]) {
        if ([viewController.tabBarItem.title isEqualToString:@"发现"] ||
            [viewController.tabBarItem.title isEqualToString:@"我的"]) {
            return YES;
        }
        MineLoginViewController *loginVC = [[MineLoginViewController alloc] init];
        [[self getCurrentNavigaitonController] pushViewController:loginVC animated:YES];
        [ZTToastUtils showToastIsAtTop:NO Message:@"请先登录" Time:3.0];
        return NO;
    }
    return YES;
}

//获取当前的导航控制器
- (ZTBaseNavigationController *)getCurrentNavigaitonController {
    ZTBaseNavigationController *navVC = (ZTBaseNavigationController *)self.selectedViewController;
    return navVC;
}

#pragma mark - 获取颜色
- (UIColor *)getColor:(NSString*)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red / 255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpToFind" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpToMission" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpToMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"jumpToMine" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changTabBarChildController" object:nil];

}


@end
