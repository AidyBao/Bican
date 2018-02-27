//
//  RechargeViewController.m
//  Bican
//
//  Created by bican on 2018/1/4.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "RechargeViewController.h"

@interface RechargeViewController ()

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *accountsLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *balanceLabel;
@property (nonatomic, strong) UILabel *wenbiLabel;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *boxButton;

@property (nonatomic, strong) NSMutableArray *boxButtonArray;
@property (nonatomic, strong) NSMutableArray *buttonGrayImageArray;
@property (nonatomic, strong) NSMutableArray *buttonYellowImageArray;

@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UILabel *agreenmentLabel;

@end

@implementation RechargeViewController

- (NSMutableArray *)buttonYellowImageArray
{
    if (!_buttonYellowImageArray) {
        _buttonYellowImageArray = [NSMutableArray array];
        [_buttonYellowImageArray addObject:@"6huang"];
        [_buttonYellowImageArray addObject:@"30huang"];
        [_buttonYellowImageArray addObject:@"98huang"];
        [_buttonYellowImageArray addObject:@"198huang"];
        [_buttonYellowImageArray addObject:@"328huang"];
        [_buttonYellowImageArray addObject:@"648huang"];
    }
    return _buttonYellowImageArray;
}

- (NSMutableArray *)buttonGrayImageArray
{
    if (!_buttonGrayImageArray) {
        _buttonGrayImageArray = [NSMutableArray array];
        [_buttonGrayImageArray addObject:@"6hui"];
        [_buttonGrayImageArray addObject:@"30hui"];
        [_buttonGrayImageArray addObject:@"98hui"];
        [_buttonGrayImageArray addObject:@"198hui"];
        [_buttonGrayImageArray addObject:@"328hui"];
        [_buttonGrayImageArray addObject:@"648hui"];
    }
    return _buttonGrayImageArray;
}

- (NSMutableArray *)boxButtonArray
{
    if (!_boxButtonArray) {
        _boxButtonArray = [NSMutableArray array];
    }
    return _boxButtonArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文币充值";
    
    [self createHeaderView];
    [self createSubView];
}

-(void)createHeaderView
{
    self.headerView = [[UIView alloc] init];
    self.headerView.backgroundColor = ZTNavColor;
    [self.view addSubview:self.headerView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.height.mas_equalTo(GTH(150));
    }];
    
    self.headerImage = [[UIImageView alloc] init];
//    self.headerImage.image = [UIImage imageNamed:@""];
    self.headerImage.backgroundColor = ZTBlueColor;
    self.headerImage.layer.cornerRadius = GTH(90) / 2;
    [self.headerView addSubview:self.headerImage];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.centerY.equalTo(self.headerView);
        make.size.mas_equalTo(CGSizeMake(GTH(90), GTH(90)));
    }];
    
    self.accountsLabel = [[UILabel alloc] init];
    self.accountsLabel.font = FONT(26);
    self.accountsLabel.textColor = ZTTextLightGrayColor;
    self.accountsLabel.text = @"充值帐号 :";
    [self.headerView addSubview:self.accountsLabel];
    
    [self.accountsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImage.mas_right).offset(GTW(26));
        make.top.equalTo(self.headerImage.mas_top).offset(GTH(10));
        make.height.mas_equalTo(GTH(25));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = ZTTitleColor;
    self.nameLabel.font = FONT(26);
    self.nameLabel.text = @"小天狼星-李老师";
    [self.headerView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountsLabel.mas_right).offset(19);
        make.top.equalTo(self.accountsLabel);
    }];
    
    self.balanceLabel = [[UILabel alloc] init];
    self.balanceLabel.textColor = ZTTextLightGrayColor;
    self.balanceLabel.font = FONT(26);
    self.balanceLabel.text = @"当前余额 :";
    [self.headerView addSubview:self.balanceLabel];
    
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountsLabel);
        make.top.equalTo(self.accountsLabel.mas_bottom).offset(GTH(22));
    }];
    
    self.wenbiLabel = [[UILabel alloc] init];
    self.wenbiLabel.textColor = ZTTitleColor;
    self.wenbiLabel.font = FONT(26);
    self.wenbiLabel.text = @"123124142文币";
    [self.headerView addSubview:self.wenbiLabel];
    
    [self.wenbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.balanceLabel);
    }];
    
}

