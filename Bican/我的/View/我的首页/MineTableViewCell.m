//
//  MineTableViewCell.m
//  Bican
//
//  Created by chichen on 2017/12/24.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MineTableViewCell.h"

@interface MineTableViewCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *goImageView;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MineTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
    
}

- (void)setMineTableViewCellWithLeftText:(NSString *)leftText
                                LeftFont:(UIFont *)leftFont
                               LeftColor:(UIColor *)leftColor
                               RightText:(NSString *)rightText
                               RightFont:(UIFont *)rightFont
                              RightColor:(UIColor *)rightColor
                            IsShowButton:(BOOL)isShowButton;
{
    self.titleLabel.text = leftText;
    self.titleLabel.font = leftFont;
    self.titleLabel.textColor = leftColor;

    //是否显示右侧文字
    if (rightText.length != 0) {
        self.contentLabel.hidden = NO;
        self.contentLabel.text = rightText;
        self.contentLabel.font = rightFont;
        self.contentLabel.textColor = rightColor;

    } else {
        self.contentLabel.hidden = YES;
    }
    
    //是否显示按钮
    if (isShowButton) {
        self.goImageView.hidden = NO;
    } else {
        self.goImageView.hidden = YES;
        //不显示按钮, 但有右侧文字 --> 修改右侧文字的约束
        if (rightText.length != 0) {
            [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.contentView.mas_right).offset(-GTW(28));
            }];
        }
    }
    

    
}

- (void)createSubViews
{
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo((ScreenWidth - GTW(28) * 2 - GTW(10)) / 2);
    }];
    
    self.goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode-link-icon"]];
    [self.contentView addSubview:self.goImageView];
    
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(GTW(16), GTH(28)));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goImageView.mas_left).offset(-GTW(10));
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(self.titleLabel);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineView];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.equalTo(self.contentView.mas_left).offset(GTW(30));
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(1);
    }];
    
    
}

@end
