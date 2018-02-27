//
//  SelectCompositionTableViewCell.m
//  Bican
//
//  Created by bican on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "SelectCompositionTableViewCell.h"

@interface SelectCompositionTableViewCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *recommendButton;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation SelectCompositionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSelectCompositionControllerWithBigTypeName:(NSString *)bigTypeName
                                                   Title:(NSString *)title
                                             IsRecommend:(NSString *)isRecommend
{
    self.typeLabel.text = bigTypeName;
    self.titleLabel.text = [NSString stringWithFormat:@"《%@》", title];
    if ([isRecommend isEqualToString:@"0"]) {
        [self.recommendButton setTitle:@"推荐" forState:UIControlStateNormal];
        [self.recommendButton setBackgroundColor:ZTOrangeColor];
        [self.recommendButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    }
    
    if ([isRecommend isEqualToString:@"1"]) {
        [self.recommendButton setTitleColor:ZTTextGrayColor forState:UIControlStateNormal];
        [self.recommendButton setTitle:@"已推荐" forState:UIControlStateNormal];
        [self.recommendButton setBackgroundColor:[UIColor whiteColor]];
    }
}



- (void)createSubView
{
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = ZTTextLightGrayColor;
    self.typeLabel.font = FONT(24);
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.equalTo(self.contentView).offset(GTH(23));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = FONT(28);
    self.titleLabel.textColor = ZTTitleColor;
//    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel);
        make.right.equalTo(self.contentView.mas_right).offset(GTH(-100));
        make.top.equalTo(self.typeLabel.mas_bottom).offset(GTH(25));
    }];
    
    
    self.recommendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recommendButton.layer.cornerRadius = GTH(10);
    self.recommendButton.titleLabel.font = FONT(26);
    self.recommendButton.adjustsImageWhenHighlighted = NO;
    [self.recommendButton addTarget:self action:@selector(recommendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.recommendButton];

    [self.recommendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(GTW(80), GTH(60)));
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


- (void)recommendButtonAction
{
    if ([self.delegate respondsToSelector:@selector(selectCompositionToRecommend:)]) {
        [self.delegate selectCompositionToRecommend:self];
    }

}


@end
