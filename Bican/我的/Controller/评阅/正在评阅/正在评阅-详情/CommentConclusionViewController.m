//
//  CommentConclusionViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/27.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CommentConclusionViewController.h"
#import "CommentConclusionTableViewCell.h"
#import "ArticleConclusionModel.h"

@interface CommentConclusionViewController () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation CommentConclusionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"总评";
    [self createTableView];

}

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
    self.tableView.tableFooterView = view;
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
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
    static NSString *defaultCellID = @"commentConclusionTableViewCell";
    CommentConclusionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[CommentConclusionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.layer.shadowColor = RGBA(127, 127, 127, 1).CGColor;
    cell.layer.shadowOpacity = 0.24f;
    cell.layer.shadowRadius = GTH(20);
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    
    ArticleConclusionModel *model = self.dataSourceArray[indexPath.row];
    [cell setCommentConclusionCellWithTeacherName:model.firstname
                                         NickName:model.nickname
                                            Basic:model.basicLevel
                                      Development:model.developmentLevel
                                         Fraction:model.articleFraction];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleConclusionModel *model = self.dataSourceArray[indexPath.row];
    NSString *basic = model.basicLevel;
    NSString *development = model.developmentLevel;
    
    CGFloat width = ScreenWidth - GTW(30) * 2;
    
    CGSize basicSize = [self getSizeWithString:basic font:FONT(24) str_width:width];
    CGSize developSize = [self getSizeWithString:development font:FONT(24) str_width:width];

    return GTH(44) * 4 + GTH(30) * 9 + 3 + basicSize.height + developSize.height;
}



@end
