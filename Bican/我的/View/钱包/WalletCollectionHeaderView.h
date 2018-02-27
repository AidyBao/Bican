//
//  WalletCollectionHeaderView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/6.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WalletCollectionHeaderViewDelegate <NSObject>

- (void)pushToVCWithTag:(NSInteger)tag;

@end

@interface WalletCollectionHeaderView : UICollectionReusableView

- (void)setWenbiText:(NSString *)wenbiText;

@property (nonatomic, assign) id <WalletCollectionHeaderViewDelegate> delegate;

@end
