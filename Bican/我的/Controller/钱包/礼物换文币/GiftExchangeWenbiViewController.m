//
//  GiftExchangeWenbiViewController.m
//  Bican
//
//  Created by bican on 2018/1/13.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "GiftExchangeWenbiViewController.h"
#import "GiftExchangeWenbiTableViewCell.h"
#import "WallectModel.h"

@interface GiftExchangeWenbiViewController ()<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, GiftExchangeWenbiTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *selectedCountArray;//选中的朵数数组
@property (nonatomic, strong) NSMutableArray *cellSelectedArray;//cell的选中状态数组

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *selectedAllButton;//全选按钮
@property (nonatomic, strong) UILabel *selectedAllLabel;
@property (nonatomic, assign) BOOL isSelectedAll;//是否全选

@property (nonatomic, strong) UIButton *exchangeButton;
@property (nonatomic, strong) UILabel *totalLabel;

@end

@implementation GiftExchangeWenbiViewController

- (NSMutableArray *)cellSelectedArray
{
    if (!_cellSelectedArray) {
        _cellSelectedArray = [NSMutableArray array];
        for (int i = 0; i < self.dataSourceArray.count; i++) {
            [_cellSelectedArray addObject:@"YES"];
        }
    }
    return _cellSelectedArray;
}

- (NSMutableArray *)selectedCountArray
{
    if (!_selectedCountArray) {
        _selectedCountArray = [NSMutableArray array];
        if (_dataSourceArray.count != 0) {
            for (int i = 0; i < self.dataSourceArray.count; i++) {
                WallectModel *model = self.dataSourceArray[i];
                [_selectedCountArray addObject:model.own];
            }
            
        }
    }
    return _selectedCountArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //默认全选
    self.isSelectedAll = YES;
    self.title = @"文币兑换";
    
    [self createBottomView];
    [self createTableView];
}


#pragma mark - 创建
- (void)createBottomView
{
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = ZTOrangeColor;
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(GTH(96));
    }];
    
    self.selectedAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectedAllButton setImage:[UIImage imageNamed:@"duihuan_checkbox"] forState:UIControlStateNormal];
    [self.selectedAllButton setImage:[UIImage imageNamed:@"duihuan_checkbox_a"] forState:UIControlStateSelected];
    self.selectedAllButton.selected = YES;
    [self.selectedAllButton addTarget:self action:@selector(selectedAllButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.selectedAllButton];
    
    [self.selectedAllButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(GTW(30));
        make.centerY.equalTo(self.bottomView);
        make.width.height.mas_equalTo(GTH(38));
    }];
    
    self.selectedAllLabel = [[UILabel alloc] init];
    self.selectedAllLabel.text = @"全选";
    self.selectedAllLabel.font = FONT(26);
    self.selectedAllLabel.textColor = ZTTitleColor;
    [self.bottomView addSubview:self.selectedAllLabel];
    
    [self.selectedAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedAllButton.mas_right).offset(GTW(21));
        make.centerY.equalTo(self.bottomView);
    }];
    
    
    self.exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exchangeButton.layer.cornerRadius = GTH(25);
    [self.exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
    self.exchangeButton.adjustsImageWhenHighlighted = NO;
    [self.exchangeButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    self.exchangeButton.titleLabel.font = FONT(28);
    [self.exchangeButton setBackgroundColor:[UIColor whiteColor]];
    [self.exchangeButton addTarget:self action:@selector(markCompositopns) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.exchangeButton];
    
    [self.exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(GTW(-20));
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(GTW(100), GTH(65)));
    }];
    
    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.font = FONT(28);
    self.totalLabel.textColor = ZTTitleColor;
    if (self.dataSourceArray.count != 0) {
        self.totalLabel.text = [NSString stringWithFormat:@"合计:%@文币", self.allMoney];
    } else {
        self.totalLabel.text = @"合计:0文币";
    }
    [self.bottomView addSubview:self.totalLabel];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.exchangeButton.mas_left).offset(-38);
        make.centerY.equalTo(self.bottomView);
    }];
    
  
}

#pragma mark - 全选按钮
- (void)selectedAllButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.isSelectedAll = sender.selected;
    
    if (self.isSelectedAll) {
        //全选
        for (int i = 0; i < self.cellSelectedArray.count; i++) {
            [self.cellSelectedArray replaceObjectAtIndex:i withObject:@"YES"];
        }
        //计算原始总金额
        NSInteger all = 0;
        for (int i = 0; i < self.dataSourceArray.count; i++) {
            WallectModel *model = self.dataSourceArray[i];
            NSInteger own = [model.own integerValue];
            NSInteger currency = [model.currency integerValue];
            NSInteger money = own * currency;
            all += money;
        }
        self.allMoney = [NSString stringWithFormat:@"%ld", all];
        self.totalLabel.text = [NSString stringWithFormat:@"合计:%@文币", self.allMoney];
        
    } else {
        self.allMoney = @"";
        for (int i = 0; i < self.cellSelectedArray.count; i++) {
            [self.cellSelectedArray replaceObjectAtIndex:i withObject:@"NO"];
        }
        self.totalLabel.text = @"合计:0文币";
    }

    [self.tableView reloadData];
    
}

