//
//  SearchCompositionTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "SearchCompositionTableViewCell.h"

@implementation SearchCompositionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"送积分了开始点击福利开始就克鲁塞德就了看了就是打开了发就是的了就是的";
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.width.mas_equalTo(ScreenWidth - GTW(28) * 2);
        make.top.equalTo(self.contentView.mas_top).offset(GTH(30));
    }];
    
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.text = @"自由写 · 日常";
    self.typeLabel.font = FONT(24);
    self.typeLabel.textColor = ZTTextLightGrayColor;
    [self.contentView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.width.mas_equalTo((ScreenWidth - GTW(28) * 2) / 2);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(30));
    }];
    
    self.classLabel = [[UILabel alloc] init];
    self.classLabel.text = @"汪汪汪 | 成都释放同学同学";
    self.classLabel.font = FONT(24);
    self.classLabel.textColor = ZTTextLightGrayColor;
    self.classLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.classLabel];
   
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel);
        make.width.centerY.equalTo(self.typeLabel);
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineLabel];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
    }];
                               
    
}

#pragma mark - 关键字高亮
- (void)setKeyWord:(NSString *)keyWord
{
    if (keyWord.length == 0) {
        self.titleLabel.textColor = ZTTitleColor;
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    NSRange range = [self.titleLabel.text rangeOfString:keyWord];
    UIColor *highlightedColor = ZTOrangeColor;
    [attributedString addAttribute:NSForegroundColorAttributeName value:highlightedColor range:range];
    self.titleLabel.attributedText = attributedString;
}


@end
