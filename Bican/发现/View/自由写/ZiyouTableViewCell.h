//
//  ZiyouTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/30.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindListModel.h"

@interface ZiyouTableViewCell : UITableViewCell

- (void)createTypeLabelWithString:(NSString *)string;

@property (nonatomic, strong) FindListModel *findListModel;

@end
