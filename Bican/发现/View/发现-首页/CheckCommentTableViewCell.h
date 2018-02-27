//
//  CheckCommentTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/13.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckCommentTableViewCell : UITableViewCell

- (void)setCheckCommentCellWithOriginal:(NSString *)original
                                Comment:(NSString *)comment
                                 Center:(NSString *)center
                           IsShowCenter:(BOOL)isShowCenter;


@end
