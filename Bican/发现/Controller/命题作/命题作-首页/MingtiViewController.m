//
//  MingtiViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/30.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "MingtiViewController.h"
#import "MingtiTextTableViewCell.h"
#import "MingtiPicTableViewCell.h"
#import "MingtiListModel.h"

#import "AddMingtiViewController.h"
#import "MingtiDetailViewController.h"
#import "MingtiPicShowViewController.h"

@interface MingtiViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MingtiPicTableViewCellDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UIButton *addButton;//上传命题按钮
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@end

@implementation MingtiViewController

- (NSMutableArray *)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getPropositionList];
    [self createTableView];
    
}

#pragma mark - 获取命题作文章列表
- (void)getPropositionList
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    NSString *url = [NSString stringWithFormat:@"%@api/proposition/list", BASE_URL];
    
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
            MingtiListModel *model = [[MingtiListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceArray addObject:model];
        }
        [self.tableView reloadData];
        //设置title
        if (self.dataSourceArray.count > 0) {
            self.title = [NSString stringWithFormat:@"%ld个命题", self.dataSourceArray.count];
        }

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
- (UIView *)createTableHeaderView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, GTH(229) + GTH(50) * 2 + GTH(65));
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mingtizuo_banner"]];
        _topImageView.frame = CGRectMake(0, 0, ScreenWidth, GTH(229));
        [_headerView addSubview:_topImageView];
        
        if (![GetUserInfo judgIsloginByUserModel]) {
            _headerView.frame = CGRectMake(0, 0, ScreenWidth, GTH(229));
            return _headerView;
        }
        
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake((ScreenWidth - GTW(243)) / 2, GTH(229) + GTH(50), GTW(243), GTH(65));
        _addButton.layer.cornerRadius = GTH(32);
        [_addButton setBackgroundColor:ZTOrangeColor];
        [_addButton setTitle:@"上传命题" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        _addButton.adjustsImageWhenHighlighted = NO;
        [_addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_headerView addSubview:_addButton];
        
    }
    return _headerView;

}

#pragma mark - 上传命题按钮
- (void)addButtonAction
{
    AddMingtiViewController *addMingtiVC = [[AddMingtiViewController alloc] init];
    [self pushVC:addMingtiVC animated:YES IsNeedLogin:YES];
}

#pragma mark - 创建TableView
- (void)createTableView
{
    self.tableView = [[UITableView alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableHeaderView = [self createTableHeaderView];
    self.tableView.tableFooterView = view;
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, TABBAR_HEIGHT, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
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
    if (self.dataSourceArray.count == 0) {
        return nil;
    }
    MingtiListModel *model = self.dataSourceArray[indexPath.row];
    if (model.picture.length == 0) {
        //文字
        static NSString *defaultCellID = @"mingtiTextCell";
        MingtiTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
        if (!cell) {
            cell = [[MingtiTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];

        if (self.dataSourceArray.count == 0) {
            return cell;
        }
        //提供人
        NSString *fromUser = [NSString stringWithFormat:@"@%@ 提供", model.provider];
        
        [cell setMingtiTextCellWithFromUser:fromUser
                                   FromTest:model.source
                                       Type:@"题目"
                                      Title:model.title
                                    Content:model.summary
                                      Check:model.clicks
                                       Page:model.articleCount];
        return cell;

    } else {
        //图片
        static NSString *defaultCellID = @"mingtiPicCell";
        MingtiPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
        if (!cell) {
            cell = [[MingtiPicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
        //提供人
        NSString *fromUser = [NSString stringWithFormat:@"@%@ 提供", model.provider];
        [cell seMingtiPicCellWithFromUser:fromUser
                                   FromTest:model.source
                                       Type:@"题目"
                                      Title:model.title
                                    Content:model.summary
                                      Check:model.clicks
                                       Page:model.articleCount];
        
        
        NSArray *array = [model.picture componentsSeparatedByString:@","];
        [cell createMingtiPicCellWith:array];

        return cell;
        
    }
    
        
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MingtiListModel *model = self.dataSourceArray[indexPath.row];
    //命题作-详情
    MingtiDetailViewController *detailVC = [[MingtiDetailViewController alloc] init];
    detailVC.mingtiListModel = model;
    [self pushVC:detailVC animated:YES IsNeedLogin:NO];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MingtiListModel *model = self.dataSourceArray[indexPath.row];
    NSString *title = model.title;
    NSString *content = model.summary;

    CGSize titleSize = [self getSizeWithString:title font:[UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)] str_width:ScreenWidth - GTW(30) * 2];
    CGSize contentSize = [self getSizeWithString:content font:FONT(28) str_width:ScreenWidth - GTW(30)];
    
    CGFloat height = 0.0;
    if (titleSize.height >= GTH(90)) {
        titleSize.height = GTH(90);
    }
    if (contentSize.height >= GTH(130)) {
        contentSize.height = GTH(130);
    }
    
    if (model.picture.length == 0) {
        //文字
        height = GTH(86) * 2 + 2 + GTH(30) + titleSize.height + GTH(45) + contentSize.height + GTH(36) + GTH(23) + GTH(30);
        if (height >= GTH(520)) {
            height = GTH(520);
        }

    } else {
        //图片
        height = GTH(86) * 2 + 2 + GTH(30) + titleSize.height + GTH(45) + contentSize.height + GTH(30) + (ScreenWidth - GTW(30) * 4) / 3 + GTH(36) + GTH(23) + GTH(30);
        if (height >= GTH(790)) {
            height = GTH(790);
        }
    }
    return height;
    
    
}
#pragma mark - MingtiPicTableViewCellDelegate
- (void)selectedImageWithCell:(MingtiPicTableViewCell *)cell Index:(NSInteger)imageIndex
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    MingtiListModel *model = self.dataSourceArray[indexPath.row];
    NSArray *array = [model.picture componentsSeparatedByString:@","];

    MingtiPicShowViewController *picShowVC = [[MingtiPicShowViewController alloc] init];
    picShowVC.allPicCount = [NSString stringWithFormat:@"%ld", array.count];
    picShowVC.currentPicCount = [NSString stringWithFormat:@"%ld", imageIndex + 1];
    picShowVC.picArray = (NSMutableArray *)array;
    [self pushVC:picShowVC animated:YES IsNeedLogin:NO];
    
}



@end
