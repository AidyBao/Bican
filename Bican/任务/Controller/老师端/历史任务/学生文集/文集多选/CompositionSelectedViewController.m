//
//  CompositionSelectedViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "CompositionSelectedViewController.h"
#import "CompositionSelectedTableViewCell.h"
#import "SelectCompositionModel.h"

@interface CompositionSelectedViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, CompositionSelectedCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) NSMutableArray *cellSelectedArray;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *selectedAllButton;//全选按钮
@property (nonatomic, strong) UILabel *selectedAllLabel;
@property (nonatomic, strong) UIButton *markButton;//标记按钮
@property (nonatomic, assign) BOOL isSelectedAll;//是否全选
@property (nonatomic, assign) NSInteger markCount;//已选的个数

@end

@implementation CompositionSelectedViewController

- (NSMutableArray *)cellSelectedArray
{
    if (!_cellSelectedArray) {
        _cellSelectedArray = [NSMutableArray array];
    }
    return _cellSelectedArray;
}

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.navTitle;
    //默认不全选
    self.isSelectedAll = NO;
    //已选的个数
    self.markCount = 0;
    
    [self pubListByWeeks];
    [self createBottomView];
    [self createTableView];
    
}

#pragma mark - 获取学生文集列表
- (void)pubListByWeeks
{
    if (self.studentIdStr.length == 0) {
        return;
    }
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //评阅状态: 0-表示未评阅,1-表示已评阅
    [params setValue:@"0" forKey:@"IsComment"];
    [params setValue:self.startDate forKey:@"startDate"];
    [params setValue:self.endDate forKey:@"endDate"];
    [params setValue:self.studentIdStr forKey:@"studentId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/pubListByWeeks", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        [self.dataSourceArray removeAllObjects];

        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            SelectCompositionModel *model = [[SelectCompositionModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
        }
        if (self.dataSourceArray.count > 0) {
            for (int i = 0; i < self.dataSourceArray.count; i++) {
                [self.cellSelectedArray addObject:@"NO"];
            }
        }
        [self.tableView reloadData];

    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
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
    
    self.markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.markButton.layer.cornerRadius = GTH(32);
    [self.markButton setTitle:@"标记为已评阅(0)" forState:UIControlStateNormal];
    self.markButton.adjustsImageWhenHighlighted = NO;
    [self.markButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    self.markButton.titleLabel.font = FONT(32);
    [self.markButton setBackgroundColor:[UIColor whiteColor]];
    [self.markButton addTarget:self action:@selector(markCompositopns) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.markButton];
    
    [self.markButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView).offset(GTW(-20));
        make.centerY.equalTo(self.bottomView);
        make.size.mas_equalTo(CGSizeMake(GTW(294), GTH(65)));
    }];
    
}

#pragma mark - 标记为评阅按钮
- (void)markCompositopns
{
    if (self.markCount == 0) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.cellSelectedArray.count; i++) {
        if ([self.cellSelectedArray[i] isEqualToString:@"YES"]) {
            SelectCompositionModel *model = self.dataSourceArray[i];
            [array addObject:model.composition_id];
        }
    }
    //调用接口
    [self modifyInviteStatusWithArticleIds:[array componentsJoinedByString:@","]];
    
}

#pragma mark - 全选 || 反选按钮
- (void)selectedAllButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    self.isSelectedAll = sender.selected;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        if (self.isSelectedAll) {
            [self.cellSelectedArray replaceObjectAtIndex:i withObject:@"YES"];
            NSString *string = self.cellSelectedArray[i];
            if ([self.cellSelectedArray[i] isEqualToString:@"YES"]) {
                [array addObject:string];
            }
            self.markCount = array.count;
            [self.markButton setTitle:[NSString stringWithFormat:@"标记为已评阅(%ld)", self.markCount] forState:UIControlStateNormal];
            
        } else {
            [self.cellSelectedArray replaceObjectAtIndex:i withObject:@"NO"];
            [self.markButton setTitle:@"标记为已评阅(0)" forState:UIControlStateNormal];
            self.markCount = 0;
        }
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
    self.tableView.rowHeight = GTH(126);
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom).offset(GTH(-96));
    }];
}

#pragma mark - DZNEmptyDataSetSource协议方法
//设置title
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"什么都没有";
    
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

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"compositionsSelectedCell";
    CompositionSelectedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[CompositionSelectedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.delegate = self;
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    SelectCompositionModel *model = self.dataSourceArray[indexPath.row];
    NSString *leftTop = [NSString string];
    if ([model.bigTypeId isEqualToString:@"2"]) {
        leftTop = model.bigTypeName;
    } else {
        leftTop = [NSString stringWithFormat:@"%@ | %@", model.bigTypeName, model.typeName];
    }
    [cell setCompositionSelectedCellWithLeftTopText:leftTop
                                       RightTopText:model.sendDate
                                     LeftBottomText:model.title];
    
    NSString *string = self.cellSelectedArray[indexPath.row];
    [cell setCellIsSelected:string];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - CompositionSelectedCellDelegate
- (void)selecetedCell:(CompositionSelectedTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *string = self.cellSelectedArray[indexPath.row];
    NSInteger count = self.markCount;
    
    if ([string isEqualToString:@"YES"]) {
        count -= 1;
        [self.cellSelectedArray replaceObjectAtIndex:indexPath.row withObject:@"NO"];
    } else {
        count += 1;
        [self.cellSelectedArray replaceObjectAtIndex:indexPath.row withObject:@"YES"];
    }
    self.markCount = count;
    
    [cell setCellIsSelected:self.cellSelectedArray[indexPath.row]];
    
    [self.markButton setTitle:[NSString stringWithFormat:@"标记为已评阅(%ld)", count] forState:UIControlStateNormal];
    
    if (![self.cellSelectedArray containsObject:@"NO"]) {
        self.isSelectedAll = YES;
        self.selectedAllButton.selected = YES;
        [self.markButton setTitle:[NSString stringWithFormat:@"标记为已评阅(%ld)", self.markCount] forState:UIControlStateNormal];
    }
    if (![self.cellSelectedArray containsObject:@"YES"]) {
        self.isSelectedAll = NO;
        self.selectedAllButton.selected = NO;
        [self.markButton setTitle:@"标记为已评阅(0)"  forState:UIControlStateNormal];
    }
    
}

#pragma mark - 标记为已评
- (void)modifyInviteStatusWithArticleIds:(NSString *)articleIds
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    [params setValue:articleIds forKey:@"articleIds"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/invite/modifyStatus", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"标记为已评阅成功" Time:3.0];
        [self popVCAnimated:YES];
        
    } errorHandler:^(NSError *error) {
        
        [self hideLoading];
        
    } reloadHandler:^(BOOL isReload) {
        
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}





@end
