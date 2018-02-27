


//
//  GiftExchangeWenbiTableViewCell.m
//  Bican
//
//  Created by bican on 2018/1/13.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "GiftExchangeWenbiTableViewCell.h"

@interface GiftExchangeWenbiTableViewCell ()

@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) UIImageView *giftIamgeView;
@property (nonatomic, strong) UILabel *giftNameLabel;
@property (nonatomic, strong) UILabel *wenbiLabel;
@property (nonatomic, strong) UILabel *allNumberLabel;
@property (nonatomic, strong) UILabel *flowerLabel;
@property (nonatomic, strong) UIButton *reductionButton;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation GiftExchangeWenbiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setGiftExchangeWenbiCellWithFlowerName:(NSString *)name
                                     FlowerPic:(NSString *)flowerPic
                                      Currency:(NSString *)currency
                                          Unit:(NSString *)unit
                                 SelectedCount:(NSString *)selectedCount;

{
    if (flowerPic.length != 0) {
        [self.giftIamgeView sd_setImageWithURL:[NSURL URLWithString:flowerPic] placeholderImage:[UIImage imageNamed:@""]];
    }
    self.giftNameLabel.text = name;
    self.wenbiLabel.text = [NSString stringWithFormat:@"%@文币/%@", currency, unit];
    if (selectedCount.length == 0) {
        self.numberLabel.text = @"0";
    } else {
        self.numberLabel.text = selectedCount;
    }
    self.allNumberLabel.text = [NSString stringWithFormat:@"×%@%@", selectedCount, unit];

}

- (void)setCellIsSelectedAll:(BOOL)isSelected
{
    if (!isSelected) {
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
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(GTH(38), GTH(38)));
    }];
    
    self.giftIamgeView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.giftIamgeView];
    
    [self.giftIamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(96));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(34));
        make.size.mas_offset(CGSizeMake(GTH(120), GTH(120)));
    }];
    
    self.giftNameLabel = [[UILabel alloc] init];
    self.giftNameLabel.font = FONT(24);
    self.giftNameLabel.textColor = ZTTextGrayColor;
    [self.contentView addSubview:self.giftNameLabel];
    
    [self.giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.giftIamgeView.mas_right).offset(GTW(32));
        make.top.equalTo(self.giftIamgeView.mas_top).offset(GTH(15));
    }];
    
    
    self.wenbiLabel = [[UILabel alloc] init];
    self.wenbiLabel.textColor = ZTTextGrayColor;
    self.wenbiLabel.font = FONT(24);
    [self.contentView addSubview:self.wenbiLabel];
    
    [self.wenbiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.giftNameLabel.mas_right).offset(GTW(24));
        make.top.equalTo(self.giftNameLabel);
    }];
    
    self.allNumberLabel = [[UILabel alloc] init];
    self.allNumberLabel.textColor = ZTTextGrayColor;
    self.allNumberLabel.font = FONT(24);
    [self.contentView addSubview:self.allNumberLabel];
    
    [self.allNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.giftNameLabel);
    }];
    
    
    self.reductionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reductionButton setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    self.reductionButton.adjustsImageWhenHighlighted = NO;
    self.reductionButton.tag = 10086;
    [self.reductionButton addTarget:self action:@selector(giftAddAndSubtractButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.reductionButton];
    
    [self.reductionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.giftNameLabel);
        make.top.equalTo(self.giftNameLabel.mas_bottom).offset(GTH(34));
        make.size.mas_equalTo(CGSizeMake(GTH(33), GTH(33)));
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.textColor = ZTTitleColor;
    self.numberLabel.font = FONT(30);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.numberLabel];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reductionButton.mas_right);
        make.top.equalTo(self.reductionButton);
        make.width.mas_equalTo(GTW(133));
    }];
    
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    self.addButton.adjustsImageWhenHighlighted = NO;
    self.addButton.tag = 10010;
    [self.addButton addTarget:self action:@selector(giftAddAndSubtractButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLabel.mas_right);
        make.top.equalTo(self.reductionButton);
        make.size.mas_equalTo(CGSizeMake(GTH(33), GTH(33)));
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
    if ([self.delegate respondsToSelector:@selector(selecetedCell:IsSelected:)]) {
        [self.delegate selecetedCell:self IsSelected:isSelected];
    }
    
}

- (void)giftAddAndSubtractButtonAction:(UIButton *)button
{
    BOOL isAdd;
    if (button.tag == 10010) {
        //加一个
        isAdd = YES;
    } else {
        //减一个
        isAdd = NO;
    }
    if ([self.delegate respondsToSelector:@selector(isAddFlower:WithCell:)]) {
        [self.delegate isAddFlower:isAdd WithCell:self];
    }
    
}



@end
