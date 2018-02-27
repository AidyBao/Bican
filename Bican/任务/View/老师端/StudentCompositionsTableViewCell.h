//
//  StudentCompositionsTableViewCell.h
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentCompositionsTableViewCell : BaseTableViewCell

- (void)setStudentCompositionsCellWithLeftTopText:(NSString *)leftTopText
                                   LeftBottomText:(NSString *)leftBottomText
                                     RightTopText:(NSString *)rightTopText
                                  RightBottomText:(NSString *)rightBottomText
                                 RightBottomColor:(UIColor *)rightBottomColor;

@end
