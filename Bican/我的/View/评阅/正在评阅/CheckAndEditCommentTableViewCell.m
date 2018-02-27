//
//  CheckAndEditCommentTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CheckAndEditCommentTableViewCell.h"

@interface CheckAndEditCommentTableViewCell ()

@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *typeContenLabel;
@property (nonatomic, strong) UIView *typeLineView;

@property (nonatomic, strong) UILabel *commenLabel;
@property (nonatomic, strong) UILabel *commentContentLabel;
@property (nonatomic, strong) UIView *commentLineView;

@end

@implementation CheckAndEditCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setCheckAndEditCommentCellWithContent:(NSString *)content Comment:(NSString *)comment
{
    self.typeContenLabel.text = content;
    self.commentContentLabel.text = comment;
}

- (void)createSubViews
{
    self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = FONT(26);
    [self.deleteButton addTarget:self action:@selector(deleteComment) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.deleteButton];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(GTH(30));
        make.right.equalTo(self.contentView).offset(GTW(-30));
        make.size.mas_equalTo(CGSizeMake(GTW(60), GTH(40)));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor =ZTOrangeColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.deleteButton.mas_left).offset(GTW(-30));
        make.centerY.equalTo(self.deleteButton);
        make.width.mas_equalTo(1.5);
        make.height.mas_equalTo(GTH(30));
    }];
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    self.editButton.titleLabel.font = FONT(26);
    [self.editButton addTarget:self action:@selector(editComment) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.editButton];
    
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.deleteButton);
        make.right.equalTo(self.lineView.mas_left).offset(GTW(-30));
    }];
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.text = @"原文";
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.backgroundColor = ZTTextLightGrayColor;
    self.typeLabel.font = FONT(28);
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(68), GTH(44)));
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.top.equalTo(self.deleteButton.mas_bottom).offset(GTH(30));
    }];
    
    self.typeContenLabel = [[UILabel alloc] init];
    self.typeContenLabel.textColor = ZTTextLightGrayColor;
    self.typeContenLabel.font = FONT(28);
    self.typeContenLabel.numberOfLines = 0;
    [self.contentView addSubview:self.typeContenLabel];
    
    [self.typeContenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(GTW(10));
        make.top.equalTo(self.typeLabel);
        make.right.equalTo(self.deleteButton);
    }];
    
    self.typeLineView = [[UIView alloc] init];
    self.typeLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.typeLineView];
    
    [self.typeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.equalTo(self.typeContenLabel.mas_bottom).offset(GTH(30));
        make.left.right.equalTo(self.typeContenLabel);
    }];
    
    self.commenLabel = [[UILabel alloc] init];
    self.commenLabel.text = @"批注";
    self.commenLabel.textColor = [UIColor whiteColor];
    self.commenLabel.backgroundColor = ZTOrangeColor;
    self.commenLabel.font = FONT(28);
    self.commenLabel.textAlignment = NSTextAlignmentCenter;
    self.commenLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.contentView addSubview:self.commenLabel];
    
    [self.commenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(68), GTH(44)));
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.top.equalTo(self.typeLineView.mas_bottom).offset(GTH(30));
    }];
    
    self.commentContentLabel = [[UILabel alloc] init];
    self.commentContentLabel.textColor = ZTTextLightGrayColor;
    self.commentContentLabel.font = FONT(28);
    self.commentContentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.commentContentLabel];
    
    [self.commentContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.commenLabel.mas_right).offset(GTW(10));
        make.top.equalTo(self.commenLabel);
        make.right.equalTo(self.deleteButton);
    }];
    
    self.commentLineView = [[UIView alloc] init];
    self.commentLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.commentLineView];
    
    [self.commentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.equalTo(self.commentContentLabel.mas_bottom).offset(GTH(30));
        make.left.right.equalTo(self.commentContentLabel);
    }];
    
    
}

- (void)deleteComment
{
    if ([self.delegate respondsToSelector:@selector(toDeleteCommentWihtCell:)]) {
        [self.delegate toDeleteCommentWihtCell:self];
    }
}

- (void)editComment
{
    if ([self.delegate respondsToSelector:@selector(toEditCommentWihtCell:)]) {
        [self.delegate toEditCommentWihtCell:self];
    }
}


@end
