//
//  AnnotationListView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/18.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnnotationListViewDelegate <NSObject>

- (void)cancelButtonAction;

@end

@interface AnnotationListView : BaseView

@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, assign) NSInteger selectedIndexRow;//选中的下标

@property (nonatomic, assign) id <AnnotationListViewDelegate> delegate;

@end
