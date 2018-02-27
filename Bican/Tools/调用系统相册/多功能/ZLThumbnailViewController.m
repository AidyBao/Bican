//
//  ZLThumbnailViewController.m
//  多选相册照片
//
//  Created by long on 15/11/30.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ZLThumbnailViewController.h"
#import <Photos/Photos.h>
#import "ZLDefine.h"
#import "ZLCollectionCell.h"
#import "ZLPhotoTool.h"
#import "ZLSelectPhotoModel.h"
#import "ZLShowBigImgViewController.h"
#import "ZLPhotoBrowser.h"

typedef void (^handler)(NSArray<UIImage *> *selectPhotos, NSArray<ZLSelectPhotoModel *> *selectPhotoModels);

@interface ZLThumbnailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, ZLCollectionCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
   
@property (nonatomic, strong) NSMutableArray <PHAsset *> *arrayDataSources;
@property (nonatomic, assign) BOOL isLayoutOK;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, copy) handler handler;

@end

@implementation ZLThumbnailViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.isLayoutOK = YES;
}
    
#pragma mark - 默认滚动到最后一张图片的位置
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!_isLayoutOK) {
        if (self.collectionView.contentSize.height > self.collectionView.frame.size.height) {
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height)];
        }
       
    }
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数组
    self.title = @"选择图片";
    self.arrayDataSources = [NSMutableArray array];
    
    [self createLeftNavigationItem:[UIImage imageNamed:@"return"] Title:@""];
    [self createRightNavigationItem:nil Title:@"确定" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:GTH(10)];
    
    //创建CollectionView
    [self createBottomButton];
    [self createCollectionView];
    [self getAssetInAssetCollection];
    
    
}

#pragma mark - 返回按钮
- (void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    if (self.CancelBlock) {
        self.CancelBlock();
    }
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
    
#pragma mark - 右侧确认按钮
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    if (self.DoneBlock) {
        self.DoneBlock(self.arraySelectPhotos);
    }
}

#pragma mark - 创建底部的BottomButton
- (void)createBottomButton
{
    self.bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bottomButton.frame = CGRectMake(0, ScreenHeight - GTH(100), ScreenWidth, GTH(100));
    [self.bottomButton setTitle:@"   所有照片" forState:UIControlStateNormal];
    [self.bottomButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.bottomButton.adjustsImageWhenHighlighted = NO;
    [self.bottomButton setBackgroundColor:RGBA(250, 250, 250, 1)];
    self.bottomButton.titleLabel.font = FONT(24);
    self.bottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.bottomButton addTarget:self action:@selector(showAllPic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bottomButton];
}

#pragma mark - 显示所有图片
- (void)showAllPic
{

}

#pragma mark - 创建CollectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat item_width = (ScreenWidth - GTW(12) * 4) / 3;
    layout.itemSize = CGSizeMake(item_width, item_width);
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    //top, left, bottom, right
    layout.sectionInset = UIEdgeInsetsMake(GTH(7), GTW(12), GTH(7), GTW(12));
    // 设置Header固定位置,不悬停
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, ScreenHeight - NAV_HEIGHT - GTH(100)) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self setScrollIndicatorInsetsForCollectionView:self.collectionView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view addSubview:self.collectionView];

    [self.collectionView registerClass:[ZLCollectionCell class] forCellWithReuseIdentifier:@"ZLCollectionCell"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];

}
    
#pragma mark - 获取图片数组
- (void)getAssetInAssetCollection
{
    [_arrayDataSources addObjectsFromArray:[[ZLPhotoTool sharePhotoTool] getAssetsInAssetCollection:self.assetCollection ascending:YES]];
}

