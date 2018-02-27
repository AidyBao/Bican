//
//  MineNoLoginHeaderView.h
//  Bican
//
//  Created by bican on 2018/1/2.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineNoLoginHeaderViewDelegate <NSObject>

- (void)pushToVCWithTag:(NSInteger)tag;

@end

@interface MineNoLoginHeaderView : UIView

@property (nonatomic, assign) id <MineNoLoginHeaderViewDelegate> delegate;

@end
