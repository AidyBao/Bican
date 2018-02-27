//
//  ZTBottomView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTBottomView.h"
#import "ZTBottomTableViewCell.h"

@interface ZTBottomView () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;//数据源
@property (nonatomic, strong) NSMutableArray *checkArray;

@property (nonatomic, strong) NSString *oldSelectedStr;//原来的选中
@property (nonatomic, strong) NSMutableArray *selectedArray;//选中的数组
@property (nonatomic, strong) NSMutableArray *selectedIndexArray;//选中下标的数组
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;//选中的IndexPath
@property (nonatomic, strong) NSMutableDictionary *resultDic;

@end

@implementation ZTBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedIndexPath = nil;
        self.dataSourceArray = [NSMutableArray array];
        self.selectedIndexArray = [NSMutableArray array];
        self.selectedArray = [NSMutableArray array];
        self.checkArray = [NSMutableArray array];
        self.resultDic = [NSMutableDictionary dictionary];
        [self createSubViews];
    }
    return self;
}

- (void)setZTBottomViewWithArray:(NSArray *)array
                  OldSelectedStr:(NSString *)oldSelectedStr
{
    self.selectedIndexPath = nil;
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:array];
    
    [self.selectedIndexArray removeAllObjects];
    [self.selectedArray removeAllObjects];
    
    self.oldSelectedStr = oldSelectedStr;

    if (self.isCanChooseMore) {
        [self.resultDic removeAllObjects];
        [self.checkArray removeAllObjects];
        for (int i  = 0; i < self.dataSourceArray.count; i++) {
//            NSString *string = self.dataSourceArray[i];
//            if ([string containsString:@"班"]) {
//            }
            [self checkTeacherWithIndex:i];
        }
    } else {
        [self.tableView reloadData];
    }
    
//    __weak typeof(self) weakSelf = self;
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
//    
//    dispatch_group_async(group, queue, ^{
//        for (int i  = 0; i < weakSelf.dataSourceArray.count; i++) {
//            [NSThread sleepForTimeInterval:i];
//            [weakSelf checkTeacherWithIndex:i];
//        }
//    });

}

#pragma mark - 检验班级是否已有教师
- (void)checkTeacherWithIndex:(NSInteger)indexStr
{
    if (self.classIdArray.count == 0) {
        [self hideLoading];
        return;
    }
    if (indexStr == 0) {
        [self showLoading];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.classIdArray[indexStr] forKey:@"classId"];

    NSString *url = [NSString stringWithFormat:@"%@api/class/checkTeacher", BASE_URL];
    
    [NetWorkingManager postWithIndexStr:indexStr UrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject, NSInteger index) {
        
        if (indexStr == self.dataSourceArray.count - 1) {
            [self hideLoading];
        }
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //true-允许加入, false-不能加入
        NSString *string = [resultObject objectForKey:@"data"];
        if (![[self.resultDic allKeys] containsObject:[NSString stringWithFormat:@"%ld", index]]) {
            [self.resultDic setValue:string forKey:[NSString stringWithFormat:@"%ld", index]];
        }
        //排序字典
        if ([self.resultDic allKeys].count == self.dataSourceArray.count) {
            [self sortDic];
        }
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];

    }];
    
}

//字典排序, 存入数组
- (void)sortDic
{
    [self hideLoading];
    
    NSArray *array = [self.resultDic allKeys];
    
    NSComparator finderSort = ^(id string1, id string2){
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        } else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    };
    //数组排序：
    array = [array sortedArrayUsingComparator:finderSort];

    for (int i = 0; i< array.count; i++) {
        NSString *key = array[i];
        NSString *value = [NSString stringWithFormat:@"%@", [self.resultDic objectForKey:key]];
        [self.checkArray addObject:value];
    }
    
    if (self.checkArray.count == self.dataSourceArray.count) {
        [self.tableView reloadData];
    }
    
}

