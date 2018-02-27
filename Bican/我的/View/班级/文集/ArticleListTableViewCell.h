//
//  ArticleListTableViewCell.h
//  Bican
//
//  Created by bican on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleListTableViewCell;
@protocol ArticleListCellDelegate <NSObject>

- (void)moreButtonClickWithCell:(ArticleListTableViewCell *)cell;

@end

@interface ArticleListTableViewCell : UITableViewCell

@property (nonatomic, assign) id <ArticleListCellDelegate> delegate;

- (void)setArticleListCellWithBigType:(NSString *)bigType
                             TypeName:(NSString *)typeName
                                 Date:(NSString *)date
                       AppraiseStatus:(NSString *)appraiseStatus
                    AppraiseStatusStr:(NSString *)appraiseStatusStr
                                Title:(NSString *)title;

@end
