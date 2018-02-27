//
//  ArticleChooseTableViewCell.m
//  Bican
//
//  Created by bican on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ArticleChooseTableViewCell.h"

@interface ArticleChooseTableViewCell ()

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *readStateLabel;
@property (nonatomic, strong) UIButton *chooseButton;

@end

@implementation ArticleChooseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}


- (void)setArticleChooseCellWithBigType:(NSString *)bigType
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


- (void)setCellIsSelected:(NSString *)isSelected
{
    if (isSelected.length == 0) {
        self.chooseButton.selected = NO;
        self.chooseButton.userInteractionEnabled = NO;
        [self.chooseButton setBackgroundColor:ZTTextGrayColor];
        return;
    }
    self.chooseButton.userInteractionEnabled = YES;
    [self.chooseButton setBackgroundColor:[UIColor clearColor]];
    if ([isSelected isEqualToString:@"YES"]) {
        self.chooseButton.selected = YES;
    } else {
        self.chooseButton.selected = NO;
    }
}

- (void)createSubViews
{
    self.topLineView = [[UIView alloc] init];
    self.topLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.topLineView];
    
    [self.topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(1);
    }];
    
    
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseButton setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
    [self.chooseButton setImage:[UIImage imageNamed:@"checkbox_a"] forState:UIControlStateSelected];
    [self.chooseButton setBackgroundColor:[UIColor clearColor]];
    self.chooseButton.adjustsImageWhenHighlighted = NO;
    self.chooseButton.layer.cornerRadius = GTH(38) / 2;
    self.chooseButton.layer.masksToBounds = YES;
    [self.chooseButton addTarget:self action:@selector(chooseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.chooseButton];
    
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(GTW(30));
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(GTH(38), GTH(38)));
    }];
    
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = ZTTextLightGrayColor;
    self.typeLabel.font = FONT(24);
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(100));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(23));
    }];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = FONT(24);
    self.timeLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(GTW(30));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(23));
    }];
    
    self.readStateLabel = [[UILabel alloc] init];
    self.readStateLabel.textColor = ZTTitleColor;
    self.readStateLabel.font = FONT(24);
    self.readStateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.readStateLabel];
    
    [self.readStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.contentView);
    }];

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.font = FONT(28);
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.typeLabel);
        make.right.equalTo(self.readStateLabel.mas_left).offset(GTW(-20));
        make.top.equalTo(self.typeLabel.mas_bottom).offset(GTH(26));
    }];
    
}


- (void)chooseButtonAction
{
    if ([self.delegate respondsToSelector:@selector(selecetedCell:)]) {
        [self.delegate selecetedCell:self];
    }
    
}


@end
