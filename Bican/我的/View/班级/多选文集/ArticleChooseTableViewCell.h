//
//  ArticleChooseTableViewCell.h
//  Bican
//
//  Created by bican on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleChooseTableViewCell;
@protocol ArticleChooseTableViewCellDelegate <NSObject>

- (void)selecetedCell:(ArticleChooseTableViewCell *)cell;

@end

@interface ArticleChooseTableViewCell : UITableViewCell


- (void)setArticleChooseCellWithBigType:(NSString *)bigType
                             TypeName:(NSString *)typeName
                                 Date:(NSString *)date
                       AppraiseStatus:(NSString *)appraiseStatus
                    AppraiseStatusStr:(NSString *)appraiseStatusStr
                                Title:(NSString *)title;

- (void)setCellIsSelected:(NSString *)isSelected;

@property (nonatomic, assign) id <ArticleChooseTableViewCellDelegate> delegate;

@end
