//
//  LoginTimeOutView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/15.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "LoginTimeOutView.h"
//最大的宽
#define MAX_WIDTH   ScreenWidth - GTW(30) * 3 - GTW(90) * 2

@interface LoginTimeOutView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic,copy) void (^sureBlock)(LoginTimeOutView *loginTimeOutView);
@property (nonatomic,copy) void (^removeBlock)(LoginTimeOutView *loginTimeOutView);

@end

@implementation LoginTimeOutView

+ (instancetype)createCustomPromptViewWithTitle:(NSString *)title
                                        Content:(NSString *)content
                                SureButtonTitle:(NSString *)sureButtonTitle
                                    SureHandler:(SureButtonBlock)sure
                                  RemoveHandler:(RemoveButtonBlock)remove

{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in window.subviews) {
        if ([view isKindOfClass:[LoginTimeOutView class]]) {
            return nil;
        }
    }
    LoginTimeOutView *loginTimeOutView = [[LoginTimeOutView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [loginTimeOutView setLoginTimeOutViewWithTitle:title Content:content ButtonTitle:sureButtonTitle];
    [window addSubview:loginTimeOutView];
    
    loginTimeOutView.sureBlock = sure;
    loginTimeOutView.removeBlock = remove;
    
    return loginTimeOutView;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.5;
    [self addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(ScreenHeight);
    }];
    
    UIControl *backViewControl = [[UIControl alloc] init];
    [backViewControl addTarget:self action:@selector(backViewControlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:backViewControl];
    
    [backViewControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self.backView);
    }];
    
    self.centerView = [[UIView alloc] init];
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.cornerRadius = GTH(20);
    self.centerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.centerView];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(90));
        make.right.equalTo(self.mas_right).offset(GTW(-90));
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(GTH(300));
    }];
    
}

- (void)backViewControlAction
{
    //如果是Block返回的类型
    if(_removeBlock != nil) {
        _removeBlock(self);
    }
    [self removeFromSuperview];
}

- (void)setLoginTimeOutViewWithTitle:(NSString *)title
                             Content:(NSString *)content
                         ButtonTitle:(NSString *)buttonTitle
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = title;
    self.titleLabel.font = FONT(30);
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top).offset(GTH(30));
        make.height.mas_equalTo(GTH(60));
        make.left.equalTo(self.mas_left).offset(GTW(90) + GTW(30));
        make.right.equalTo(self.mas_right).offset(-GTW(90) - GTW(30));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = content;
    self.contentLabel.textColor = ZTTitleColor;
    self.contentLabel.font = FONT(26);
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
    
    //计算内容高度
   CGSize contentSize = [self.contentLabel getSizeWithString:content font:self.contentLabel.font str_width:MAX_WIDTH];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(30));
        make.centerX.equalTo(self.titleLabel);
        make.width.mas_equalTo(MAX_WIDTH);
        make.height.mas_equalTo(contentSize.height);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(90));
        make.right.equalTo(self.mas_right).offset(GTW(-90));
        make.top.equalTo(self.contentLabel.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(1);
    }];

    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sureButton.layer.masksToBounds = YES;
    self.sureButton.layer.cornerRadius = GTH(10);
    [self.sureButton setBackgroundColor:ZTOrangeColor];
    self.sureButton.titleLabel.font = FONT(26);
    [self.sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sureButton];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.lineView.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(GTH(60));
        make.width.mas_equalTo(GTW(150));
    }];
    
    //更新centerView的高
    [self.centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(GTH(30) * 4 + 1 + GTH(90) + GTH(60) + contentSize.height);
    }];
    
    
}

#pragma mark - 确认按钮
- (void)sureButtonAction
{
    //如果是Block返回的类型
    if(_sureBlock != nil) {
        _sureBlock(self);
    }
    if ((self.delegate != nil) && [self.delegate respondsToSelector:@selector(buttonToPush)]) {
        [self.delegate buttonToPush];
    }
    [self removeFromSuperview];
    
}



@end
