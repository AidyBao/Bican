//
//  BaseView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/23.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

#pragma mark - collectionView 的mj_header mj_footer结束加载动画
- (void)MJHeaderAndMJFooterEndRefreshWithCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView.mj_header isRefreshing]) {
        [collectionView.mj_header endRefreshing];
    }
    if ([collectionView.mj_footer isRefreshing]) {
        [collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - 创建MJ_Header
- (MJRefreshGifHeader *)createMJRefreshGifHeaderWithSelector:(SEL)selector
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < 51; i++) {
        NSString *string = [NSString stringWithFormat:@"图层 %d", i];
        UIImage *image = [UIImage imageNamed:string];
        [imageArray addObject:image];
    }
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:selector];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [header setImages:imageArray duration:2 forState:MJRefreshStateIdle];
    [header setImages:imageArray duration:2 forState:MJRefreshStatePulling];
    [header setImages:imageArray duration:2 forState:MJRefreshStateRefreshing];
    return header;
}

#pragma mark - 创建MJ_Footer
- (MJRefreshBackGifFooter *)createMJRefreshBackGifFooterWithSelector:(SEL)selector
{
    NSArray *imageArray = [NSArray array];
    for (int i = 1; i < 51; i++) {
        NSString *string = [NSString stringWithFormat:@"图层 %d", i];
        UIImage *image = [UIImage imageNamed:string];
        imageArray = [NSArray arrayWithObject:image];
    }
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:selector];
    
    [footer setImages:imageArray duration:2 forState:MJRefreshStateIdle];
    [footer setImages:imageArray duration:2 forState:MJRefreshStatePulling];
    [footer setImages:imageArray duration:2 forState:MJRefreshStateRefreshing];
    return footer;
}

//解决, tableview下移后自动返回的bug
- (void)setScrollIndicatorInsetsForTabelView:(UITableView *)tableView ContentInset:(UIEdgeInsets)contentInset
{
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //解决刷新时候的偏移量(!!!没有下拉刷新的时候, 这两句不用写, 暂时没改)
        tableView.contentInset = contentInset;
        tableView.scrollIndicatorInsets = tableView.contentInset;
    } 
}

//解决, collectionView下移后自动返回的bug
- (void)setScrollIndicatorInsetsForCollectionView:(UICollectionView *)collectionView ContentInset:(UIEdgeInsets)contentInset
{
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //解决刷新时候的偏移量
        collectionView.contentInset = contentInset;
        collectionView.scrollIndicatorInsets = collectionView.contentInset;
    }
}

//解决:push到有searchBar的页面, 返回后页面下移的问题
- (void)setConstraintsForSearchBar:(UISearchBar *)searchBar TitleView:(UIView *)navTitleView
{
    [NSLayoutConstraint activateConstraints:
     @[[searchBar.topAnchor constraintEqualToAnchor:navTitleView.topAnchor],
       [searchBar.leftAnchor constraintEqualToAnchor:navTitleView.leftAnchor constant:0],
       [searchBar.rightAnchor constraintEqualToAnchor:navTitleView.rightAnchor constant:0],
       [searchBar.bottomAnchor constraintEqualToAnchor:navTitleView.bottomAnchor],
       [searchBar.centerXAnchor constraintEqualToAnchor:navTitleView.centerXAnchor constant:0],]];
}

#pragma mark - 刷新tableview的指定row
- (void)reloadTableView:(UITableView *)tableView Row:(NSInteger)row Section:(NSInteger)section
{
    //刷新-row
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:reloadIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - 显示加载
- (void)showLoading
{
    [MBHUDManager showLoading];
}

#pragma mark - 隐藏加载
- (void)hideLoading
{
    [MBHUDManager hideAlert];
}

#pragma mark - tableView 的mj_header mj_footer结束加载动画
- (void)MJHeaderAndMJFooterEndRefreshWithTableView:(UITableView *)tableView
{
    if ([tableView.mj_header isRefreshing]) {
        [tableView.mj_header endRefreshing];
    }
    if ([tableView.mj_footer isRefreshing]) {
        [tableView.mj_footer endRefreshing];
    }
}

#pragma mark - 获取文本高度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_width:(CGFloat)str_width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4; //设置行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(str_width, 8000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@1.5f} context:nil];
    
    return rect.size;
}

#pragma mark - 获取文本宽度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_height:(CGFloat)str_height
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4; //设置行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(8000, str_height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@1.5f} context:nil];
    
    return rect.size;
}

@end
