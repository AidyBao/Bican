
//
//  SelectIdentityViewController.m
//  Bican
//
//  Created by bican on 2018/1/14.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "SelectIdentityViewController.h"

@interface SelectIdentityViewController ()

@property (nonatomic, strong) UIButton *teacherButton;
@property (nonatomic, strong) UILabel *teacherLabel;

@property (nonatomic, strong) UIButton *studentButton;
@property (nonatomic, strong) UILabel *studentLabel;

@end

@implementation SelectIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createButtonTarget];
    
}


- (void)createButtonTarget
{
    self.teacherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.teacherButton setImage:[UIImage imageNamed:@"teacher_img"] forState:UIControlStateNormal];
    self.teacherButton.adjustsImageWhenHighlighted = NO;
    self.teacherButton.tag = 123456;
    self.teacherButton.layer.cornerRadius = GTH(253) / 2;
    [self.teacherButton addTarget:self action:@selector(selectIdentityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.teacherButton];
    
    [self.teacherButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(GTH(130) + NAV_HEIGHT);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(GTH(253), GTH(253)));
    }];
    
    
    self.teacherLabel = [[UILabel alloc] init];
    self.teacherLabel.textColor = ZTTitleColor;
    self.teacherLabel.font = FONT(32);
    self.teacherLabel.text = @"我是教师";
    [self.view addSubview:self.teacherLabel];
    
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teacherButton.mas_bottom).offset(GTH(20));
        make.centerX.equalTo(self.view);
    }];
    
    
    self.studentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.studentButton setImage:[UIImage imageNamed:@"student_img"] forState:UIControlStateNormal];
    self.studentButton.adjustsImageWhenHighlighted = NO;
    self.studentButton.tag = 654321;
    self.studentButton.layer.cornerRadius = GTH(253) / 2;
    [self.studentButton addTarget:self action:@selector(selectIdentityButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.studentButton];
    
    [self.studentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.teacherLabel.mas_bottom).offset(GTH(88));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(GTH(253), GTH(253)));
    }];
    
    
    self.studentLabel = [[UILabel alloc] init];
    self.studentLabel.textColor = ZTTitleColor;
    self.studentLabel.text = @"我是学生";
    self.studentLabel.font = FONT(32);
    [self.view addSubview:self.studentLabel];
    
    [self.studentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.studentButton.mas_bottom).offset(GTH(20));
        make.centerX.equalTo(self.view);
    }];
}


- (void)selectIdentityButtonAction:(UIButton *)button
{
    
}



@end
