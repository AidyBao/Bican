//
//  GiftTipView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GiftTipViewDelegate <NSObject>

- (void)closeButtonClick;

- (void)checkButtonClick;

@end

@interface GiftTipView : BaseView

@property (nonatomic, assign) id <GiftTipViewDelegate> delegate;

@end
