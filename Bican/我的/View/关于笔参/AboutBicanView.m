//
//  AboutBicanView.m
//  Bican
//
//  Created by bican on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "AboutBicanView.h"

@interface AboutBicanView ()

@property (nonatomic, strong) UIImageView *logoImage;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *introduceLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *companyLabel;

@end

@implementation AboutBicanView

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
    self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_logo"]];
    [self addSubview:self.logoImage];
    
    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(GTH(80));
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(GTH(160), GTH(160)));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImage.mas_bottom).offset(GTH(80));
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.right.equalTo(self.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(1);
    }];
    
    
    self.introduceLabel = [[UILabel alloc] init];
    self.introduceLabel.text = @"笔参，是依托移动互联网生态环境，深耕一线教学发展诉求，汇聚一线名师经验、智慧，而研发的国内首款提升作文教学效率辅助工作。以中学语文教师及在校学生为主要用户群体。通过在线批阅、线上辅导、互动交流等多元化途径，致力于为作文教学提供全方位智慧解决方案。";
    self.introduceLabel.attributedText = [UILabel setLabelSpace:_introduceLabel withValue:_introduceLabel.text withFont:_introduceLabel.font];
    self.introduceLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.introduceLabel.textColor = ZTTextGrayColor;
    self.introduceLabel.font = FONT(26);
    self.introduceLabel.numberOfLines = 0;
    [self.introduceLabel sizeToFit];
    [self addSubview:self.introduceLabel];
    
    [self.introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(GTH(28));
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.right.equalTo(self.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(GTH(270));
    }];
    
    
    self.companyLabel = [[UILabel alloc] init];
    self.companyLabel.font = FONT(24);
    self.companyLabel.text = @"Copyright © 2017 四川辅旻网络科技有限公司";
    self.companyLabel.textColor = ZTTextLightGrayColor;
    [self addSubview:self.companyLabel];
    
    [self.companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(GTH(-58));
        make.height.mas_equalTo(GTH(25));
    }];
    
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.font = FONT(28);
    self.versionLabel.text = [NSString stringWithFormat:@"V %@", APPVERSION];
    self.versionLabel.textColor = ZTTitleColor;
    [self addSubview:self.versionLabel];
    
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.companyLabel.mas_top).offset(GTH(-82));
        make.height.mas_equalTo(GTH(30));
    }];
    
}




@end
