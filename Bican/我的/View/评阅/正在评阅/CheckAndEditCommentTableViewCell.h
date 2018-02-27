//
//  CheckAndEditCommentTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "BaseTableViewCell.h"

@class CheckAndEditCommentTableViewCell;
@protocol CheckAndEditCommentCellDelegate <NSObject>

- (void)toEditCommentWihtCell:(CheckAndEditCommentTableViewCell *)cell;

- (void)toDeleteCommentWihtCell:(CheckAndEditCommentTableViewCell *)cell;

@end

@interface CheckAndEditCommentTableViewCell : BaseTableViewCell

- (void)setCheckAndEditCommentCellWithContent:(NSString *)content Comment:(NSString *)comment;

@property (nonatomic, assign) id <CheckAndEditCommentCellDelegate> delegate;

@end
