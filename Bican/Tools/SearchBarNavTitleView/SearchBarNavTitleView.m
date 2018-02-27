//
//  SearchBarNavTitleView.m
//  ZAInvestProject
//
//  Created by 迟宸 on 2017/11/24.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "SearchBarNavTitleView.h"

@implementation SearchBarNavTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
/**
 * 撑开view的布局
 @return CGSize
 */
- (CGSize)intrinsicContentSize
{
    return UILayoutFittingExpandedSize;
}


@end
