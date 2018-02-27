//
//  StudentCompositionsTableViewCell.m
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "StudentCompositionsTableViewCell.h"

@interface StudentCompositionsTableViewCell ()

@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UILabel *leftTopLabel;
@property (nonatomic, strong) UILabel *leftBottomLabel;
@property (nonatomic, strong) UILabel *rightTopLabel;
@property (nonatomic, strong) UIButton *rightBottomButton;

@end

@implementation StudentCompositionsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setStudentCompositionsCellWithLeftTopText:(NSString *)leftTopText
                                   LeftBottomText:(NSString *)leftBottomText
                                     RightTopText:(NSString *)rightTopText
                                  RightBottomText:(NSString *)rightBottomText
                                 RightBottomColor:(UIColor *)rightBottomColor
{
    self.leftTopLabel.text = leftTopText;
    self.leftBottomLabel.text = leftBottomText;
    self.rightTopLabel.text = rightTopText;
    //设置文字
    if (rightBottomText.length != 0) {
        [self.rightBottomButton setImage:nil forState:UIControlStateNormal];
        [self.rightBottomButton setTitle:rightBottomText forState:UIControlStateNormal];
        [self.rightBottomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBottomButton setBackgroundColor:rightBottomColor];
        self.rightBottomButton.titleLabel.font = FONT(24);
        self.rightBottomButton.layer.cornerRadius = GTH(8);
        //计算文字的宽度
        CGSize size = [self getSizeWithString:rightBottomText font:self.rightBottomButton.titleLabel.font str_height:GTH(32)];
        
        [self.rightBottomButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(size.width + 5, GTH(32)));
        }];
        [self.leftBottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightBottomButton.mas_left).offset(GTW(-30));
        }];
        
    } else {
        //设置图片
        [self.rightBottomButton setImage:[UIImage imageNamed:@"unread"] forState:UIControlStateNormal];
        [self.rightBottomButton setTitle:@"" forState:UIControlStateNormal];
        [self.rightBottomButton setBackgroundColor:[UIColor clearColor]];
        [self.rightBottomButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(GTW(50), GTH(32)));
        }];
        [self.leftBottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightBottomButton.mas_left).offset(GTW(-30));
        }];
    }

    
}

- (void)createSubViews
{
    self.leftTopLabel = [[UILabel alloc] init];
    self.leftTopLabel.textColor = ZTTextLightGrayColor;
    self.leftTopLabel.font = FONT(24);
    [self.contentView addSubview:self.leftTopLabel];
    
    [self.leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(GTW(28));
        make.top.equalTo(self.contentView).offset(GTH(23));
    }];
    
    self.leftBottomLabel = [[UILabel alloc] init];
    self.leftBottomLabel.textColor = ZTTitleColor;
    self.leftBottomLabel.font = FONT(28);
    [self.contentView addSubview:self.leftBottomLabel];
    
    [self.leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.equalTo(self.leftTopLabel);
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-30) * 2 - GTW(50));
        make.top.equalTo(self.leftTopLabel.mas_bottom).offset(GTH(26));
    }];
    
    self.rightTopLabel = [[UILabel alloc] init];
    self.rightTopLabel.textColor = ZTTextLightGrayColor;
    self.rightTopLabel.font = FONT(24);
    [self.contentView addSubview:self.rightTopLabel];
    
    [self.rightTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.leftTopLabel);
        make.right.equalTo(self.contentView.mas_right).offset(GTW(-28));
    }];
    
    self.rightBottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBottomButton.adjustsImageWhenHighlighted = NO;
    [self.rightBottomButton addTarget:self action:@selector(rightBottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.rightBottomButton];
    
    [self.rightBottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightTopLabel);
        make.size.mas_equalTo(CGSizeMake(GTW(50), GTH(32)));
        make.centerY.equalTo(self.leftBottomLabel);
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = ZTLineGrayColor;
    [self.contentView addSubview:self.lineLabel];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTopLabel);
        make.right.equalTo(self.rightTopLabel);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
}


- (void)rightBottomButtonAction
{
    
}



@end