#pragma mark - UIButton Action
- (void)selectedCell:(ZLCollectionCell *)cell Button:(UIButton *)sender
{
    if (_arraySelectPhotos.count >= self.maxSelectCount
        && sender.selected == NO) {
        [ZTToastUtils showToastIsAtTop:NO Message:[NSString stringWithFormat:@"最多只能选择%ld张图片", self.maxSelectCount] Time:3.0];

        return;
    }
    
    PHAsset *asset = _arrayDataSources[sender.tag - 1];
    
    if (!sender.selected) {
        //添加图片到选中数组
        [sender.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        if (![[ZLPhotoTool sharePhotoTool] judgeAssetisInLocalAblum:asset]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"该图片在iCloud的上保存" Time:3.0];
            return;
        }
        ZLSelectPhotoModel *model = [[ZLSelectPhotoModel alloc] init];
        model.asset = asset;
        model.localIdentifier = asset.localIdentifier;
        [_arraySelectPhotos addObject:model];
    } else {
        for (ZLSelectPhotoModel *model in _arraySelectPhotos) {
            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                [_arraySelectPhotos removeObject:model];
                break;
            }
        }
    }
    
    sender.selected = !sender.selected;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayDataSources.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
        cell.backgroundColor = ZTTextLightGrayColor;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, GTW(86), GTH(86))];
        imageView.center = cell.contentView.center;
        imageView.image = [UIImage imageNamed:@"camera"];
        [cell.contentView addSubview:imageView];

        return cell;

    } else {
        ZLCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLCollectionCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.btnSelect.selected = NO;
        PHAsset *asset = self.arrayDataSources[indexPath.row - 1];
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.clipsToBounds = YES;
        
        CGSize size = cell.frame.size;
        size.width *= 2.5;
        size.height *= 2.5;
        
        weakify(self);
        [[ZLPhotoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
            strongify(weakSelf);
            cell.imageView.image = image;
            for (ZLSelectPhotoModel *model in strongSelf.arraySelectPhotos) {
                if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                    cell.btnSelect.selected = YES;
                    break;
                }
            }
        }];
        cell.btnSelect.tag = indexPath.row;
        
        return cell;
        
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item != 0) {
        [self pushShowBigImgVCWithDataArray:_arrayDataSources selectIndex:indexPath.row - 1];

    } else {
        //调用相机
        if (self.arraySelectPhotos.count > 0) {
            [self requestSelPhotos:nil];
            
        } else {
            //拍照
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = NO;
                picker.videoQuality = UIImagePickerControllerQualityTypeLow;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.sender presentViewController:picker animated:YES completion:nil];
            } else {
                [MBHUDManager showBriefAlert:@"相机功能暂不能使用"];
                return;
            }
        }
 
    }
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        strongify(weakSelf);
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
            [hud show];
            
            [[ZLPhotoTool sharePhotoTool] saveImageToAblum:image completion:^(BOOL suc, PHAsset *asset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (suc) {
                        //存在数组里
                        [_arrayDataSources addObject:asset];
                        [strongSelf.collectionView reloadData];
                        //滚动到最底部
                        if (strongSelf.collectionView.contentSize.height > strongSelf.collectionView.frame.size.height) {
                            [strongSelf.collectionView setContentOffset:CGPointMake(0, strongSelf.collectionView.contentSize.height - strongSelf.collectionView.frame.size.height)];
                        }
                    } else {
                        [ZTToastUtils showToastIsAtTop:NO Message:@"图片保存失败" Time:3.0];
                    }
                    [hud hide];
                });
            }];
    }];

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - 请求所选择图片、回调
- (void)requestSelPhotos:(UIViewController *)vc
{
    ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
    [hud show];
    
    weakify(self);
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.arraySelectPhotos.count];
    for (int i = 0; i < self.arraySelectPhotos.count; i++) {
        [photos addObject:@""];
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    for (int i = 0; i < self.arraySelectPhotos.count; i++) {
        ZLSelectPhotoModel *model = self.arraySelectPhotos[i];
        [[ZLPhotoTool sharePhotoTool] requestImageForAsset:model.asset scale:scale resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image) {
            strongify(weakSelf);
            if (image) [photos replaceObjectAtIndex:i withObject:[self scaleImage:image]];
            
            for (id obj in photos) {
                if ([obj isKindOfClass:[NSString class]]) return;
            }
            
            [hud hide];
            [strongSelf done:photos];
            [vc.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
    }
}

- (void)done:(NSArray<UIImage *> *)photos
{
    if (self.handler) {
        self.handler(photos, self.arraySelectPhotos.copy);
        self.handler = nil;
    }
}

/**
 * @brief 这里对拿到的图片进行缩放，不然原图直接返回的话会造成内存暴涨
 */
- (UIImage *)scaleImage:(UIImage *)image
{
    double ScalePhotoWidth = 1000;

    CGSize size = CGSizeMake(ScalePhotoWidth, ScalePhotoWidth * image.size.height / image.size.width);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)pushShowBigImgVCWithDataArray:(NSArray<PHAsset *> *)dataArray selectIndex:(NSInteger)selectIndex
{
    ZLShowBigImgViewController *svc = [[ZLShowBigImgViewController alloc] init];
    svc.assets         = dataArray;
    svc.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
    svc.selectIndex    = selectIndex;
    svc.maxSelectCount = _maxSelectCount;
    svc.isPresent = NO;
    svc.shouldReverseAssets = NO;
    
    weakify(self);
    [svc setOnSelectedPhotos:^(NSArray<ZLSelectPhotoModel *> *selectedPhotos) {
        strongify(weakSelf);
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
        [strongSelf.collectionView reloadData];
    }];
    [svc setBtnDoneBlock:^(NSArray<ZLSelectPhotoModel *> *selectedPhotos) {
        strongify(weakSelf);
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
//        [strongSelf btnDone_Click:nil];
    }];
    
    [self.navigationController pushViewController:svc animated:YES];
}


@end
