//
//  ZLShowBigImgViewController.h
//  多选相册照片
//
//  Created by long on 15/11/25.
//  Copyright © 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@class ZLSelectPhotoModel;

@interface ZLShowBigImgViewController : ZTBaseViewController

@property (nonatomic, strong) NSArray <PHAsset *> *assets;

@property (nonatomic, strong) NSMutableArray <ZLSelectPhotoModel *> *arraySelectPhotos;

//选中的图片下标
@property (nonatomic, assign) NSInteger selectIndex;
//最大选择照片数
@property (nonatomic, assign) NSInteger maxSelectCount;
//该界面显示方式，预览界面查看大图进来是present，从相册小图进来是push
@property (nonatomic, assign) BOOL isPresent;
//是否需要对接收到的图片数组进行逆序排列
@property (nonatomic, assign) BOOL shouldReverseAssets;
//点击返回按钮的回调
@property (nonatomic, copy) void (^onSelectedPhotos)(NSArray<ZLSelectPhotoModel *> *);

//点击确定按钮回调
@property (nonatomic, copy) void (^btnDoneBlock)(NSArray<ZLSelectPhotoModel *> *);

@end
