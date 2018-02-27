//
//  CompositionSelectedTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "CompositionSelectedTableViewCell.h"

@interface CompositionSelectedTableViewCell ()

@property (nonatomic, strong) UILabel *topLeftLabel;
@property (nonatomic, strong) UILabel *topRightLabel;
@property (nonatomic, strong) UILabel *bottomLeftLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *chooseButton;

@end

@implementation CompositionSelectedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setCompositionSelectedCellWithLeftTopText:(NSString *)leftTopText
                                     RightTopText:(NSString *)rightTopText
                                   LeftBottomText:(NSString *)leftBottomText
{
    self.topLeftLabel.text = leftTopText;
    self.topRightLabel.text = rightTopText;
    self.bottomLeftLabel.text = leftBottomText;
}

- (void)setCellIsSelected:(NSString *)isSelected
{
    if ([isSelected isEqualToString:@"NO"]) {
        self.chooseButton.selected = NO;
    } else {
        self.chooseButton.selected = YES;
    }
}

- (void)createSubViews
{
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self.chooseButton setImage:[UIImage imageNamed:@"checkbox_a"] forState:UIControlStateSelected];
    self.chooseButton.adjustsImageWhenHighlighted = NO;
    [self.chooseButton addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.chooseButton];
    
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTH(38), GTH(38)));
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.centerY.equalTo(self.contentView);
    }];
    
    self.topLeftLabel = [[UILabel alloc] init];
    self.topLeftLabel.textColor = ZTTextLightGrayColor;
    self.topLeftLabel.font = FONT(24);
    [self.contentView addSubview:self.topLeftLabel];
    
    [self.topLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseButton.mas_right).offset(GTW(39));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(23));
    }];
    
    self.topRightLabel = [[UILabel alloc] init];
    self.topRightLabel.textColor = ZTTextLightGrayColor;
    self.topRightLabel.font = FONT(24);
    [self.contentView addSubview:self.topRightLabel];
    
    [self.topRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.topLeftLabel.mas_top);
    }];
    
    self.bottomLeftLabel = [[UILabel alloc] init];
    self.bottomLeftLabel.textColor = ZTTitleColor;
    self.bottomLeftLabel.font = FONT(28);
    [self.contentView addSubview:self.bottomLeftLabel];
    
    [self.bottomLeftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLeftLabel);
        make.right.equalTo(self.topRightLabel);
        make.top.equalTo(self.topLeftLabel.mas_bottom).offset(GTH(26));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(1);
    }];


}

- (void)chooseButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    BOOL isSelected;
    if (sender.isSelected) {
        isSelected = YES;
    } else {
        isSelected = NO;
    }
    if ([self.delegate respondsToSelector:@selector(selecetedCell:)]) {
        [self.delegate selecetedCell:self];
    }
    
}



@end
