//
//  SearchUserTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchUserTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@end
