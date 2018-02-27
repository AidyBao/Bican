//
//  NowCorrectTableViewCell.h
//  Bican
//
//  Created by bican on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NowCorrectTableViewCell;
@protocol NowCorrectCellDelegate <NSObject>

- (void)commendArticleWithCell:(NowCorrectTableViewCell *)cell;

@end

@interface NowCorrectTableViewCell : UITableViewCell

@property (nonatomic, assign) id <NowCorrectCellDelegate> delegate;

- (void)createNowCorrectTableViewWithAvatar:(NSString *)avatar
                                   Nickname:(NSString *)nickname
                                 SchoolName:(NSString *)schoolName
                                BigTypeName:(NSString *)bigTypeName
                                      Title:(NSString *)title
                                    Summary:(NSString *)summary
                                     Flower:(NSString *)flower
                                   Relation:(NSString *)relation
                               SendDatetime:(NSString *)sendDatetime
                            ReceiveDatetime:(NSString *)receiveDatetime;

@end
