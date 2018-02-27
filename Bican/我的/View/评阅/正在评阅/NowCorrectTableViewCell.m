//
//  NowCorrectTableViewCell.m
//  Bican
//
//  Created by bican on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "NowCorrectTableViewCell.h"

@interface NowCorrectTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UILabel *typeLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *flowerImageView;
@property (nonatomic, strong) UILabel *flowerLabel;
@property (nonatomic, strong) UIButton *correctButton;

@end


@implementation NowCorrectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createNowCorrectTableViewWithAvatar:(NSString *)avatar
                                   Nickname:(NSString *)nickname
                                 SchoolName:(NSString *)schoolName
                                BigTypeName:(NSString *)bigTypeName
                                      Title:(NSString *)title
                                    Summary:(NSString *)summary
                                   Flower:(NSString *)flower
                                   Relation:(NSString *)relation
                               SendDatetime:(NSString *)sendDatetime
                            ReceiveDatetime:(NSString *)receiveDatetime

{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"my_header"]];
    self.nameLabel.text = nickname;
    self.schoolLabel.text = schoolName;
    self.titleLabel.text = title;
    self.descLabel.text = summary;
    self.flowerLabel.text = flower;
    if ([relation isEqualToString:@"1"]) {//我的学生
        [self.correctButton setTitle:@"评阅作文" forState:UIControlStateNormal];
    }
    NSInteger time = [NSString getTimesByStart:receiveDatetime End:[NSString stringFromNow]];
    if ([relation isEqualToString:@"2"]) {//其他学生
        [self.correctButton setTitle:[NSString stringWithFormat:@"评阅作文(请在%ld小时内完成评阅)", 72 - time] forState:UIControlStateNormal];
    }
    //类型圆角
    self.typeLabel.text = bigTypeName;
    CGSize typeSize = [self.typeLabel getSizeWithString:bigTypeName font:self.typeLabel.font str_height:GTH(44)];
    [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(typeSize.width);
    }];
    
    self.typeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, typeSize.width, GTH(44))];
    
}

- (void)createSubViews
{
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = GTH(50) / 2;
    self.headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(36));
        make.size.mas_equalTo(CGSizeMake(GTH(50), GTH(50)));
    }];
    
    //学生姓名
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = FONT(28);
    self.nameLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(GTW(30));
        make.centerY.equalTo(self.headerImageView.mas_centerY);
    }];
    
    //学校名称
    self.schoolLabel = [[UILabel alloc] init];
    self.schoolLabel.textColor = ZTTextGrayColor;
    self.schoolLabel.font = FONT(24);
    [self.contentView addSubview:self.schoolLabel];
    
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(GTW(20));
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        
    }];
    
    //作文主题
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.backgroundColor = RGBA(187, 187, 187, 1);
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.font = FONT(24);
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-GTW(30));
        make.centerY.equalTo(self.headerImageView.mas_centerY);
        make.height.mas_equalTo(GTH(44));
        make.width.mas_equalTo(GTW(120));
    }];
    
    //文章标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = ZTTitleColor;
    //字体加粗
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.typeLabel);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(GTH(34));
    }];
    
    //文章摘要
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.numberOfLines = 3;
    self.descLabel.textColor = ZTTextGrayColor;
    self.descLabel.font = FONT(28);
    [self.contentView addSubview:self.descLabel];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(28));
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.typeLabel);
        make.height.mas_equalTo(GTH(120));
    }];
   
    
    //分割线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.typeLabel);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.descLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.flowerImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flower_zs"]];
    [self.contentView addSubview:self.flowerImageView];
    
    [self.flowerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.top.equalTo(self.lineView.mas_bottom).offset(GTH(20));
        make.size.mas_equalTo(CGSizeMake(GTH(35), GTH(35)));
    }];
    
    self.flowerLabel = [[UILabel alloc] init];
    self.flowerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(26)];
    [self.contentView addSubview:self.titleLabel];
    self.flowerLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.flowerLabel];
    
    
    [self.flowerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flowerImageView.mas_right).offset(GTW(10));
        make.top.equalTo(self.lineView.mas_bottom).offset(GTH(25));
    }];
    
    self.correctButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.correctButton setBackgroundColor:ZTOrangeColor];
    [self.correctButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.correctButton.titleLabel.font = FONT(28);
    self.correctButton.adjustsImageWhenDisabled = NO;
    self.correctButton.layer.cornerRadius = GTH(10);
    [self.correctButton addTarget:self action:@selector(correctButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.correctButton];
    
    [self.correctButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.typeLabel);
        make.top.equalTo(self.flowerLabel.mas_bottom).offset(GTW(20));
        make.height.mas_equalTo(GTH(78));
    }];
    
}

- (void)correctButtonAction
{
    if ([self.delegate respondsToSelector:@selector(commendArticleWithCell:)]) {
        [self.delegate commendArticleWithCell:self];
    }
}



@end
