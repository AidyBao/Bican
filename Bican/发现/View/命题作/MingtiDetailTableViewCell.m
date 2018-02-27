//
//  MingtiDetailTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/6.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MingtiDetailTableViewCell.h"

@interface MingtiDetailTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UIView *bigLineView;

@end

@implementation MingtiDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setMingtiDetailCellWithHeaderImage:(NSString *)headerImage
                                  NickName:(NSString *)nickName
                                SchoolName:(NSString *)schoolName
                                     Title:(NSString *)title
                                   Content:(NSString *)content
                                ReadNumber:(NSString *)readNumber
                              PraiseNumber:(NSString *)praiseNumber
                          CollectionNumber:(NSString *)collectionNumber
                             CommentNumber:(NSString *)commentNumber
{
    if (headerImage.length != 0) {
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImage] placeholderImage:[UIImage imageNamed:@"my_header"]];
    }
    self.nameLabel.text = nickName;
    self.classLabel.text = schoolName;
    self.titleLabel.text = title;
    //设置间距
    self.titleLabel.attributedText = [UILabel setLabelSpace:self.titleLabel withValue:self.titleLabel.text withFont:self.titleLabel.font];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if ([NSString isHtmlString:content]) {
        [self.contentLabel htmlStringToChangeWithLabel:self.contentLabel String:content];
    } else {
        self.contentLabel.text = content;
    }
    self.contentLabel.font = FONT(28);
    
    if (readNumber.length == 0) {
        readNumber = @"0";
    }
    if ([readNumber integerValue] > 999) {
        readNumber = @"999+";
    }
    if (praiseNumber.length == 0) {
        praiseNumber = @"0";
    }
    if ([praiseNumber integerValue] > 999) {
        praiseNumber = @"999+";
    }
    if (collectionNumber.length == 0) {
        collectionNumber = @"0";
    }
    if ([collectionNumber integerValue] > 999) {
        collectionNumber = @"999+";
    }
    if (commentNumber.length == 0) {
        commentNumber = @"0";
    }
    if ([commentNumber integerValue] > 999) {
        commentNumber = @"999+";
    }

    self.readLabel.text = [NSString stringWithFormat:@"%@ 阅读 · %@ 赞 · %@ 收藏 · %@ 评论", readNumber, praiseNumber, collectionNumber, commentNumber];


}

- (void)createSubViews
{
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.image = [UIImage imageNamed:@"my_header"];
    self.headerImageView.layer.cornerRadius = GTH(50) / 2;
    [self.contentView addSubview:self.headerImageView];

    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(GTH(50));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(36));
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
    }];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = ZTTextGrayColor;;
    self.nameLabel.font = FONT(28);
    [self.contentView addSubview:self.nameLabel];

    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(GTW(20));
        make.width.mas_equalTo(GTW(140));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(36));
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
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.nameLabel);
    }];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.classLabel);
        make.top.equalTo(self.classLabel.mas_bottom).offset(GTH(30));
    }];

    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.numberOfLines = 3;
    [self.contentView addSubview:self.contentLabel];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.classLabel);
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
        make.top.equalTo(self.readLabel.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(1);
    }];
}


@end
