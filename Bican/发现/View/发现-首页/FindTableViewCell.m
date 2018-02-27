//
//  FindTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/22.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "FindTableViewCell.h"

@interface FindTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImageView;//学生头像
@property (nonatomic, strong) UILabel *nameLabel;//学生姓名
@property (nonatomic, strong) UILabel *titleLabel;//文章标题
@property (nonatomic, strong) UILabel *typeLabel;//文章主题
@property (nonatomic, strong) UILabel *descLabel;//内容摘要
@property (nonatomic, strong) UILabel *countLabel;//阅读数
@property (nonatomic, strong) UILabel *lineLabel;//分割线
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation FindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createFindCellWithHeaderImage:(NSString *)headerImage
                                 Name:(NSString *)name
                           SchoolName:(NSString *)schoolName
                                Title:(NSString *)title
                              Content:(NSString *)content
                                 Read:(NSString *)read
                               Praise:(NSString *)praise
                           Collection:(NSString *)collection
                              Comment:(NSString *)comment
{
    //头像
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImage] placeholderImage:[UIImage imageNamed:@"my_header"]];
    //姓名 | 学校
    self.nameLabel.text = [NSString stringWithFormat:@"%@ | %@", name, schoolName];
    //标题
    self.titleLabel.text = title;
    //设置间距
    self.titleLabel.attributedText = [UILabel setLabelSpace:self.titleLabel withValue:self.titleLabel.text withFont:self.titleLabel.font];
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //内容
    //判断是否为html字符串
    if ([NSString isHtmlString:content]) {
        [self.descLabel htmlStringToChangeWithLabel:self.descLabel String:content];
    } else {
        self.descLabel.text = content;
    }
    self.descLabel.font = FONT(28);

    //底部
    if (read.length == 0) {
        read = @"0";
    } else if ([read integerValue] > 999) {
        read = @"999+";
    }
    if (praise.length == 0) {
        praise = @"0";
    } else if ([praise integerValue] > 999) {
        praise = @"999+";
    }
    if (collection.length == 0) {
        collection = @"0";
    } else if ([collection integerValue] > 999) {
        collection = @"999+";
    }
    if (comment.length == 0) {
        comment = @"0";
    } else if ([comment integerValue] > 999) {
        comment = @"999+";
    }
    self.countLabel.text = [NSString stringWithFormat:@"%@ 阅读 · %@ 赞 · %@ 收藏 · %@ 评论", read, praise, collection, comment];
}

//修改类型的部分
- (void)createTypeLabelWithModel:(FindListModel *)model
{
    //类型
    NSString *type = [NSString string];
    if (model.typeId.length == 0) {
        type = model.bigTypeName;
    } else {
        type = [NSString stringWithFormat:@"%@-%@", model.bigTypeName, model.typeName];
    }
    self.typeLabel.text = type;

    CGSize typeSize = [self.typeLabel getSizeWithString:type font:self.typeLabel.font str_height:GTH(44)];

    [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(typeSize.width);
    }];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth - typeSize.width - GTH(50) - GTW(30) * 4);
    }];
   
   self.typeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, typeSize.width, GTH(44))];
    
}


- (void)createSubViews
{

    //学生头像
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = GTH(50) / 2;
    self.headerImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(GTH(50));
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(36));
    }];
    
    //学生姓名
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = FONT(28);
    self.nameLabel.textColor = ZTTextGrayColor;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(GTW(30));
        make.width.mas_equalTo(GTW(120));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(36));
    }];
    
    //作文主题
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.backgroundColor = RGBA(187, 187, 187, 1);
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.font = FONT(24);
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-GTW(30));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(36));
        make.height.mas_equalTo(GTH(44));
        make.width.mas_equalTo(GTW(220));
    }];

    //文章标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = ZTTitleColor;
    //字体加粗
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.contentView).offset(GTW(-30));
        make.top.equalTo(self.headerImageView.mas_bottom).offset(GTH(34));
    }];
    
    //文章摘要
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.numberOfLines = 3;
    self.descLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.descLabel];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(28));
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.typeLabel);
        make.height.mas_equalTo(GTH(120));
    }];
    
    //阅读数
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textColor = ZTTextLightGrayColor;
    self.countLabel.font = FONT(24);
    [self.contentView addSubview:self.countLabel];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.typeLabel);
        make.top.equalTo(self.descLabel.mas_bottom).offset(GTH(30));
    }];
    
    //分割线
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineLabel];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.right.equalTo(self.typeLabel);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    
}


@end
