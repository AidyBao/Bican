//
//  MineHeaderView.m
//  Bican
//
//  Created by chichen on 2017/12/24.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MineHeaderView.h"

@interface MineHeaderView ()

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UIImageView *goImageView;

@end

@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setMineHeaderViewWithHeaderImage:(NSString *)headerImage
                                    Name:(NSString *)name
                                  School:(NSString *)school
                               ClassName:(NSString *)className
{
    if (headerImage.length != 0) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImage] placeholderImage:[UIImage imageNamed:@"my_header"]];
    }
    self.nameLabel.text = name;
    
    //如果没有加入班级
    if ([GetUserInfo getUserInfoModel].classId.length == 0) {
        self.schoolLabel.text = @"未加入班级";
    } else {
        //显示 学校 + 班级
        if (className.length == 0) {
            self.schoolLabel.text = school;
        } else if (school.length == 0) {
            self.schoolLabel.text = className;
        } else if (className.length != 0 && school.length != 0) {
            self.schoolLabel.text = [NSString stringWithFormat:@"%@ · %@", school, className];
        }
        
    }
    
}

- (void)createSubViews
{
    self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode-bg"]];
    [self addSubview:self.backImageView];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    self.headerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_header"]];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.layer.cornerRadius = GTH(120) / 2;
    self.headerImageView.layer.masksToBounds = YES;
    [self addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(28));
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(GTH(120), GTH(120)));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"司马呵呵";
    self.nameLabel.textColor = ZTTitleColor;
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(40)];
    [self addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(GTW(28));
        make.centerY.equalTo(self.headerImageView).offset(GTH(-25));
    }];
    
    self.schoolLabel = [[UILabel alloc] init];
    self.schoolLabel.text = @"成都四中 · 初二1班";
    self.schoolLabel.textColor = ZTTitleColor;
    self.schoolLabel.font = FONT(30);
    [self addSubview:self.schoolLabel];
    
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(18));
        
    }];
    
    self.goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode-link-icon"]];
    [self addSubview:self.goImageView];
    
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backImageView.mas_right).offset(GTW(-28));
        make.centerY.equalTo(self.backImageView.mas_centerY);
        
    }];
    
    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:@selector(controlAciton) forControlEvents:UIControlEventTouchUpInside];;
    [self addSubview:control];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
}

- (void)controlAciton
{
    if ([self.delegate respondsToSelector:@selector(pushToAccountsVC)]) {
        [self.delegate pushToAccountsVC];
    }
}












@end

