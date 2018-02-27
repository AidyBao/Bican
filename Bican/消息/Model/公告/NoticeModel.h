//
//  NoticeModel.h
//  Bican
//
//  Created by bican on 2018/1/26.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject

@property (nonatomic, strong) NSString *pubTime;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *bullitenId;
@property (nonatomic, strong) NSString *avatar;

@end
