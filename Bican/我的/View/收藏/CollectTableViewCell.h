//
//  CollectTableViewCell.h
//  Bican
//
//  Created by bican on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectTableViewCell : UITableViewCell

- (void)createCollectCellWithCollectTitle:(NSString *)title
                                   School:(NSString *)school
                                     Type:(NSString *)type
                              BigTypeName:(NSString *)bigTypeName
                           MemberNickName:(NSString *)memberNickName;

@end
