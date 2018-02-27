//
//  ZLShowBigImgViewController.m
//  多选相册照片
//
//  Created by long on 15/11/25.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ZLShowBigImgViewController.h"
#import <Photos/Photos.h>
#import "ZLBigImageCell.h"
#import "ZLDefine.h"
#import "ZLSelectPhotoModel.h"
#import "ZLPhotoTool.h"

@interface ZLShowBigImgViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    
    NSMutableArray<PHAsset *> *_arrayDataSources;
    UIButton *_navRightBtn;

    //双击的scrollView
    UIScrollView *_selectScrollView;
    NSInteger _currentPage;
}

@property (nonatomic, strong) UILabel *labPhotosBytes;

@end

@implementation ZLShowBigImgViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.shouldReverseAssets) {
        [_collectionView setContentOffset:CGPointMake((self.assets.count - self.selectIndex - 1) * (ScreenHeight + kItemMargin), 0)];
    } else {
        [_collectionView setContentOffset:CGPointMake(self.selectIndex * (ScreenWidth + kItemMargin), 0)];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftNavigationItem:[UIImage imageNamed:@"return"] Title:@""];
    
    [self sortAsset];
    [self initCollectionView];
    
}

#pragma mark - 左侧返回按钮
- (void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    if (self.onSelectedPhotos) {
        self.onSelectedPhotos(self.arraySelectPhotos);
    }
    
    if (self.isPresent) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        //由于collectionView的frame的width是大于该界面的width，所以设置这个颜色是为了pop时候隐藏collectionView的黑色背景
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

#pragma mark - 初始化CollectionView
- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = kItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin/2, 0, kItemMargin/2);
    layout.itemSize = self.view.bounds.size;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kItemMargin/2, 0, ScreenWidth+kItemMargin, ScreenHeight) collectionViewLayout:layout];
    [_collectionView registerClass:[ZLBigImageCell class] forCellWithReuseIdentifier:@"ZLBigImageCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
}

#pragma mark - 移除当前选中的图片
- (void)removeCurrentPageImage
{
    PHAsset *asset = _arrayDataSources[_currentPage - 1];
    for (ZLSelectPhotoModel *model in _arraySelectPhotos) {
        if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
            [_arraySelectPhotos removeObject:model];
            break;
        }
    }
}

#pragma mark - 数组排序
- (void)sortAsset
{
    _arrayDataSources = [NSMutableArray array];
    if (self.shouldReverseAssets) {
        NSEnumerator *enumerator = [self.assets reverseObjectEnumerator];
        id obj;
        while (obj = [enumerator nextObject]) {
            [_arrayDataSources addObject:obj];
        }
        //当前页
        _currentPage = _arrayDataSources.count-self.selectIndex;
    } else {
        [_arrayDataSources addObjectsFromArray:self.assets];
        _currentPage = self.selectIndex + 1;
    }
    self.title = [NSString stringWithFormat:@"%ld/%ld", _currentPage, _arrayDataSources.count];
}


#pragma mark - UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayDataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLBigImageCell" forIndexPath:indexPath];
    PHAsset *asset = _arrayDataSources[indexPath.row];
    
    cell.asset = asset;
    cell.singleTapCallBack = ^() {
        
    };
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == (UIScrollView *)_collectionView) {
        //改变导航标题 - (16/27)
        CGFloat page = scrollView.contentOffset.x / (ScreenWidth + kItemMargin);
        NSString *str = [NSString stringWithFormat:@"%.0f", page];
        _currentPage = str.integerValue + 1;
        self.title = [NSString stringWithFormat:@"%ld/%ld", _currentPage, _arrayDataSources.count];
    }
}

@end
