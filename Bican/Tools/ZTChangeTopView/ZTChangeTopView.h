//
//  ZTChangeTopView.h
//  Bican
//
//  Created by 迟宸 on 2017/12/27.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTChangeTopView;

@protocol ZTChangeTopViewDelegate <NSObject>
//选中的下标
- (void)changeTopViewSelectedIndex:(NSInteger)selectedIndex;

@end


@interface ZTChangeTopView : BaseView

- (void)createTitleWithArray:(NSArray *)array;

@property (nonatomic, assign) id <ZTChangeTopViewDelegate> delelgate;

@end
