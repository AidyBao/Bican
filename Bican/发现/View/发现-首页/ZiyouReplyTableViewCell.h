//
//  ZiyouReplyTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZiyouReplyTableViewCell;
@protocol ZiyouReplyTableViewCellDelegate <NSObject>

- (void)replyButtonWithCell:(ZiyouReplyTableViewCell *)cell;

@end

@interface ZiyouReplyTableViewCell : UITableViewCell

@property (nonatomic, assign) id <ZiyouReplyTableViewCellDelegate> delegate;

- (void)setZiyouReplyCellWithHeadImage:(NSString *)headImage
                                  Name:(NSString *)name
                                  Date:(NSString *)date
                               Content:(NSString *)content
                           ButtonTitle:(NSString *)buttonTitle
                                   Tip:(NSString *)tip
                             IsShowTip:(BOOL)IsShowTip;

@end
