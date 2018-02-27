//
//  AnnotationListTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2018/1/18.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnnotationListTableViewCell : UITableViewCell

- (void)setCellSeletedWithBorderColor:(UIColor *)borderColor BorderWidth:(CGFloat)borderWidth;

- (void)setAnnotationListCellWithName:(NSString *)name Page:(NSString *)page Content:(NSString *)content;

@end
