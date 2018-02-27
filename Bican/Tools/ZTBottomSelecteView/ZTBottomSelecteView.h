//
//  ZTBottomSelecteView.h
//  Bican
//
//  Created by 迟宸 on 2017/12/29.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZTBottomSelecteViewDelegate <NSObject>
//选择的下标
- (void)selecetedIndex:(NSInteger)selecetedIndex;\
//取消按钮
- (void)cancelButtonClick;

@end

@interface ZTBottomSelecteView : BaseView

@property (nonatomic, assign) id <ZTBottomSelecteViewDelegate> delegate;

- (void)setZTBottomSelecteViewWithArray:(NSArray *)array
                      CancelButtonTitle:(NSString *)cancelButtonTitle
                              TextColor:(UIColor *)textColor
                               TextFont:(UIFont *)textFont
                      IsShowOrangeColor:(BOOL)isShowOrangeColor
                       OrangeColorIndex:(NSInteger)orangeColorIndex;

@end
