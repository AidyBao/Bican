//
//  MingtiDetailHeaderView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/6.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MingtiDetailHeaderViewDelegate <NSObject>

- (void)pushToMingtiAllVC;

@end

@interface MingtiDetailHeaderView : BaseView

- (void)setMingtiDetailHeaderViewWithFromUser:(NSString *)fromUser
                                     FromTest:(NSString *)fromTest
                                      Content:(NSString *)content;

@property (nonatomic, assign) id <MingtiDetailHeaderViewDelegate> delegate;

@end
