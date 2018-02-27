//
//  InviteChooseTableViewCell.h
//  Bican
//
//  Created by chichen on 2018/1/10.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InviteChooseTableViewCell;
@protocol InviteChooseTableViewCellDelegate<NSObject>

- (void)selecetedCell:(InviteChooseTableViewCell *)cell;

@end

@interface InviteChooseTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *giftLabel;

- (void)createInviteChooseCellWithNickname:(NSString *)nickname
                                SchoolName:(NSString *)schoolName
                                     Title:(NSString *)title
                                 Frequency:(NSString *)frequency
                                    Status:(NSString *)status
                                    Flower:(NSString *)flower;

- (void)setCellIsSelected:(NSString *)isSelected;

@property (nonatomic, assign) id <InviteChooseTableViewCellDelegate> delegate;

@end
