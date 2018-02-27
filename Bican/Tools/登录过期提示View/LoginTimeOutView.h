//
//  LoginTimeOutView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/15.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginTimeOutViewDelegate <NSObject>

- (void)buttonToPush;

@end

typedef void (^SureButtonBlock)(id sure);
typedef void (^RemoveButtonBlock)(id remove);

@interface LoginTimeOutView : UIView

- (void)setLoginTimeOutViewWithTitle:(NSString *)title
                             Content:(NSString *)content
                         ButtonTitle:(NSString *)buttonTitle;

+ (instancetype)createCustomPromptViewWithTitle:(NSString *)title
                                        Content:(NSString *)content
                                SureButtonTitle:(NSString *)sureButtonTitle
                                    SureHandler:(SureButtonBlock)sure
                                  RemoveHandler:(RemoveButtonBlock)remove;

@property (nonatomic, assign) id <LoginTimeOutViewDelegate> delegate;

@end
