//
//  FindSearchTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindSearchTableViewCell;
@protocol FindSearchCellDelegate <NSObject>

- (void)toDeleteCell:(FindSearchTableViewCell *)cell;

@end

@interface FindSearchTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, assign) id <FindSearchCellDelegate> delegate;

@end
