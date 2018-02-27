//
//  WalletViewController.m
//  Bican
//
//  Created by bican on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "WalletViewController.h"
#import "WalletCollectionHeaderView.h"
#import "WalletCollectionViewCell.h"
#import "WallectModel.h"

#import "RechargeViewController.h"
#import "GiftExchangeWenbiViewController.h"

@interface WalletViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, WalletCollectionHeaderViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WalletCollectionHeaderView *collectionHeaderView;

@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIButton *changeMoneyButton;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *moneyStr;//记录账户余额
@property (nonatomic, strong) NSString *allMoneyStr;//礼物总价值

@end

@implementation WalletViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self giftList];
    [self propertyInfo];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self giftList];
    [self propertyInfo];
    [self createBackView];
    [self createCollectionView];
}

#pragma mark - 创建底部图片
- (void)createBackView
{
    self.backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wallet_bg"]];
    [self.view addSubview:self.backImageView];
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

#pragma mark - 创建CollectionView
- (void)createCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat item_width = ScreenWidth / 3;
    flowLayout.itemSize = CGSizeMake(item_width, GTH(280));
    flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth, GTH(451));
    flowLayout.footerReferenceSize = CGSizeMake(ScreenWidth, GTH(160));
    //top, left, bottom, right
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    // 设置Header固定位置,不悬停
    flowLayout.sectionHeadersPinToVisibleBounds = NO;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self setScrollIndicatorInsetsForCollectionView:self.collectionView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.view);
    }];
    
    // 注册item
    [self.collectionView registerClass:[WalletCollectionViewCell class] forCellWithReuseIdentifier:@"walletCollectionCell"];
    // 注册header
    [self.collectionView registerClass:[WalletCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeader"];
    // 注册footer
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CollectionFooter"];
    
}


#pragma mark - DZNEmptyDataSetSource协议方法
//设置title
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"还没收到任何礼物";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(28), NSForegroundColorAttributeName:ZTTitleColor, NSParagraphStyleAttributeName:paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_neirong"];
}


#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *walletCollectionCell = @"walletCollectionCell";
    WalletCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:walletCollectionCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataArray.count == 0) {
        return cell;
    }
    
    WallectModel *wallectModel = self.dataArray[indexPath.row];
    
    [cell createWallectCellWithCollectionPicture:wallectModel.picture Own:wallectModel.own Unit:wallectModel.unit Name:wallectModel.name Currency:wallectModel.currency FlowerId:wallectModel.flowerId];
    
    return cell;
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //header
    if (kind == UICollectionElementKindSectionHeader) {
        self.collectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionHeader" forIndexPath:indexPath];
        self.collectionHeaderView.delegate = self;
        //显示账户余额
        if (self.moneyStr.length == 0) {
            [self.collectionHeaderView setWenbiText:@"0文币"];
        } else {
            [self.collectionHeaderView setWenbiText:[NSString stringWithFormat:@"%@文币", self.moneyStr]];
        }

        return self.collectionHeaderView;
    }
    //footer
    if (kind == UICollectionElementKindSectionFooter) {
        
        UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionFooter" forIndexPath:indexPath];
        
        if (self.dataArray.count == 0) {
            return reusableView;
        }
        
        self.changeMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.changeMoneyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.changeMoneyButton setTitle:@"礼物换文币" forState:UIControlStateNormal];
        self.changeMoneyButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(30)];
        [self.changeMoneyButton setBackgroundColor:ZTOrangeColor];
        self.changeMoneyButton.layer.cornerRadius = GTH(20);
        [self.changeMoneyButton addTarget:self action:@selector(changeMoneyButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [reusableView addSubview:self.changeMoneyButton];
        
        [self.changeMoneyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(reusableView.mas_right).offset(GTW(-28));
            make.top.equalTo(reusableView.mas_top).offset(GTH(64));
            make.size.mas_equalTo(CGSizeMake(GTW(202), GTW(48)));
        }];
        
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.font = FONT(24);
        self.valueLabel.textColor = ZTTextLightGrayColor;
        self.allMoneyStr = [NSString string];
        NSInteger all = 0;
        for (int i = 0; i < self.dataArray.count; i++) {
            WallectModel *model = self.dataArray[i];
            NSInteger own = [model.own integerValue];
            NSInteger currency = [model.currency integerValue];
            NSInteger money = own * currency;
            all += money;
        }
        self.allMoneyStr = [NSString stringWithFormat:@"%ld", all];
        self.valueLabel.text = [NSString stringWithFormat:@"礼物总价值: %@文币", self.allMoneyStr];
        [reusableView addSubview:self.valueLabel];
        
        [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(reusableView.mas_left).offset(GTW(28));
            make.right.equalTo(self.changeMoneyButton.mas_left).offset(GTW(-28));
            make.centerY.equalTo(self.changeMoneyButton);
        }];
        
        return reusableView;
    }
    
    return nil;
}

#pragma mark - WalletCollectionHeaderViewDelegate
- (void)pushToVCWithTag:(NSInteger)tag
{
    if (tag == 11222) {
        //返回按钮
        [self popVCAnimated:YES];
    }
    if (tag == 22111) {
        //去充值
        [self showTipAlertWithTitle:@"该功能暂未开通, 敬请期待"];
//        RechargeViewController *recharge = [[RechargeViewController alloc] init];
//        [self pushVC:recharge animated:YES];
    }
}

#pragma mark - 礼品换文币按钮
- (void)changeMoneyButtonAction
{
    if ([self.allMoneyStr integerValue] == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"没有可兑换文币的礼物" Time:3.0];
        return;
    }
    GiftExchangeWenbiViewController *giftExchangeWenbiVC = [[GiftExchangeWenbiViewController alloc] init];
    //传值礼物的数组,数组中是model(如果价值为0,不显示)
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        WallectModel *model = [[WallectModel alloc] init];
        model = self.dataArray[i];
        if (![model.currency isEqualToString:@"0"]) {
            [array addObject:model];
        }
    }
    giftExchangeWenbiVC.dataSourceArray = array;
    giftExchangeWenbiVC.allMoney = self.allMoneyStr;
    
    [self pushVC:giftExchangeWenbiVC animated:YES IsNeedLogin:YES];
    
}

#pragma mark - 获取我的钱包信息
- (void)propertyInfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/user/propertyInfo", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        //记录账户余额
        self.moneyStr = [NSString stringWithFormat:@"%@", [dic objectForKey:@"money"]];
        [self.collectionView reloadData];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 获取礼物列表数据
- (void)giftList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    NSString *url = [NSString stringWithFormat:@"%@api/gift/giftList", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.dataArray removeAllObjects];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            WallectModel *wallectModel = [[WallectModel alloc] init];
            [wallectModel setValuesForKeysWithDictionary:dic];
            if (![wallectModel.own isEqualToString:@"0"]) {
                [self.dataArray addObject:wallectModel];
            }
        }

        [self.collectionView reloadData];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}



@end
