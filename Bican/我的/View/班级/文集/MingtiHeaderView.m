//
//  MingtiHeaderView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/27.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MingtiHeaderView.h"

@interface MingtiHeaderView ()

@property (nonatomic, strong) UIView *backWhiteView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation MingtiHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}


- (void)setMingtiHeaderViewWithContent:(NSString *)content
                            ImageArray:(NSMutableArray *)imageArray
{
    
    if ([NSString isHtmlString:content]) {
        [self.contentLabel htmlStringToChangeWithLabel:self.contentLabel String:content];
    } else {
        self.contentLabel.text = content;
    }
    self.contentLabel.font = FONT(28);
    
    if (imageArray.count != 0) {
        CGFloat image_height = GTH(210);
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.masksToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
            [self addSubview:imageView];
            
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(GTW(30));
                make.width.mas_equalTo(ScreenWidth - GTW(30) * 4);
                make.height.mas_equalTo(image_height);
                make.top.equalTo(self.contentLabel.mas_bottom).offset(image_height * i + GTH(10) * (i + 1));
            }];
            
        }
        
    }
}

- (void)createSubViews
{
    self.backWhiteView = [[UIView alloc] init];
    self.backWhiteView.backgroundColor = [UIColor whiteColor];
    self.backWhiteView.layer.shadowColor = RGBA(127, 127, 127, 1).CGColor;
    self.backWhiteView.layer.shadowOpacity = 0.24f;
    self.backWhiteView.layer.shadowRadius = GTH(20);
    self.backWhiteView.layer.cornerRadius = GTH(20);
    [self addSubview:self.backWhiteView];
    
    [self.backWhiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top).offset(GTH(30));
        make.bottom.equalTo(self.mas_bottom).offset(GTH(-30));
    }];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.numberOfLines = 0;
    [self addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backWhiteView.mas_top).offset(GTH(30));
        make.left.equalTo(self.backWhiteView.mas_left).offset(GTW(30));
        make.right.equalTo(self.backWhiteView.mas_right).offset(GTW(-30));
    }];
    
    
}

@end