- (void)createSubView
{
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textColor = ZTTitleColor;
    self.numberLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(28)];
    self.numberLabel.text = @"充值数量";
    [self.view addSubview:self.numberLabel];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.top.equalTo(self.headerView.mas_bottom).offset(GTH(38));
    }];
    
    for (int i = 0; i < 6; i++) {
        self.boxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.boxButton setImage:[UIImage imageNamed:self.buttonGrayImageArray[i]] forState:UIControlStateNormal];
        [self.boxButton setImage:[UIImage imageNamed:self.buttonYellowImageArray[i]] forState:UIControlStateSelected];
        self.boxButton.tag = 10001 + i;
        [self.boxButton addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.boxButton.adjustsImageWhenHighlighted = NO;
        [self.view addSubview:self.boxButton];
        
        NSInteger row = i / 3;
        NSInteger line = i % 3;
        
        CGFloat pic_width = GTW(153);
        CGFloat pic_height = GTH(145);

        CGFloat margin_x = (ScreenWidth - GTW(30) * 2 - pic_width * 3) / 2;

        CGFloat margin_y = GTH(19);

        CGFloat picX = GTW(30) + (pic_width + margin_x) * line;
        CGFloat picY = margin_y + (pic_height + margin_y) * row;

        [self.boxButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(picX);
            make.top.equalTo(self.numberLabel.mas_bottom).offset(picY);
            make.size.mas_equalTo(CGSizeMake(pic_width, pic_height));
        }];
        
        [self.boxButtonArray addObject:self.boxButton];
        
    }
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.view).offset(GTW(28));
        make.right.equalTo(self.view).offset(GTW(-28));
        make.top.equalTo(self.boxButton.mas_bottom).offset(GTH(38));
    }];

    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.textColor = ZTTextGrayColor;
    self.totalLabel.font = FONT(24);
    self.totalLabel.text = @"总计: 6文币";
    self.totalLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.totalLabel];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(GTW(-28));
        make.height.mas_equalTo(GTH(24));
        make.top.equalTo(self.lineView.mas_bottom).offset(GTH(38));
    }];
    
    self.sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sureButton setBackgroundColor:ZTOrangeColor];
    [self.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sureButton setTitle:@"确认充值xx元" forState:UIControlStateNormal];
    self.sureButton.layer.cornerRadius = GTH(38);
    self.sureButton.adjustsImageWhenHighlighted = NO;
    [self.sureButton addTarget:self action:@selector(sureRechargeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.sureButton];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(62));
        make.right.equalTo(self.view.mas_right).offset(GTW(-62));
        make.top.equalTo(self.totalLabel.mas_bottom).offset(GTH(56));
        make.height.mas_equalTo(GTH(78));
    }];

    self.agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.agreeButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self.agreeButton setImage:[UIImage imageNamed:@"checkbox_a"] forState:UIControlStateSelected];
    self.agreeButton.selected = YES;
    [self.agreeButton addTarget:self action:@selector(agreeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.agreeButton];
    
    [self.agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(GTH(38));
        make.top.equalTo(self.sureButton.mas_bottom).offset(GTH(19));
        make.left.equalTo(self.view.mas_left).offset(GTW(270));
    }];
    
    self.agreenmentLabel = [[UILabel alloc] init];
    self.agreenmentLabel.text = @"同意充值协议";
    self.agreenmentLabel.font = FONT(24);
    self.agreenmentLabel.textColor = ZTOrangeColor;
    [self.view addSubview:self.agreenmentLabel];
    
    [self.agreenmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.agreeButton.mas_right).offset(GTW(4));
        make.centerY.equalTo(self.agreeButton);
    }];
    //改变文字颜色
   self.agreenmentLabel.attributedText = [UILabel changeLabel:self.agreenmentLabel Color:ZTTextGrayColor Loc:0 Len:2 Font:self.agreenmentLabel.font];

    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.agreenmentLabel);
    }];
    
}

#pragma mark - 文币选中按钮
- (void)selectButtonAction:(UIButton *)sender
{
    for (UIButton *button in _boxButtonArray) {
        
        if (button == sender) {
            button.selected = NO;
        } else {
            button.selected = YES;
        }
        button.selected = !button.selected;
    }
    
}

#pragma mark - 确认充值
- (void)sureRechargeButtonAction
{
    
}

#pragma mark - 同意协议按钮
- (void)agreeButtonAction:(UIButton *)button
{
    button.selected = !button.selected;
}

#pragma mark - 跳转查看充值协议
- (void)controlAction
{
    
}

@end
