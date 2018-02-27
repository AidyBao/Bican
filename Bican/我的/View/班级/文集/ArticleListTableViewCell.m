//
//  ArticleListTableViewCell.m
//  Bican
//
//  Created by bican on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ArticleListTableViewCell.h"

@interface ArticleListTableViewCell ()

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *readStateLabel;
@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, strong) UIView *topLineView;

@end

@implementation ArticleListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setArticleListCellWithBigType:(NSString *)bigType
                             TypeName:(NSString *)typeName
                                 Date:(NSString *)date
                       AppraiseStatus:(NSString *)appraiseStatus
                    AppraiseStatusStr:(NSString *)appraiseStatusStr
                                Title:(NSString *)title
{
    self.typeLabel.text = [NSString stringWithFormat:@"%@ | %@", bigType, typeName];
    self.timeLabel.text = date;
    self.readStateLabel.text = appraiseStatusStr;
    if ([appraiseStatus isEqualToString:@"0"]) {
        //未评阅
        self.readStateLabel.textColor = ZTOrangeColor;
    } else {
        //已评阅
        self.readStateLabel.textColor = ZTTitleColor;
    }
    if (title.length != 0) {
        if ([NSString isHtmlString:title]) {
            [self.titleLabel htmlStringToChangeWithLabel:self.titleLabel String:title];
        } else {
            self.titleLabel.text = title;
        }
        self.titleLabel.font = FONT(28);
    }

}

- (void)createSubViews
{
    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.topLineView];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = ZTTextLightGrayColor;
    self.typeLabel.font = FONT(24);
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(20));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = FONT(24);
    self.timeLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(GTW(30));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(20));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel);
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.typeLabel.mas_bottom).offset(GTH(25));
    }];
    
    self.contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentButton setImage:[UIImage imageNamed:@"unread"] forState:UIControlStateNormal];
    [self.contentButton addTarget:self action:@selector(contentButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.contentButton];
    
    [self.contentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(GTW(50), GTH(32)));
    }];
    
    self.readStateLabel = [[UILabel alloc] init];
    self.readStateLabel.font = FONT(24);
    [self.contentView addSubview:self.readStateLabel];
    
    [self.readStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentButton.mas_left).offset(GTW(-30));
        make.centerY.equalTo(self.contentView);
    }];
    
    
}

- (void)contentButtonAction
{
    if ([self.delegate respondsToSelector:@selector(moreButtonClickWithCell:)]) {
        [self.delegate moreButtonClickWithCell:self];
    }
}


@end
