//
//  HDYLaunchAdView.m
//  RTFundProject
//
//  Created by hedy on 2017/1/19.
//  Copyright © 2017年 rtfund. All rights reserved.
//

#import "HDYLaunchAdView.h"

@interface HDYLaunchAdView()

@property (nonatomic, strong) UIView *backGroundImage;//背景图片
@property (nonatomic, strong) UIImageView *adImageView;//广告视图
@property (nonatomic, strong) NSTimer *timer;//获取倒计时
@property (nonatomic, assign) NSInteger integerOfTime;//倒计时秒数

- (void)initializeUserInterface;

@end

@implementation HDYLaunchAdView

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeUserInterface];
    }
    return self;
}

+ (void)showLaunchAdView
{
    HDYLaunchAdView *launchView = [[HDYLaunchAdView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [[UIApplication sharedApplication].keyWindow addSubview:launchView];
    
}

#pragma mark - 获取倒计时
- (void)countDownSecond
{
    _integerOfTime -= 1;
    if (_integerOfTime == 0) {
        [self.timer setFireDate:[NSDate distantFuture]];
        self.timer = nil;
        [self removeFromSuperview];
    }
}


#pragma mark - 初始化界面
- (void)initializeUserInterface
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownSecond) userInfo:nil repeats:YES];
    
    self.integerOfTime = 5;
    [self.timer setFireDate:[NSDate distantPast]];
    
    NSString *launchImageName = @"启动页640x960";
    if (ScreenHeight == 480) {      //4,4s机型
        launchImageName = @"启动页640x960";
    }
    else if (ScreenHeight == 568) { //5,5S机型
        launchImageName = @"启动页640x1136";
    }
    else if (ScreenHeight == 667) { //6,6S,7,7s机型
        launchImageName = @"启动页750x1334";
    }
    else if (ScreenHeight == 736) { //6,6S,7,7s plus 机型
        launchImageName = @"启动页1242x2208";
    }
    else if (ScreenHeight > 736) {  //iPhone X机型
        launchImageName = @"启动页1125x2436";
    }
    
    //创建背景view
    self.backGroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImageName]];
    self.backGroundImage.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.backGroundImage];
    
    //添加广告imageView
    self.adImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.adImageView.image = [UIImage imageNamed:launchImageName];
    self.adImageView.userInteractionEnabled = YES;
    [self addSubview:self.adImageView];

    
}

@end
