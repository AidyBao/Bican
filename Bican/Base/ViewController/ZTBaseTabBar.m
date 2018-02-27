//
//  ZTBaseTabBar.m
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTBaseTabBar.h"

@implementation ZTBaseTabBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
//    //背景
//    self.backView = [[UIView alloc] init];
//    self.backView.frame = CGRectMake((ScreenWidth - GTW(140)) / 2.0, 0, GTW(140), TABBAR_HEIGHT + GTH(10) * 3);
//    self.backView.backgroundColor = [UIColor whiteColor];
//    self.backView.layer.cornerRadius = GTH(20);
//    self.backView.layer.borderColor = ZTAlphaColor.CGColor;
//    self.backView.layer.borderWidth = 1.0f;
//    [self addSubview:self.backView];
//
//
//    //图片
//    self.centerImageView = [[UIImageView alloc] init];
//    UIImage *normalImage = [UIImage imageNamed:@"tab_center"];
//    self.centerImageView.frame = CGRectMake(self.backView.frame.origin.x + (self.backView.frame.size.width - normalImage.size.width) / 2, (self.backView.frame.size.height - normalImage.size.height) / 2 - GTH(10), normalImage.size.width, normalImage.size.height);
//    self.centerImageView.image = normalImage;
//    [self addSubview:self.centerImageView];

    
}

#pragma mark - 处理超出区域点击无效的问题
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil){
        //转换坐标
        CGPoint tempPoint = [self.centerImageView convertPoint:point fromView:self];
        //判断点击的点是否在按钮区域内
        if (CGRectContainsPoint(self.centerImageView.bounds, tempPoint)){
            //返回按钮
            return _centerImageView;
        }
    }
    return view;
}



@end
