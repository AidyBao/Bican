//
//  ClearHistoryView.h
//  Bican
//
//  Created by 迟宸 on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClearHistoryViewDelegate <NSObject>

- (void)toClearAllHistoryData;

@end

@interface ClearHistoryView : BaseView

@property (nonatomic, assign) id <ClearHistoryViewDelegate> delegate;

@end
