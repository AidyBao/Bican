//
//  MineLoginView.h
//  Bican
//
//  Created by bican on 2018/1/3.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineLoginViewDelegate <NSObject>

- (void)seePasswordAndPushWithTag:(NSInteger)tag Button:(UIButton *)button;

@end

@interface MineLoginView : UIView 

@property (nonatomic, assign) id <MineLoginViewDelegate> delegate;

@property (nonatomic, strong) UIButton *visibleButton;
@property (nonatomic, strong) UIButton *invisibleButton;

@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *forgetPasswordButton;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) UIImageView *userImage;
@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UIImageView *passwordImage;

@property (nonatomic, strong) UIView *phoneLineView;
@property (nonatomic, strong) UIView *passwordLineView;

@property (nonatomic, strong) UIView *middleView;

@end

