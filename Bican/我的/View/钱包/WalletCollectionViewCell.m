//
//  WalletCollectionViewCell.m
//  Bican
//
//  Created by bican on 2018/1/4.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "WalletCollectionViewCell.h"

@interface WalletCollectionViewCell ()

@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation WalletCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}


- (void)createWallectCellWithCollectionPicture:(NSString *)picture
                                           Own:(NSString *)own
                                          Unit:(NSString *)unit
                                          Name:(NSString *)name
                                      Currency:(NSString *)currency
                                      FlowerId:(NSString *)flowerId

{
    //花的图片
    [self.flowerImage sd_setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@""]];
    
    //花的名字
    self.flowerNameLabel.text = name;
    
    //数量
    self.numberLabel.text = [NSString stringWithFormat:@"%@ %@", own, unit];
}


- (void)createSubViews
{
    self.flowerImage = [[UIImageView alloc] init];
    [self.contentView addSubview:self.flowerImage];
    
    [self.flowerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_top).offset(GTH(39));
        make.size.mas_equalTo(CGSizeMake(GTH(120) - 1, GTH(120) - 1));
    }];
    
    self.flowerNameLabel = [[UILabel alloc] init];
    self.flowerNameLabel.font = FONT(24);
    self.flowerNameLabel.textColor = ZTTextGrayColor;
    self.flowerNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.flowerNameLabel];
    
    [self.flowerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.flowerImage.mas_bottom).offset(GTW(24));
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-1);
        make.height.mas_equalTo(GTH(25));
    }];
    
    self.numberLabel = [[UILabel alloc] init];
    self.numberLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(24)];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.numberLabel];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-1);
        make.top.equalTo(self.flowerNameLabel.mas_bottom).offset(GTH(11));
        make.height.mas_equalTo(GTH(20));
    }];
    
    self.rightLine = [[UIView alloc] init];
    self.rightLine.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.rightLine];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(1);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    
    self.bottomLine = [[UIView alloc] init];
    self.bottomLine.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.bottomLine];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
    }];
    
    
}

@end
