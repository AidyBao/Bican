//
//  CompositionSelectedTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CompositionSelectedTableViewCell;
@protocol CompositionSelectedCellDelegate <NSObject>

- (void)selecetedCell:(CompositionSelectedTableViewCell *)cell;

@end

@interface CompositionSelectedTableViewCell : UITableViewCell

@property (nonatomic, assign) id <CompositionSelectedCellDelegate> delegate;

- (void)setCompositionSelectedCellWithLeftTopText:(NSString *)leftTopText
                                     RightTopText:(NSString *)rightTopText
                                   LeftBottomText:(NSString *)leftBottomText;

- (void)setCellIsSelected:(NSString *)isSelected;

@end
