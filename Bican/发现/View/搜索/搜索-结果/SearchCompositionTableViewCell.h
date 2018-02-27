//
//  SearchCompositionTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCompositionTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *keyWord;//关键字
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@end
