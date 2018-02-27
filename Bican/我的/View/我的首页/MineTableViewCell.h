//
//  MineTableViewCell.h
//  Bican
//
//  Created by chichen on 2017/12/24.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineTableViewCell : UITableViewCell

//IsShowButton: 是否显示向右按钮
- (void)setMineTableViewCellWithLeftText:(NSString *)leftText
                                LeftFont:(UIFont *)leftFont
                               LeftColor:(UIColor *)leftColor
                               RightText:(NSString *)rightText
                               RightFont:(UIFont *)rightFont
                              RightColor:(UIColor *)rightColor
                            IsShowButton:(BOOL)isShowButton;

@property (nonatomic, strong) UILabel *contentLabel;

@end
