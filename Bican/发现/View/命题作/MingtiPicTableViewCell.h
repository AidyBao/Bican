//
//  MingtiPicTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/2.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MingtiPicTableViewCell;
@protocol MingtiPicTableViewCellDelegate <NSObject>

- (void)selectedImageWithCell:(MingtiPicTableViewCell *)cell Index:(NSInteger)imageIndex;

@end

@interface MingtiPicTableViewCell : UITableViewCell

@property (nonatomic, assign) id <MingtiPicTableViewCellDelegate> delegate;

- (void)createMingtiPicCellWith:(NSArray *)array;

- (void)seMingtiPicCellWithFromUser:(NSString *)fromUser
                             FromTest:(NSString *)fromTest
                                 Type:(NSString *)type
                                Title:(NSString *)title
                              Content:(NSString *)content
                                Check:(NSString *)check
                                 Page:(NSString *)page;

@end
