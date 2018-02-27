//
//  ZTBottomSelecteView.m
//  Bican
//
//  Created by 迟宸 on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTBottomSelecteView.h"

@interface ZTBottomSelecteView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) CGFloat button_height;

@end

@implementation ZTBottomSelecteView

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.button_height = GTH(110);
        [self createSubViews];
    }
    return self;
}

- (void)setZTBottomSelecteViewWithArray:(NSArray *)array
                      CancelButtonTitle:(NSString *)cancelButtonTitle
                              TextColor:(UIColor *)textColor
                               TextFont:(UIFont *)textFont
                      IsShowOrangeColor:(BOOL)isShowOrangeColor
                       OrangeColorIndex:(NSInteger)orangeColorIndex
{
    if (array.count == 0) {
        return;
    }
    
    for (UIView *view in self.centerView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:array];
    
    [self.cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:textColor forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = textFont;
    
    CGFloat centerView_height = (self.dataSourceArray.count + 1) * self.button_height + GTH(12) + (self.dataSourceArray.count - 1) * 1 ;
    [self.centerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(centerView_height);
    }];
    
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        if (isShowOrangeColor) {
            if (i == orangeColorIndex) {
                [button setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
            } else {
                [button setTitleColor:textColor forState:UIControlStateNormal];
            }
        } else {
            [button setTitleColor:textColor forState:UIControlStateNormal];
        }
        button.titleLabel.font = textFont;
        button.tag = 100100 + i;
        [button setBackgroundColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.centerView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(self.button_height);
            make.bottom.equalTo(self.mas_bottom).offset(-self.button_height - GTH(12) - (self.button_height + 1) * i);
        }];
    }
    
}

- (void)createSubViews
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.24;
    [self addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(ScreenHeight);
    }];
    
    self.centerView = [[UIView alloc] init];
    self.centerView.backgroundColor = ZTAlphaColor;
    [self addSubview:self.centerView];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(0);
    }];

    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
    self.cancelButton.adjustsImageWhenHighlighted = NO;
    [self.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.centerView);
        make.height.mas_equalTo(self.button_height);
    }];
    
    
}

- (void)buttonAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(selecetedIndex:)]) {
        [self.delegate selecetedIndex:sender.tag - 100100];
    }
}

- (void)cancelButtonAction
{
    [self setHidden:YES];
    if ([self.delegate respondsToSelector:@selector(cancelButtonClick)]) {
        [self.delegate cancelButtonClick];
    }
}




@end
