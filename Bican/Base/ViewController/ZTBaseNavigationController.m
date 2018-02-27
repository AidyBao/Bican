//
//  ZTBaseNavigationController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTBaseNavigationController.h"
#import "FindViewController.h"
#import "MineTeacherViewController.h"
#import "MineStudentViewController.h"
#import "MineNoLoginViewController.h"

@interface ZTBaseNavigationController ()

@end

@implementation ZTBaseNavigationController

+ (void)initialize
{
    UINavigationBar *customBar = [UINavigationBar appearance];
    [customBar setBarTintColor:ZTNavColor];
    [customBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:GTH(30)],
       NSForegroundColorAttributeName:ZTTitleColor}];
    [customBar setShadowImage:[UIImage new]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBackgroundImage:[self createImageWithColor:ZTNavColor] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = YES;
    
}

#pragma mark - 在跳转后自动隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([self.viewControllers count] > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"return"] forState:UIControlStateHighlighted];
        button.size = CGSizeMake(30, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        ZTBaseViewController *baseVC = self.viewControllers.firstObject;
        if ([baseVC isKindOfClass:[FindViewController class]] || [baseVC isKindOfClass:[MineTeacherViewController class]] || [baseVC isKindOfClass:[MineStudentViewController class]] || [baseVC isKindOfClass:[MineNoLoginViewController class]]) {
            viewController.navigationController.navigationBarHidden = YES;
        } else {
            viewController.navigationController.navigationBarHidden = NO;
        }
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //一定要写在最后，要不然无效
    [super pushViewController:viewController animated:animated];
    CGRect rect = self.tabBarController.tabBar.frame;
    rect.origin.y = [UIScreen mainScreen].bounds.size.height - rect.size.height;
    self.tabBarController.tabBar.frame = rect;
    
}

- (void)popBack
{
    [self popViewControllerAnimated:YES];
    
}

#pragma mark - 创建导航栏背景颜色的图片
- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, ScreenWidth, NAV_HEIGHT);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

#pragma mark - 设置状态栏字体为黑色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


@end
