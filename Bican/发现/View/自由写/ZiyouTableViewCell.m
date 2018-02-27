//
//  ZiyouTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/30.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZiyouTableViewCell.h"

@interface ZiyouTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UIView *bigLineView;

@end

@implementation ZiyouTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createTypeLabelWithString:(NSString *)string
{
    //类型
    self.typeLabel.text = string;
    
    CGSize typeSize = [self.typeLabel getSizeWithString:string font:self.typeLabel.font str_height:GTH(44)];
    
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
        make.width.height.mas_equalTo(GTH(50));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(34));
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
    }];
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.backgroundColor = ZTTextLightGrayColor;
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.font = FONT(24);
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(34));
        make.width.mas_equalTo(GTW(106));
        make.height.mas_equalTo(GTH(44));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = ZTTextGrayColor;;
    self.nameLabel.font = FONT(28);
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(GTW(20));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(34));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(GTW(16));
        make.top.height.equalTo(self.nameLabel);
        make.width.mas_equalTo(1);
    }];
    
    self.classLabel = [[UILabel alloc] init];
    self.classLabel.numberOfLines = 0;
    self.classLabel.font = FONT(28);
    self.classLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.classLabel];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(GTW(16));
        make.right.equalTo(self.typeLabel.mas_left).offset(GTW(-20));
        make.top.equalTo(self.nameLabel);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.typeLabel);
        make.top.equalTo(self.classLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.font = FONT(28);
    self.contentLabel.numberOfLines = 3;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(GTH(120));
    }];
    
    self.readLabel = [[UILabel alloc] init];
    self.readLabel.font = FONT(24);
    self.readLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.readLabel];
    
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.bigLineView = [[UIView alloc] init];
    self.bigLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.bigLineView];
    
    [self.bigLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    
}

- (void)setFindListModel:(FindListModel *)findListModel
{
    _findListModel = findListModel;
   
    //头像
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:_findListModel.avatar] placeholderImage:[UIImage imageNamed:@"my_header"]];
    //姓名
    self.nameLabel.text = _findListModel.nickname;
    //学校
    self.classLabel.text = _findListModel.schoolName;
    //题目
    self.titleLabel.text = _findListModel.title;
    //内容
    if ([NSString isHtmlString:_findListModel.content]) {
        [self.contentLabel htmlStringToChangeWithLabel:self.contentLabel String:_findListModel.content];
    } else {
        self.contentLabel.text = _findListModel.content;
    }
    self.contentLabel.font = FONT(28);
    //设置间距
    self.contentLabel.attributedText = [UILabel setLabelSpace:self.contentLabel withValue:self.contentLabel.text withFont:self.contentLabel.font];
    self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //阅读 赞 收藏 评论
    NSString *read = [NSString string];
    if (_findListModel.readNumber.length == 0) {
        read = @"0";
    } else if ([_findListModel.readNumber integerValue] > 999) {
        read = @"999+";
    } else {
        read = _findListModel.readNumber;
    }
    NSString *praise = [NSString string];
    if (_findListModel.praiseNumber.length == 0) {
        praise = @"0";
    } else if ([_findListModel.praiseNumber integerValue] > 999) {
        praise = @"999+";
    } else {
        praise = _findListModel.praiseNumber;
    }
    NSString *collection = [NSString string];
    if (_findListModel.collectionNumber.length == 0) {
        collection = @"0";
    } else if ([_findListModel.collectionNumber integerValue] > 999) {
        collection = @"999+";
    } else {
        collection = _findListModel.collectionNumber;
    }
    NSString *comment = [NSString string];
    if (_findListModel.commentNumber.length == 0) {
        comment = @"0";
    } else if ([_findListModel.commentNumber integerValue] > 999) {
        comment = @"999+";
    } else {
        comment = _findListModel.commentNumber;
    }

    self.readLabel.text = [NSString stringWithFormat:@"%@ 阅读 · %@ 赞 · %@ 收藏 · %@ 评论", read, praise, collection, comment];
    
}







@end
