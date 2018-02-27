//
//  UserIntroTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "UserIntroTableViewCell.h"

@interface UserIntroTableViewCell ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *readLabel;//评阅文章
@property (nonatomic, strong) UILabel *countLabel;//受邀次数
@property (nonatomic, strong) UILabel *rateLabel;//好评率
@property (nonatomic, strong) NSMutableArray *starArray;
@property (nonatomic, assign) double starRate;

@end

@implementation UserIntroTableViewCell

- (NSMutableArray *)starArray
{
    //总分5分
    if (!_starArray) {
        if (self.starRate * 20 >= 100) {//5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star1", nil];
            
        } else if (self.starRate * 20 > 80 && self.starRate * 20 < 100) {//4.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star2", nil];
            
        } else if (self.starRate * 20 == 80) {//4
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 > 60 && self.starRate * 20 < 80) {//3.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star2", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 == 60) {//3
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 > 40 && self.starRate * 20 < 60) {//2.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star2", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 == 40) {//2
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 > 20 && self.starRate * 20 < 40) {//1.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star2", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 == 20) {//1
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star3", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 > 0 && self.starRate * 20 < 20) {//0.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star2", @"yellow_star3", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 <= 0) {//0
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star3", @"yellow_star3", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
        }
        
    }
    return _starArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)changeButtonWithTitle:(NSString *)title Color:(UIColor *)color;
{
    [self.addButton setBackgroundColor:color];
    [self.addButton setTitle:title forState:UIControlStateNormal];
}


- (void)setCellWithHeadImage:(NSString *)headImage
                    NickName:(NSString *)nickName
                  SchoolName:(NSString *)schoolName
                       Grade:(NSString *)grade
                     Comment:(NSString *)comment
                      Invite:(NSString *)invite
                 IsAttention:(NSString *)isAttention
                      UserId:(NSString *)userId
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headImage] placeholderImage:[UIImage imageNamed:@"my_header"]];
    self.nameLabel.text = nickName;
    
    if (grade.length == 0) {
        self.classLabel.text = schoolName;
    } else if (schoolName.length == 0) {
        self.classLabel.text = grade;
    } else {
        self.classLabel.text = [NSString stringWithFormat:@"%@ · %@", schoolName, grade];
    }
    //评阅文章
    if (comment.length == 0) {
        self.readLabel.text = @"评阅文章 0";
    } else {
        self.readLabel.text = [NSString stringWithFormat:@"评阅文章 %@", comment];
    }
    //受邀次数
    if (invite.length == 0) {
        self.countLabel.text = @"受邀次数  0";
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"受邀次数  %@", invite];
    }
    if ([[GetUserInfo getUserInfoModel].userId isEqualToString:userId]) {
        self.addButton.hidden = YES;
    } else {
        self.addButton.hidden = NO;
        if ([isAttention isEqualToString:@"0"]) {
            [self.addButton setBackgroundColor:ZTOrangeColor];
            [self.addButton setTitle:@"+ 加关注" forState:UIControlStateNormal];
        } else {
            [self.addButton setBackgroundColor:ZTLineGrayColor];
            [self.addButton setTitle:@"已关注" forState:UIControlStateNormal];
            
        }
    }
    
}

- (void)setUserIntroCellStar:(NSString *)star
{
    self.starRate = [star doubleValue];
    CGFloat star_width = GTW(30);

    for (int i = 0; i < self.starArray.count; i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.image = [UIImage imageNamed:self.starArray[i]];
        [self.contentView addSubview:starImageView];
        
        [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rateLabel.mas_right).offset(GTW(10) + star_width * i);
            make.top.equalTo(self.lineLabel.mas_bottom).offset(GTH(29));
        }];
    }
    
}

- (void)createSubViews
{
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = GTH(100) / 2;
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.image = [UIImage imageNamed:@"my_header"];
    [self.contentView addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.equalTo(self.contentView).offset(GTH(40));
        make.width.height.mas_equalTo(GTH(100));
    }];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.addButton.titleLabel.font = FONT(30);
    [self.addButton setBackgroundColor:ZTOrangeColor];
    self.addButton.layer.cornerRadius = GTH(10);
    self.addButton.adjustsImageWhenHighlighted = NO;
    [self.addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.addButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(GTH(35));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.size.mas_equalTo(CGSizeMake(GTW(151), GTH(63)));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    self.nameLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(GTW(36));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(50));
        make.right.equalTo(self.addButton.mas_left).offset(GTW(-28));
    }];
    
    self.classLabel = [[UILabel alloc] init];
    self.classLabel.font = FONT(28);
    self.classLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.classLabel];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineLabel];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
        make.top.equalTo(self.headerImageView.mas_bottom).offset(GTH(25));
        make.height.mas_equalTo(1);
    }];
    
    CGFloat star_width = GTW(30);
    CGFloat rate_width = GTW(100);
    CGFloat label_width = (ScreenWidth - GTW(28) * 2 - rate_width - star_width * 5 - GTW(10) * 3) / 2;

    self.readLabel = [[UILabel alloc] init];
    self.readLabel.textColor = ZTTextLightGrayColor;
    self.readLabel.font = FONT(28);
    [self.contentView addSubview:self.readLabel];
    
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.top.equalTo(self.lineLabel.mas_bottom).offset(GTH(29));
        make.width.mas_equalTo(label_width);
    }];
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textColor = ZTTextLightGrayColor;
    self.countLabel.font = FONT(28);
    [self.contentView addSubview:self.countLabel];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.readLabel.mas_right).offset(GTW(10));
        make.top.width.equalTo(self.readLabel);
    }];

    self.rateLabel = [[UILabel alloc] init];
    self.rateLabel.textColor = ZTTextLightGrayColor;
    self.rateLabel.font = FONT(28);
    self.rateLabel.text = @"好评率";
    self.rateLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rateLabel];
    
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.mas_right).offset(GTW(10));
        make.top.equalTo(self.readLabel);
        make.width.mas_equalTo(rate_width);
    }];

    
}

- (void)addButtonAction
{
    if ([self.delegate respondsToSelector:@selector(attentionButtonWithCell:)]) {
        [self.delegate attentionButtonWithCell:self];
    }
}


@end
