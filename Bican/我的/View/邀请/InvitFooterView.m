//
//  InvitFooterView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/25.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "InvitFooterView.h"

@interface InvitFooterView ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *noButton;
@property (nonatomic, strong) UIButton *askButton;

@end

@implementation InvitFooterView

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
    self.backgroundColor = ZTOrangeColor;
}
#pragma mark - 文字 || 文字 + askButton
- (void)createInvitFooterViewWithTitle:(NSString *)title
                                 Color:(UIColor *)color
                       IsShowAskButton:(BOOL)isShowAskButton
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    if (isShowAskButton) {
        self.askButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.askButton setImage:[UIImage imageNamed:@"doubt"] forState:UIControlStateNormal];
        [self.askButton addTarget:self action:@selector(askButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.askButton];
        
        [self.askButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(GTW(-30));
            make.width.height.mas_equalTo(GTH(31));
        }];

    }
    
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = title;
    self.contentLabel.font = FONT(30);
    self.contentLabel.textColor = color;
    [self addSubview:self.contentLabel];
    
    if (isShowAskButton) {
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(GTW(30));
            make.top.height.equalTo(self);
            make.right.equalTo(self.askButton.mas_left).offset(GTW(-30));
        }];
        
    } else {
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(GTW(30));
            make.top.height.equalTo(self);
            make.right.equalTo(self).offset(GTW(-30));
        }];
    }
    
    
    
    
}

#pragma mark - 文字 + 一个按钮
- (void)createInvitFooterViewWithTitle:(NSString *)title
                            TitleColor:(UIColor *)titleColor
                           ButtonTitle:(NSString *)buttonTitle
{
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = title;
    self.contentLabel.font = FONT(30);
    self.contentLabel.textColor = titleColor;
    [self addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.top.height.equalTo(self);
        make.right.equalTo(self).offset(GTW(-30));
    }];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:buttonTitle forState:UIControlStateNormal];
    [self.sureButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = FONT(30);
    self.sureButton.layer.borderColor = ZTTitleColor.CGColor;
    self.sureButton.layer.cornerRadius = GTH(10);
    self.sureButton.layer.borderWidth = 1;
    [self.sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sureButton];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(GTW(-30));
        make.height.mas_equalTo(GTH(40));
        make.width.mas_equalTo(GTW(150));
    }];
    
    
}

#pragma mark - 文字 + 两个按钮
- (void)createInvitFooterViewWithTitle:(NSString *)title
                            TitleColor:(UIColor *)titleColor
                       SureButtonTitle:(NSString *)sureButtonTitle
                         NoButtonTitle:(NSString *)noButtonTitle
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setTitle:sureButtonTitle forState:UIControlStateNormal];
    [self.sureButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.sureButton.titleLabel.font = FONT(30);
    self.sureButton.layer.borderColor = ZTTitleColor.CGColor;
    self.sureButton.layer.cornerRadius = GTH(10);
    self.sureButton.layer.borderWidth = 1;
    [self.sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sureButton];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(GTW(-30));
        make.height.mas_equalTo(GTH(40));
        make.width.mas_equalTo(GTW(120));
    }];
    
    self.noButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.noButton setTitle:noButtonTitle forState:UIControlStateNormal];
    [self.noButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.noButton.titleLabel.font = FONT(30);
    self.noButton.layer.borderColor = ZTTitleColor.CGColor;
    self.noButton.layer.cornerRadius = GTH(10);
    self.noButton.layer.borderWidth = 1;
    [self.noButton addTarget:self action:@selector(noButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.noButton];
    
    [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self.sureButton.mas_left).offset(GTW(-90));
        make.height.mas_equalTo(GTH(40));
        make.width.mas_equalTo(GTW(120));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = title;
    self.contentLabel.font = FONT(30);
    self.contentLabel.textColor = titleColor;
    [self addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.top.height.equalTo(self);
        make.right.equalTo(self.noButton.mas_left).offset(GTW(-30));
    }];
    
}



- (void)askButtonAction
{
    if ([self.delegate respondsToSelector:@selector(buttonToAskWithView:)]) {
        [self.delegate buttonToAskWithView:self];
    }
}


- (void)sureButtonAction
{
    if ([self.delegate respondsToSelector:@selector(buttonToSureWithView:)]) {
        [self.delegate buttonToSureWithView:self];
    }
}

- (void)noButtonAction
{
    if ([self.delegate respondsToSelector:@selector(buttonToNoWithView:)]) {
        [self.delegate buttonToNoWithView:self];
    }
}




@end
