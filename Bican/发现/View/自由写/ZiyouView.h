//
//  ZiyouView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/1.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiyouViewController.h"

@protocol ZiyouViewDelegate <NSObject>

- (void)pushToDetailVCWithArticleIdStr:(NSString *)articleIdStr IsRecommend:(NSString *)isRecommend;

@end

@interface ZiyouView : BaseView

@property (nonatomic, strong) ZiyouViewController *ziyouVC;
@property (nonatomic, strong) NSString *typeId;//栏目id
@property (nonatomic, strong) NSString *typeName;//栏目名称
@property (nonatomic, strong) NSString *startDate;//
@property (nonatomic, strong) NSString *endDate;//
@property (nonatomic, strong) NSString *proviceId;//
@property (nonatomic, strong) NSString *cityId;//
@property (nonatomic, strong) NSString *schoolId;//
@property (nonatomic, strong) NSString *gradeName;//
@property (nonatomic, strong) NSString *classId;//

@property (nonatomic, assign) id <ZiyouViewDelegate> delegate;

@end
