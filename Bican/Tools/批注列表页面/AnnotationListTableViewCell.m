//
//  AnnotationListTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/18.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AnnotationListTableViewCell.h"

@interface AnnotationListTableViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation AnnotationListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setCellSeletedWithBorderColor:(UIColor *)borderColor BorderWidth:(CGFloat)borderWidth
{
    self.backView.layer.borderWidth = borderWidth;
    self.backView.layer.borderColor = borderColor.CGColor;
}

- (void)setAnnotationListCellWithName:(NSString *)name Page:(NSString *)page Content:(NSString *)content
{
    self.nameLabel.text = name;
    self.pageLabel.text = page;
    self.contentLabel.text = content;
}

- (void)createSubViews
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = GTH(10);
    self.backView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(GTH(-10));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = ZTOrangeColor;
    self.nameLabel.font = FONT(26);
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(GTW(30));
        make.right.equalTo(self.backView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.backView.mas_top).offset(GTH(30));
    }];
    
    self.pageLabel = [[UILabel alloc] init];
    self.pageLabel.font = FONT(24);
    self.pageLabel.numberOfLines= 0;
    self.pageLabel.textColor = ZTTextGrayColor;
    [self.contentView addSubview:self.pageLabel];
    
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = ZTTitleColor;
    self.contentLabel.font = FONT(24);
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.nameLabel);
        make.top.equalTo(self.pageLabel.mas_bottom).offset(GTH(30));
    }];
    
}


@end
