//
//  ZiyouTeacherTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZiyouTeacherTableViewCell.h"

@interface ZiyouTeacherTableViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *teacherLabel;

@property (nonatomic, strong) UILabel *baseLabel;
@property (nonatomic, strong) UILabel *baseCountLabel;
@property (nonatomic, strong) UIView *baseLineView;

@property (nonatomic, strong) UILabel *developLabel;
@property (nonatomic, strong) UILabel *developCountLabel;
@property (nonatomic, strong) UIView *developLineView;

@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *scoreCountLabel;

@end

@implementation ZiyouTeacherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setZiyouTeacherCellWithTeachNickName:(NSString *)teachNickName
                              TeachFirstName:(NSString *)teachFirstName
                                      Basice:(NSString *)basice
                                 Development:(NSString *)development
                             ArticleFraction:(NSString *)articleFraction
{
    NSString *string = [NSString stringWithFormat:@"%@(%@老师)的总评", teachNickName, teachFirstName];
    
    CGFloat width = 0.0;
    CGFloat height = 0.0;
    CGFloat max_width = ScreenWidth - GTW(30) * 2;

    CGSize teacherWidthSize = [self.teacherLabel getSizeWithString:string font:FONT(26) str_height:GTH(44)];
    if (teacherWidthSize.width >= max_width) {
        width = max_width;
        CGSize teacherHeightSize = [self.teacherLabel getSizeWithString:string font:FONT(26) str_width:max_width];
        height = teacherHeightSize.height;
        
    } else {
        width = teacherWidthSize.width;
        CGSize teacherHeightSize = [self.teacherLabel getSizeWithString:string font:FONT(26) str_width:width];
        height = teacherHeightSize.height;
    }
    
    self.teacherLabel.text = string;
    self.baseCountLabel.text = basice;
    self.developCountLabel.text = development;
    //圆角
    self.teacherLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:self.teacherLabel.bounds];

    [self.teacherLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    if ([articleFraction integerValue] < 0) {
        self.scoreLabel.hidden = YES;
        self.scoreCountLabel.hidden = YES;
        self.developLineView.hidden = YES;
        
    } else {
        self.developLineView.hidden = NO;
        self.scoreLabel.hidden = NO;
        self.scoreCountLabel.hidden = NO;
        self.scoreCountLabel.text = [NSString stringWithFormat:@"%@分", articleFraction];
    }
    

}

- (void)createSubViews
{
    self.teacherLabel = [[UILabel alloc] init];
    self.teacherLabel.textColor = [UIColor whiteColor];
    self.teacherLabel.font = FONT(26);
    self.teacherLabel.backgroundColor = ZTOrangeColor;
    self.teacherLabel.textAlignment = NSTextAlignmentCenter;
    self.teacherLabel.numberOfLines = 0;
    [self.contentView addSubview:self.teacherLabel];
    
    [self.teacherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.width.mas_equalTo(ScreenWidth);
        make.height.mas_equalTo(GTH(44));
        make.top.equalTo(self.contentView).offset(GTH(20));
    }];
    
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = GTH(10);
    self.backView.layer.shadowColor = RGBA(127, 127, 127, 1).CGColor;
    self.backView.layer.shadowRadius = GTH(29);
    self.backView.layer.shadowOpacity = 0.24f;
    [self.contentView addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        make.top.equalTo(self.teacherLabel.mas_bottom).offset(GTH(30));
        make.bottom.equalTo(self.mas_bottom).offset(GTH(-30));
    }];
    
    self.baseLabel = [[UILabel alloc] init];
    self.baseLabel.text = @"基础等级";
    self.baseLabel.font = FONT(28);
    self.baseLabel.textColor = ZTOrangeColor;
    [self.contentView addSubview:self.baseLabel];
    
    [self.baseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(GTW(30));
        make.top.equalTo(self.backView.mas_top).offset(GTH(60));
        make.height.mas_equalTo(GTH(60));
    }];
    
    self.baseCountLabel = [[UILabel alloc] init];
    self.baseCountLabel.font = FONT(24);
    self.baseCountLabel.numberOfLines = 0;
    self.baseCountLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.baseCountLabel];
    
    [self.baseCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseLabel);
        make.right.equalTo(self.backView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.baseLabel.mas_bottom).offset(GTH(40));
    }];
    
    self.baseLineView = [[UIView alloc] init];
    self.baseLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.baseLineView];
    
    [self.baseLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self.backView);
        make.top.equalTo(self.baseCountLabel.mas_bottom).offset(GTH(60));
    }];
    
    self.developLabel = [[UILabel alloc] init];
    self.developLabel.text = @"发展等级";
    self.developLabel.font = FONT(28);
    self.developLabel.textColor = ZTOrangeColor;
    [self.contentView addSubview:self.developLabel];
    
    [self.developLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.baseLabel);
        make.top.equalTo(self.baseLineView.mas_top).offset(GTH(60));
        make.height.mas_equalTo(GTH(60));
    }];
    
    self.developCountLabel = [[UILabel alloc] init];
    self.developCountLabel.font = FONT(24);
    self.developCountLabel.numberOfLines = 0;
    self.developCountLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.developCountLabel];
    
    [self.developCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.developLabel);
        make.right.equalTo(self.baseCountLabel);
        make.top.equalTo(self.developLabel.mas_bottom).offset(GTH(40));
    }];
    
    self.developLineView = [[UIView alloc] init];
    self.developLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.developLineView];
    
    [self.developLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self.backView);
        make.top.equalTo(self.developCountLabel.mas_bottom).offset(GTH(60));
    }];
    
    self.scoreLabel = [[UILabel alloc] init];
    self.scoreLabel.text = @"评分";
    self.scoreLabel.font = FONT(28);
    self.scoreLabel.textColor = ZTOrangeColor;
    [self.contentView addSubview:self.scoreLabel];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.developLabel);
        make.top.equalTo(self.developLineView.mas_bottom).offset(GTH(60));
        make.height.mas_equalTo(GTH(60));
    }];
    
    self.scoreCountLabel = [[UILabel alloc] init];
    self.scoreCountLabel.textColor = ZTTitleColor;
    self.scoreCountLabel.font = FONT(28);
    self.scoreCountLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.scoreCountLabel];
    
    [self.scoreCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.backView.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.scoreLabel);
    }];
    
}


@end
