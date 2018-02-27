//
//  GiftExchangeWenbiTableViewCell.h
//  Bican
//
//  Created by bican on 2018/1/13.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiftExchangeWenbiTableViewCell;
@protocol GiftExchangeWenbiTableViewCellDelegate<NSObject>

- (void)selecetedCell:(GiftExchangeWenbiTableViewCell *)cell IsSelected:(BOOL)isSelected;


- (void)isAddFlower:(BOOL)isAddFlower WithCell:(GiftExchangeWenbiTableViewCell *)cell;

@end

@interface GiftExchangeWenbiTableViewCell : UITableViewCell

- (void)setCellIsSelectedAll:(BOOL)isSelected;

//currency:多少文币/朵, unit:单位(朵), 选中的数量
- (void)setGiftExchangeWenbiCellWithFlowerName:(NSString *)name
                                     FlowerPic:(NSString *)flowerPic
                                      Currency:(NSString *)currency
                                          Unit:(NSString *)unit
                                 SelectedCount:(NSString *)selectedCount;


@property (nonatomic, assign) id <GiftExchangeWenbiTableViewCellDelegate> delegate;

@end
