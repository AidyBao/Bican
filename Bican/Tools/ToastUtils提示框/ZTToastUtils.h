//
//  ZTToastUtils.h
//  Bican
//
//  Created by 迟宸 on 2018/1/3.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTToastUtils : UIView

//显示提示视图, 默认显示在屏幕上方(防止被软键盘覆盖)/下方, 几s后自动消失
+ (void)showToastIsAtTop:(BOOL)isAtTop Message:(NSString *)message Time:(CGFloat)time;

@end
