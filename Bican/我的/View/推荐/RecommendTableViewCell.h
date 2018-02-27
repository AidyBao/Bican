//
//  RecommendTableViewCell.h
//  Bican
//
//  Created by bican on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendTableViewCell : UITableViewCell

- (void)createRecommendTableViewWithNickname:(NSString *)nickname
                                 BigTypeName:(NSString *)bigTypeName
                               RecommendDate:(NSString *)recommendDate
                                ArticleTitle:(NSString *)articleTitle;

@end
