//
//  CollectAndGoodTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/7.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectAndGoodTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *leftTopLabel;
@property (nonatomic, strong) UILabel *leftBottomLabel;
@property (nonatomic, strong) UILabel *rightTopLabel;
@property (nonatomic, strong) UILabel *rightBottomLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *redView;

//是否显示红点
- (void)setCollectAndGoodCellIsShowWarning:(NSString *)isShowWarning;

@end
