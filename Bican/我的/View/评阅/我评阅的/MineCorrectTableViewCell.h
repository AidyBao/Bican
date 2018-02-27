//
//  MineCorrectTableViewCell.h
//  Bican
//
//  Created by bican on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCorrectTableViewCell : UITableViewCell

- (void)createMineReviewTableViewWithAvatar:(NSString *)avatar
                                   Nickname:(NSString *)nickname
                                 SchoolName:(NSString *)schoolName
                                BigTypeName:(NSString *)bigTypeName
                                      Title:(NSString *)title
                                    Summary:(NSString *)summary
                                     Flower:(NSString *)flower
                            ArticleFraction:(NSString *)articleFraction;

@end
