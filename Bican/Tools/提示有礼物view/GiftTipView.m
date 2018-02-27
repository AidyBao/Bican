//
//  GiftTipView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "GiftTipView.h"

@interface GiftTipView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *flowerImageView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *checkButton;

@end

@implementation GiftTipView

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
        make.left.right.top.bottom.equalTo(self);
    }];

    self.flowerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hua_liwu"]];
    [self addSubview:self.flowerImageView];
    
    [self.flowerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(GTH(458), GTH(458)));
    }];
    
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.checkButton setTitle:@"查看详情" forState:UIControlStateNormal];
    [self.checkButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    [self.checkButton setBackgroundColor:[UIColor blackColor]];
    self.checkButton.titleLabel.font = FONT(28);
    self.checkButton.layer.masksToBounds = YES;
    self.checkButton.layer.cornerRadius = GTH(10);
    self.checkButton.layer.borderColor = ZTOrangeColor.CGColor;
    self.checkButton.layer.borderWidth = 1;
    [self.checkButton addTarget:self action:@selector(checkButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.checkButton];
    
    [self.checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flowerImageView.mas_bottom).offset(GTH(60));
        make.centerX.equalTo(self.flowerImageView);
        make.size.mas_equalTo(CGSizeMake(GTW(150), GTH(60)));
    }];
    
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = FONT(26);
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeButton];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(GTH(30) + 20);
        make.right.equalTo(self).offset(GTW(-30));
        make.width.height.mas_equalTo(GTH(80));
    }];
    
    
}

- (void)checkButtonAction
{
    if ([self.delegate respondsToSelector:@selector(checkButtonClick)]) {
        [self.delegate checkButtonClick];
    }
}

- (void)closeButtonAction
{
    if ([self.delegate respondsToSelector:@selector(closeButtonClick)]) {
        [self.delegate closeButtonClick];
    }
}

@end
