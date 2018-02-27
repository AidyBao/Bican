//
//  SelectCompositionTableViewCell.h
//  Bican
//
//  Created by bican on 2018/1/9.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelectCompositionTableViewCell;
@protocol SelectCompositionTableViewCellDelegate <NSObject>

- (void)selectCompositionToRecommend:(SelectCompositionTableViewCell *)cell;

@end

@interface SelectCompositionTableViewCell : UITableViewCell

@property (nonatomic, assign) id<SelectCompositionTableViewCellDelegate>delegate;

- (void)createSelectCompositionControllerWithBigTypeName:(NSString *)bigTypeName
                                                   Title:(NSString *)title
                                             IsRecommend:(NSString *)isRecommend;

@end
