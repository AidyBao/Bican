//
//  MingtiTextTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2018/1/2.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MingtiTextTableViewCell.h"

@interface MingtiTextTableViewCell ()

@property (nonatomic, strong) UILabel *fromUserLabel;
@property (nonatomic, strong) UIView *fromUserLineView;
@property (nonatomic, strong) UILabel *fromTestLabel;
@property (nonatomic, strong) UIView *fromTestLineView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *readLabel;

@end

@implementation MingtiTextTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setMingtiTextCellWithFromUser:(NSString *)fromUser
                             FromTest:(NSString *)fromTest
                                 Type:(NSString *)type
                                Title:(NSString *)title
                              Content:(NSString *)content
                                Check:(NSString *)check
                                 Page:(NSString *)page
{
    self.fromUserLabel.text = fromUser;
    self.fromTestLabel.text = fromTest;
    self.typeLabel.text = type;
    self.titleLabel.text = title;
    if (check.length == 0) {
        check = @"0";
    } else if ([check integerValue] > 999) {
        check = @"999+";
    }
    if (page.length == 0) {
        page = @"0";
    } else if ([check integerValue] > 999) {
        page = @"999+";
    }
    self.readLabel.text = [NSString stringWithFormat:@"查看%@ · %@篇作文", check, page];
    
    if (content.length != 0) {
        //内容
        if ([NSString isHtmlString:content]) {
            [self.contentLabel htmlStringToChangeWithLabel:self.contentLabel String:content];
        } else {
            self.contentLabel.text = content;
        }
        self.contentLabel.font = FONT(28);
        self.contentLabel.attributedText = [UILabel setLabelSpace:self.contentLabel withValue:self.contentLabel.text withFont:self.contentLabel.font];
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }

}

- (void)createSubViews
{
    self.fromUserLabel = [[UILabel alloc] init];
    self.fromUserLabel.textColor = ZTTextGrayColor;
    self.fromUserLabel.font = FONT(28);
    [self.contentView addSubview:self.fromUserLabel];
    
    [self.fromUserLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(GTH(86));
    }];
    
    self.fromUserLineView = [[UIView alloc] init];
    self.fromUserLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.fromUserLineView];
    
    [self.fromUserLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fromUserLabel);
        make.bottom.equalTo(self.fromUserLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    self.fromTestLabel = [[UILabel alloc] init];
    self.fromTestLabel.textColor = ZTTextGrayColor;
    self.fromTestLabel.font = FONT(28);
    [self.contentView addSubview:self.fromTestLabel];
    
    [self.fromTestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.fromUserLabel);
        make.top.equalTo(self.fromUserLineView.mas_bottom);
    }];
    
    self.fromTestLineView = [[UIView alloc] init];
    self.fromTestLineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.fromTestLineView];
    
    [self.fromTestLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fromUserLabel);
        make.bottom.equalTo(self.fromTestLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.font = FONT(24);
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.backgroundColor = ZTOrangeColor;
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.fromUserLabel);
        make.top.equalTo(self.fromTestLineView.mas_bottom).offset(GTH(30));
        make.height.mas_equalTo(GTH(44));
        make.width.mas_equalTo(GTW(67));
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(GTW(40));
        make.top.equalTo(self.typeLabel);
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.numberOfLines = 3;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fromUserLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(45));
    }];
    
    self.readLabel = [[UILabel alloc] init];
    self.readLabel.font = FONT(24);
    self.readLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.readLabel];
    
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fromUserLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(GTH(36));
        make.height.mas_equalTo(GTH(23));
    }];
    
}


@end
