//
//  MyClassTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MyClassTableViewCell.h"

@interface MyClassTableViewCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *thisWeekLabel;
@property (nonatomic, strong) UILabel *historyAllLabel;
@property (nonatomic, strong) UILabel *noReadLabel;
@property (nonatomic, strong) UIButton *removeStuButton;
@property (nonatomic, strong) UIView *lineView;


@end

@implementation MyClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}


- (void)createMyClassTableViewCellWithFirstName:(NSString *)firstName
                                       LastName:(NSString *)lastName
                              AllUnCommentCount:(NSString *)allUnCommentCount
                                       AllCount:(NSString *)allCount
                                 UnCommentCount:(NSString *)unCommentCount
{
        self.nameLabel.text = [NSString stringWithFormat:@"%@%@", firstName, lastName];
        self.thisWeekLabel.text = [NSString stringWithFormat:@"本周提交文章%@篇", unCommentCount];
        self.historyAllLabel.text = [NSString stringWithFormat:@"历史总共提交%@篇", allCount];
        self.noReadLabel.text = [NSString stringWithFormat:@"历史未评阅%@篇", allUnCommentCount];
        self.thisWeekLabel.attributedText = [UILabel changeLabel:self.thisWeekLabel Color:ZTDarkRedColor Loc:6 Len:2 Font:self.thisWeekLabel.font];
}

- (void)createSubViews
{
    CGFloat width = (ScreenWidth - GTW(30) * 4 - GTW(40)) / 3;
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.text = @"欧阳娜娜";
    self.nameLabel.textColor = ZTTitleColor;
    self.nameLabel.font = FONT(26);
    self.nameLabel.numberOfLines = 0;
    [self.contentView addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.width.mas_equalTo(width);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    self.removeStuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.removeStuButton setTitle:@"移\n除\n学\n生" forState:UIControlStateNormal];
    [self.removeStuButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    self.removeStuButton.titleLabel.font = FONT(24);
    self.removeStuButton.titleLabel.numberOfLines = [self.removeStuButton.titleLabel.text length];
    [self.removeStuButton addTarget:self action:@selector(removeStuButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.removeStuButton];
    
    [self.removeStuButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(GTW(40));
    }];
    
    self.thisWeekLabel = [[UILabel alloc] init];
    self.thisWeekLabel.textColor =  ZTTitleColor;
    self.thisWeekLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(24)];
    [self.contentView addSubview:self.thisWeekLabel];
    
    [self.thisWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width * 2);
        make.left.equalTo(self.nameLabel.mas_right).offset(GTW(30));
        make.top.equalTo(self.contentView.mas_top).offset(GTH(40));
    }];
    
    self.historyAllLabel = [[UILabel alloc] init];
    self.historyAllLabel.textColor = ZTTextGrayColor;
    self.historyAllLabel.font = FONT(20);
    [self.contentView addSubview:self.historyAllLabel];
    
    [self.historyAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.thisWeekLabel);
        make.top.equalTo(self.thisWeekLabel.mas_bottom).offset(GTH(10));
    }];
    
    self.noReadLabel = [[UILabel alloc] init];
    self.noReadLabel.textColor = ZTTextGrayColor;
    self.noReadLabel.font = FONT(20);
    [self.contentView addSubview:self.noReadLabel];
    
    [self.noReadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.historyAllLabel);
        make.top.equalTo(self.historyAllLabel.mas_bottom).offset(GTH(10));
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];

    
}

- (void)removeStuButtonAction
{
    if ([self.delegate respondsToSelector:@selector(removeStudentWithCell:)]) {
        [self.delegate removeStudentWithCell:self];
    }
}



@end