- (void)createSubViews
{
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.rowHeight = GTH(80);
    [self addSubview:self.tableView];
    
    [self.tableView registerClass:[ZTBottomTableViewCell class] forCellReuseIdentifier:@"bottomViewCell"];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
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
    static NSString *defaultCellID = @"bottomViewCell";
    ZTBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    
    if (self.isCanChooseMore) {
        //多选
        NSString *string = self.dataSourceArray[indexPath.row];
        cell.titleLabel.text = string;
        [cell setCellIsSelected:NO];
        
        if (self.checkArray.count != 0) {
            NSString *check = self.checkArray[indexPath.row];
            
            if (self.isDoAppeal) {
                //如果是申诉
                if (![check isEqualToString:@"true"]) {
                    //允许加入-右侧label隐藏
                    [cell showDoAppeal:YES IsHiddenRight:YES];
                } else {
                    //不允许加入
                    [cell showDoAppeal:YES IsHiddenRight:NO];
                }

            } else {
                //如果是加入班级
                if (![check isEqualToString:@"true"]) {
                    //允许加入-右侧label隐藏
                    [cell setRightLabelHidden:YES];
                } else {
                    //不允许加入
                    [cell setRightLabelHidden:NO];
                }
            }
            
            //如果选中的内容包含
            if ([self.selectedIndexArray containsObject:[NSString stringWithFormat:@"%ld", indexPath.row]]) {
                [cell setCellIsSelected:YES];
            }  else {
                [cell setCellIsSelected:NO];
            }
        }
        
        
    } else {
        //单选
        NSString *string = self.dataSourceArray[indexPath.row];
        cell.titleLabel.text = string;
        [cell setCellIsSelected:NO];
        
        //如果之前有选择过的内容
        if (self.oldSelectedStr.length != 0) {
            if ([self.oldSelectedStr isEqualToString:string]) {
                [cell setCellIsSelected:YES];
            }
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.dataSourceArray.count == 0) {
        return;
    }
    NSString *string = self.dataSourceArray[indexPath.row];
    
    //如果单选
    if (!self.isCanChooseMore) {
        //如果之前有选择过的内容
        if (self.oldSelectedStr.length != 0) {
            for (int i = 0; i < self.dataSourceArray.count; i++) {
                NSString *nowStr = self.dataSourceArray[i];
                if ([self.oldSelectedStr isEqualToString:nowStr]) {
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    _selectedIndexPath = path;
                }
            }
        }
        
        NSInteger newRow = indexPath.row;
        NSInteger oldRow = _selectedIndexPath.row;
        
        ZTBottomTableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        [currentCell setCellIsSelected:YES];
        //把选中的值重新赋值
        self.oldSelectedStr = self.dataSourceArray[newRow];
        
        if (newRow != oldRow) {
            ZTBottomTableViewCell *lastCell = [tableView cellForRowAtIndexPath:_selectedIndexPath];
            [lastCell setCellIsSelected:NO];
        } else {
            [currentCell setCellIsSelected:YES];
            
        }
        _selectedIndexPath = indexPath;
        
        //协议
        if ([self.delegate respondsToSelector:@selector(currentView:SelectedIndex:SelectedContent:)]) {
            [self.delegate currentView:self SelectedIndex:indexPath.row SelectedContent:string];
        }
        
    } else {
        //如果多选
        ZTBottomTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (self.checkArray.count != 0) {
            if (self.isDoAppeal) {
                //如果是申诉
                if (![self.checkArray[indexPath.row] isEqualToString:@"true"]) {
                    [ZTToastUtils showToastIsAtTop:NO Message:@"请选择已有老师班级进行申诉" Time:3.0];
                    return ;
                }
            } else {
                //如果是加入班级
                if ([self.checkArray[indexPath.row] isEqualToString:@"true"]) {
                    [ZTToastUtils showToastIsAtTop:NO Message:@"班级已有教师, 不能加入" Time:3.0];
                    return ;
                }
            }
            
        }
        if (cell.chooseButton.selected) {
            [cell setCellIsSelected:NO];
            
        } else {
            if (self.isCanChooseMore) {
                if (!self.isDoAppeal) {
                    //最多只能加入4个班级
                    NSString *string = (NSString *)self.dataSourceArray[0];
                    if (self.selectedIndexArray.count == 4 && [string containsString:@"班"]) {
                        [ZTToastUtils showToastIsAtTop:NO Message:@"任教老师班级不能超过4个!" Time:3.0];
                        return;
                    }
                }
            }
            [cell setCellIsSelected:YES];
        }
        
        if (![self.selectedArray containsObject:string]) {
            //选中 -- 添加
            [self.selectedArray addObject:string];
            [self.selectedIndexArray addObject:[NSString stringWithFormat:@"%ld", indexPath.row]];
        } else {
            //移除
            [self.selectedArray removeObject:string];
            [self.selectedIndexArray removeObject:[NSString stringWithFormat:@"%ld", indexPath.row]];
        }
        //协议
        if ([self.delegate respondsToSelector:@selector(currentView:SelectedArray:SelectedIndexArray:SelectedContent:)]) {
            NSString *string = [self.selectedArray componentsJoinedByString:@","];
            [self.delegate currentView:self SelectedArray:(NSArray *)self.selectedArray SelectedIndexArray:(NSArray *)self.selectedIndexArray SelectedContent:string];
        }
    }
}


@end
