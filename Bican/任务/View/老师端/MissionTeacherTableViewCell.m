//
//  MissionTeacherTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MissionTeacherTableViewCell.h"

@interface MissionTeacherTableViewCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *goImageView;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation MissionTeacherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setMissionTeacherCellWithTypeText:(NSString *)typeText
                                TypeColor:(UIColor *)typeColor
                                 LeftText:(NSString *)leftText
                                RightText:(NSString *)rightText
                             RightAllText:(NSString *)rightAllText
                               RightColor:(UIColor *)rightColor
{
    self.typeLabel.text = typeText;
    self.leftLabel.text = leftText;
    self.rightLabel.text = [NSString stringWithFormat:@"%@ / %@", rightText, rightAllText];
    
    if (typeColor) {
        self.typeLabel.backgroundColor = typeColor;
    }
    if (rightColor) {
       self.rightLabel.attributedText = [UILabel changeLabel:self.rightLabel Color:rightColor Loc:0 Len:rightText.length Font:self.rightLabel.font];
    }

}

- (void)createSubViews
{
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.font = FONT(24);
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.centerY.equalTo(self.contentView);
        make.height.mas_equalTo(GTH(28));
        make.width.mas_equalTo(GTW(60));
    }];
    //设置部分圆角
    self.typeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(60), GTH(28))];
    
    
    self.goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode-link-icon"]];
    [self.contentView addSubview:self.goImageView];
    
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(GTW(16), GTH(28)));
    }];
    
    CGFloat label_width = (ScreenWidth - GTW(28) * 2 - GTW(20) * 2 - GTW(60)) / 2;
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.font = FONT(28);
    self.rightLabel.textColor = ZTTextGrayColor;
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goImageView.mas_left).offset(GTW(-20));
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(label_width);
    }];
    
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.font = FONT(30);
    self.leftLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.leftLabel];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(GTW(20));
        make.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(label_width);
    }];

    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineLabel];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
}

@end
