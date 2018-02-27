//
//  ZTChangeTopView.m
//  Bican
//
//  Created by 迟宸 on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//  不带滚动

#import "ZTChangeTopView.h"

@interface ZTChangeTopView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bottomColorView;

@end

@implementation ZTChangeTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createTitleWithArray:(NSArray *)array
{
    CGFloat buttonWidth = ScreenWidth / 2;
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, self.frame.size.height);
        [button setTitleColor:ZTOrangeColor forState:UIControlStateSelected];
        [button setTitleColor:ZTTitleColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(26)];
        button.tag = 1111 + i;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            button.selected = YES;
        } else {
            button.selected = NO;
        }
        [self addSubview:button];

    }
}

- (void)chooseType:(UIButton *)sender
{
    sender.selected = !sender.selected;

    UIButton *leftBtn = (UIButton *)[self viewWithTag:1111];
    UIButton *rightBtn = (UIButton *)[self viewWithTag:1112];

    if (sender.tag == 1111) {
        leftBtn.selected = YES;
        rightBtn.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            [self.bottomColorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTW(100), 2));
                make.bottom.equalTo(self.lineView.mas_top);
                make.left.mas_equalTo((ScreenWidth / 2 - GTW(100)) /2);
            }];
        }];
    }
    if (sender.tag == 1112) {
        leftBtn.selected = NO;
        rightBtn.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            [self.bottomColorView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(GTW(100), 2));
                make.bottom.equalTo(self.lineView.mas_top);
                make.left.mas_equalTo((ScreenWidth / 2 - GTW(100)) /2 + ScreenWidth / 2);
            }];
        }];
    }
    
    if ([self.delelgate respondsToSelector:@selector(changeTopViewSelectedIndex:)]) {
        [self.delelgate changeTopViewSelectedIndex:sender.tag - 1111];
    }

}


- (void)createSubViews
{
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    self.bottomColorView = [[UIView alloc] init];
    self.bottomColorView.backgroundColor = ZTOrangeColor;
    [self addSubview:self.bottomColorView];
    
    [self.bottomColorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(100), 2));
        make.bottom.equalTo(self.lineView.mas_top);
        make.left.mas_equalTo((ScreenWidth / 2 - GTW(100)) /2);
    }];
    
}

@end
