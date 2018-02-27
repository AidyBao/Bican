//
//  InvitFooterView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/25.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "BaseView.h"

@class InvitFooterView;
@protocol InvitFooterViewDelegate <NSObject>

- (void)buttonToAskWithView:(InvitFooterView *)view;

- (void)buttonToSureWithView:(InvitFooterView *)view;

- (void)buttonToNoWithView:(InvitFooterView *)view;

@end

@interface InvitFooterView : BaseView

@property (nonatomic, assign) id <InvitFooterViewDelegate> delegate;

//文字 || 文字 + askButton
- (void)createInvitFooterViewWithTitle:(NSString *)title
                                 Color:(UIColor *)color
                       IsShowAskButton:(BOOL)isShowAskButton;

//文字 + 一个按钮
- (void)createInvitFooterViewWithTitle:(NSString *)title
                            TitleColor:(UIColor *)titleColor
                           ButtonTitle:(NSString *)buttonTitle;

//文字 + 两个按钮
- (void)createInvitFooterViewWithTitle:(NSString *)title
                            TitleColor:(UIColor *)titleColor
                       SureButtonTitle:(NSString *)sureButtonTitle
                         NoButtonTitle:(NSString *)noButtonTitle;


@end
