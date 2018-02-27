//
//  MissionClassTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MissionClassTableViewCell.h"

@interface MissionClassTableViewCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *goImageView;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation MissionClassTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
    
}

- (void)createMissionGradeTableViewWithFirstName:(NSString *)firstName
                                        LastName:(NSString *)lastName
                                       WordCount:(NSString *)wordCount
                                     InviteCount:(NSString *)inviteCount
{
    self.leftLabel.text = [NSString stringWithFormat:@"%@%@", firstName, lastName];
    self.centerLabel.text = [NSString stringWithFormat:@"本周完成%@字", wordCount];
    self.rightLabel.text = [NSString stringWithFormat:@"%@篇作文未评阅", inviteCount];
}


- (void)createSubViews
{
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.font = FONT(30);
    self.leftLabel.textColor = ZTTitleColor;
    [self.contentView addSubview:self.leftLabel];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.width.mas_equalTo(GTW(160));
    }];
    
    self.goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode-link-icon"]];
    [self.contentView addSubview:self.goImageView];
    
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(GTW(16), GTH(28)));
    }];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.font = FONT(28);
    self.rightLabel.textColor = ZTTextLightGrayColor;
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.rightLabel];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goImageView.mas_left).offset(GTW(-10));
        make.top.height.equalTo(self.contentView);
        make.width.mas_equalTo(GTW(240));
    }];

    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.font = FONT(28);
    self.centerLabel.textColor = ZTTextGrayColor;
    self.centerLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.centerLabel];
    
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightLabel.mas_left).offset(GTW(-10));
        make.left.equalTo(self.leftLabel.mas_right).offset(GTW(10));
        make.top.height.equalTo(self.contentView);
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineLabel];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.equalTo(self.leftLabel);
        make.right.equalTo(self.goImageView);
    }];
    
}


@end
