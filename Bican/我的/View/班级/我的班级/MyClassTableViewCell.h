//
//  MyClassTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyClassTableViewCell;
@protocol MyClassTableViewCellDelegate <NSObject>

- (void)removeStudentWithCell:(MyClassTableViewCell *)cell;

@end

@interface MyClassTableViewCell : UITableViewCell

@property (nonatomic, assign) id <MyClassTableViewCellDelegate> delegate;

- (void)createMyClassTableViewCellWithFirstName:(NSString *)firstName
                                       LastName:(NSString *)lastName
                              AllUnCommentCount:(NSString *)allUnCommentCount
                                       AllCount:(NSString *)allCount
                                 UnCommentCount:(NSString *)unCommentCount;

@end
