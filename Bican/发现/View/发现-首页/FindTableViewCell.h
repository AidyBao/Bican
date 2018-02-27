//
//  FindTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/22.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindListModel.h"

@interface FindTableViewCell : UITableViewCell

//修改类型以及赋值
- (void)createTypeLabelWithModel:(FindListModel *)model;

- (void)createFindCellWithHeaderImage:(NSString *)headerImage
                                 Name:(NSString *)name
                           SchoolName:(NSString *)schoolName
                                Title:(NSString *)title
                              Content:(NSString *)content
                                 Read:(NSString *)read
                               Praise:(NSString *)praise
                           Collection:(NSString *)collection
                              Comment:(NSString *)comment;

@property (nonatomic, strong) FindListModel *findListModel;

@end
