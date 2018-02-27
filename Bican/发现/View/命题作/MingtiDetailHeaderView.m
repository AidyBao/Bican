//
//  MingtiDetailHeaderView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/6.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MingtiDetailHeaderView.h"

@interface MingtiDetailHeaderView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *fromUserLabel;
@property (nonatomic, strong) UIView *fromUserLineView;

@property (nonatomic, strong) UILabel *fromTestLabel;
@property (nonatomic, strong) UIView *fromTestLineView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titletLineView;

@property (nonatomic, strong) UIButton *showAllButton;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation MingtiDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setMingtiDetailHeaderViewWithFromUser:(NSString *)fromUser
                                     FromTest:(NSString *)fromTest
                                      Content:(NSString *)content
{
    if (fromUser.length != 0) {
        self.fromUserLabel.text = [NSString stringWithFormat:@"@%@ 提供", fromUser];
    }
    self.fromTestLabel.text = fromTest;
    if (content.length != 0) {
        if ([NSString isHtmlString:content]) {
            [self.contentLabel htmlStringToChangeWithLabel:self.contentLabel String:content];
        } else {
            self.contentLabel.text = content;
        }
        self.contentLabel.attributedText = [UILabel setLabelSpace:self.contentLabel withValue:self.contentLabel.text withFont:self.contentLabel.font];
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }

}

- (void)createSubViews
{

    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = GTH(10);
    self.backView.layer.shadowColor = RGBA(127, 127, 127, 1).CGColor;
    self.backView.layer.shadowRadius = GTH(29);
    self.backView.layer.shadowOpacity = 0.24f;
    [self addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        make.top.equalTo(self.mas_top).offset(GTH(30));
        make.bottom.equalTo(self.mas_bottom).offset(GTH(-30));
    }];
    
    self.fromUserLabel = [[UILabel alloc] init];
    self.fromUserLabel.textColor = ZTTextGrayColor;
    self.fromUserLabel.font = FONT(28);
    self.fromUserLabel.numberOfLines = 0;
    [self addSubview:self.fromUserLabel];
    
    [self.fromUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(GTW(30));
        make.right.equalTo(self.backView.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(GTH(96));
        make.top.equalTo(self.backView);
    }];
    
    self.fromUserLineView = [[UIView alloc] init];
    self.fromUserLineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.fromUserLineView];
    
    [self.fromUserLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.equalTo(self.fromUserLabel.mas_bottom);
        make.left.right.equalTo(self.backView);
    }];
    
    self.fromTestLabel = [[UILabel alloc] init];
    self.fromTestLabel.textColor = ZTTextGrayColor;
    self.fromTestLabel.font = FONT(28);
    self.fromTestLabel.numberOfLines = 0;
    [self addSubview:self.fromTestLabel];
    
    [self.fromTestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.fromUserLabel);
        make.top.equalTo(self.fromUserLineView.mas_bottom);
    }];
    
    self.fromTestLineView = [[UIView alloc] init];
    self.fromTestLineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.fromTestLineView];
    
    [self.fromTestLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.fromUserLineView);
        make.top.equalTo(self.fromTestLabel.mas_bottom);
    }];
    
    self.showAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showAllButton setTitle:@"完整命题" forState:UIControlStateNormal];
    [self.showAllButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    [self.showAllButton setBackgroundColor:[UIColor whiteColor]];
    self.showAllButton.titleLabel.font = FONT(24);
    self.showAllButton.adjustsImageWhenHighlighted = NO;
    [self.showAllButton addTarget:self action:@selector(showButtoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.showAllButton];
    
    [self.showAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView).offset(GTW(-30));
        make.top.equalTo(self.fromTestLineView.mas_bottom);
        make.height.equalTo(self.fromTestLabel);
        make.width.mas_equalTo(GTW(120));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"命题描述";
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(GTW(30));
        make.top.height.equalTo(self.showAllButton);
    }];
    
    self.titletLineView = [[UIView alloc] init];
    self.titletLineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.titletLineView];
    
    [self.titletLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.fromUserLineView);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.font = FONT(28);
    self.contentLabel.numberOfLines = 3;
    [self addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fromUserLabel);
        make.top.equalTo(self.titletLineView.mas_bottom).offset(GTH(30));
    }];
    
    
}

- (void)showButtoAction
{
    if ([self.delegate respondsToSelector:@selector(pushToMingtiAllVC)]) {
        [self.delegate pushToMingtiAllVC];
    }
}

@end
