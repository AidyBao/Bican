//
//  CheckCommentTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/13.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CheckCommentTableViewCell.h"

@interface CheckCommentTableViewCell ()

@property (nonatomic, strong) UILabel *originalTypeLabel;
@property (nonatomic, strong) UILabel *originalTitleLabel;
@property (nonatomic, strong) UIView *originalLineView;

@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *commentTypeLabel;
@property (nonatomic, strong) UILabel *commentContentLabel;
@property (nonatomic, strong) UIView *commentLineView;

@end

@implementation CheckCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setCheckCommentCellWithOriginal:(NSString *)original
                                Comment:(NSString *)comment
                                 Center:(NSString *)center
                           IsShowCenter:(BOOL)isShowCenter
{
    self.originalTitleLabel.text = original;
    self.commentContentLabel.text = comment;
    
    if (isShowCenter) {
        //显示
        self.centerLabel.text = center;
        self.centerLabel.hidden = NO;
        [self.commentTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.centerLabel.mas_bottom).offset(GTH(30));
        }];
        
    } else {
        //隐藏
        self.centerLabel.hidden = YES;
        [self.commentTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.originalLineView.mas_bottom).offset(GTH(30));
        }];
    }
    
}

- (void)createSubViews
{
    self.originalTypeLabel = [[UILabel alloc] init];
    self.originalTypeLabel.text = @"原文";
    self.originalTypeLabel.backgroundColor = ZTTextLightGrayColor;
    self.originalTypeLabel.textColor = [UIColor whiteColor];
    self.originalTypeLabel.font = FONT(28);
    self.originalTypeLabel.textAlignment = NSTextAlignmentCenter;
    self.originalTypeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.contentView addSubview:self.originalTypeLabel];
    
    [self.originalTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.size.mas_equalTo(CGSizeMake(GTW(67), GTH(44)));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(30));
    }];
    
    self.originalTitleLabel = [[UILabel alloc] init];
    self.originalTitleLabel.textColor = ZTTextLightGrayColor;
    self.originalTitleLabel.font = FONT(24);
    self.originalTitleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.originalTitleLabel];
    
    [self.originalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.originalTypeLabel.mas_right).offset(GTW(30));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.originalTypeLabel.mas_top);
    }];
    
    self.originalLineView = [[UIView alloc] init];
    self.originalLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.originalLineView];
    
    [self.originalLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.originalTitleLabel);
        make.top.equalTo(self.originalTitleLabel.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(1);
    }];
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.numberOfLines = 0;
    self.centerLabel.textColor = ZTOrangeColor;
    self.centerLabel.font = FONT(24);
    [self.contentView addSubview:self.centerLabel];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.originalTitleLabel);
        make.top.equalTo(self.originalLineView.mas_bottom).offset(GTH(30));
    }];
    
    self.commentTypeLabel = [[UILabel alloc] init];
    self.commentTypeLabel.text = @"批注";
    self.commentTypeLabel.font = FONT(28);
    self.commentTypeLabel.backgroundColor = ZTOrangeColor;
    self.commentTypeLabel.textColor = [UIColor whiteColor];
    self.commentTypeLabel.textAlignment = NSTextAlignmentCenter;
    self.commentTypeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.contentView addSubview:self.commentTypeLabel];
    
    [self.commentTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.size.mas_equalTo(CGSizeMake(GTW(67), GTH(44)));
        make.top.equalTo(self.centerLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.commentContentLabel = [[UILabel alloc] init];
    self.commentContentLabel.textColor = ZTTextGrayColor;
    self.commentContentLabel.numberOfLines = 0;
    self.commentContentLabel.font = FONT(24);
    [self.contentView addSubview:self.commentContentLabel];
    
    [self.commentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.originalTitleLabel);
        make.top.equalTo(self.commentTypeLabel);
    }];
    
    self.commentLineView = [[UIView alloc] init];
    self.commentLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.commentLineView];
    
    [self.commentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.originalLineView);
        make.top.equalTo(self.commentContentLabel.mas_bottom).offset(GTH(30));
    }];
    

}

@end
