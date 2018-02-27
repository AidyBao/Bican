//
//  MineHeaderView.h
//  Bican
//
//  Created by chichen on 2017/12/24.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineHeaderViewDelegate <NSObject>
// 跳转到账户页面
- (void)pushToAccountsVC;

@end

@interface MineHeaderView : UIView
//传值：头像，名字，学校，班级
- (void)setMineHeaderViewWithHeaderImage:(NSString *)headerImage
                                    Name:(NSString *)name
                                  School:(NSString *)school
                               ClassName:(NSString *)className;

@property (nonatomic, assign) id <MineHeaderViewDelegate> delegate;

@end