#pragma makr - 创建TableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = GTH(185);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom).offset(GTH(-96));
    }];
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"compositionsSelectedCell";
    GiftExchangeWenbiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[GiftExchangeWenbiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    
    WallectModel *model = self.dataSourceArray[indexPath.row];
    NSString *count = self.selectedCountArray[indexPath.row];
    
    [cell setGiftExchangeWenbiCellWithFlowerName:model.name
                                       FlowerPic:model.picture
                                        Currency:model.currency
                                            Unit:model.unit
                                   SelectedCount:count];
    
    //设置cell是否全选
    NSString *isSelected = self.cellSelectedArray[indexPath.row];
    if ([isSelected isEqualToString:@"YES"]) {
        [cell setCellIsSelectedAll:YES];
    } else {
        [cell setCellIsSelectedAll:NO];
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - CompositionSelectedCellDelegate
//cell的选中和取消选中
- (void)selecetedCell:(GiftExchangeWenbiTableViewCell *)cell IsSelected:(BOOL)isSelected
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WallectModel *model = self.dataSourceArray[indexPath.row];
    NSInteger count = [self.selectedCountArray[indexPath.row] integerValue] * [model.currency integerValue];
    
    if (isSelected) {
        self.isSelectedAll = YES;
        self.selectedAllButton.selected = self.isSelectedAll;
        //添加
        self.allMoney = [NSString stringWithFormat:@"%ld", [self.allMoney integerValue] + count];
        [self.cellSelectedArray replaceObjectAtIndex:indexPath.row withObject:@"YES"];

    } else {
        self.isSelectedAll = NO;
        self.selectedAllButton.selected = self.isSelectedAll;
        //移除
        self.allMoney = [NSString stringWithFormat:@"%ld", [self.allMoney integerValue] - count];
        [self.cellSelectedArray replaceObjectAtIndex:indexPath.row withObject:@"NO"];
    }
    self.totalLabel.text = [NSString stringWithFormat:@"合计:%@文币", self.allMoney];
    [self.tableView reloadData];

}

//点击cell上的加减按钮
- (void)isAddFlower:(BOOL)isAddFlower WithCell:(GiftExchangeWenbiTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (self.selectedCountArray.count == 0) {
        return;
    }
    WallectModel *model = self.dataSourceArray[indexPath.row];
    NSString *count = self.selectedCountArray[indexPath.row];
    NSString *result = [NSString string];
    
    //如果不是选中状态
    if ([self.cellSelectedArray[indexPath.row] isEqualToString:@"NO"]) {
        return;
    }
    if (isAddFlower) {
        //最大值
        if ([count isEqualToString:model.own]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"已是最大拥有量" Time:3.0];
            return;
        }
        //记录选中的个数
        result = [NSString stringWithFormat:@"%ld", [count integerValue] + 1];
        NSInteger money = [model.currency integerValue];
        //计算总金额
        self.allMoney = [NSString stringWithFormat:@"%ld", [self.allMoney integerValue] + money];
        
    } else {
        //最小值
        if ([count isEqualToString:@"0"]) {
            return;
        }
        result = [NSString stringWithFormat:@"%ld", [count integerValue] - 1];
        NSInteger money = [model.currency integerValue];
        self.allMoney = [NSString stringWithFormat:@"%ld", [self.allMoney integerValue] - money];
    }
    self.totalLabel.text = [NSString stringWithFormat:@"合计:%@文币", self.allMoney];
    //替换数组元素
    [self.selectedCountArray replaceObjectAtIndex:indexPath.row withObject:result];
    //刷新页面
    [self.tableView reloadData];

}

#pragma mark - 兑换按钮
- (void)markCompositopns
{
    if (![self.cellSelectedArray containsObject:@"YES"]) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请选择要兑换的礼物和数量" Time:3.0];
        return;
    }
    [self giftToMoney];
}

#pragma mark - 礼物换文币接口
- (void)giftToMoney
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //文币总数量
    [params setValue:self.allMoney forKey:@"amount"];
    [params setValue:[self changeJsonString] forKey:@"flowerList"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/giftToMoney", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [self popVCAnimated:YES];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - json字符串
- (NSString *)changeJsonString
{
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        WallectModel *model = [[WallectModel alloc] init];
        model = self.dataSourceArray[i];
        if ([self.cellSelectedArray[i] isEqualToString:@"YES"]) {
            if (![self.selectedCountArray[i] isEqualToString:@"0"]) {
                //花id
                [dic setValue:model.flowerId forKey:@"flowerId"];
                //花的数量
                [dic setValue:self.selectedCountArray[i] forKey:@"amount"];
            }
        }
        [array addObject:dic];
        if (dic.allValues.count == 0) {
            [array removeObject:dic];
        }
    }

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:kNilOptions
                                                         error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    

    return jsonString;
  
}


@end
