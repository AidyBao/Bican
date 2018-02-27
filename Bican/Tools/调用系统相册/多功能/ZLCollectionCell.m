//
//  ZLCollectionCell.m
//  多选相册照片
//
//  Created by long on 15/11/25.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ZLCollectionCell.h"

@implementation ZLCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
    {
        self = [super initWithFrame:frame];
        if (self) {
            [self createSubViews];
        }
        return self;
    }
    
- (void)createSubViews
    {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
        
        self.btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnSelect setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [self.btnSelect setImage:[UIImage imageNamed:@"checkbox_a"] forState:UIControlStateSelected];
        self.btnSelect.adjustsImageWhenHighlighted = NO;
        self.btnSelect.layer.cornerRadius = GTH(33) / 2;
        [self.btnSelect addTarget:self action:@selector(btnSelectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSelect];
        
        [self.btnSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_top).offset(GTH(16));
            make.right.equalTo(self.imageView.mas_right).offset(GTW(-20));
            make.width.height.mas_equalTo(GTH(33));
        }];
    }
    
    
- (void)btnSelectAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(selectedCell:Button:)]) {
        [self.delegate selectedCell:self Button:sender];
    }
}

@end
