//
//  BaseView.h
//  Bican
//
//  Created by 迟宸 on 2018/1/23.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

#pragma mark - collectionView 的mj_header mj_footer结束加载动画
- (void)MJHeaderAndMJFooterEndRefreshWithCollectionView:(UICollectionView *)collectionView;

#pragma mark - 创建MJ_Header
- (MJRefreshGifHeader *)createMJRefreshGifHeaderWithSelector:(SEL)selector;

#pragma mark - 创建MJ_Footer
- (MJRefreshBackGifFooter *)createMJRefreshBackGifFooterWithSelector:(SEL)selector;

//解决, tableview下移后自动返回的bug
- (void)setScrollIndicatorInsetsForTabelView:(UITableView *)tableView ContentInset:(UIEdgeInsets)contentInset;

//解决, collectionView下移后自动返回的bug
- (void)setScrollIndicatorInsetsForCollectionView:(UICollectionView *)collectionView ContentInset:(UIEdgeInsets)contentInset;

//解决:push到有searchBar的页面, 返回后页面下移的问题
- (void)setConstraintsForSearchBar:(UISearchBar *)searchBar TitleView:(UIView *)navTitleView;

#pragma mark - 刷新tableview的指定row
- (void)reloadTableView:(UITableView *)tableView Row:(NSInteger)row Section:(NSInteger)section;

#pragma mark - 显示加载
- (void)showLoading;

#pragma mark - 隐藏加载
- (void)hideLoading;

#pragma mark - tableView 的mj_header mj_footer结束加载动画
- (void)MJHeaderAndMJFooterEndRefreshWithTableView:(UITableView *)tableView;

#pragma mark - 获取文本高度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_width:(CGFloat)str_width;

#pragma mark - 获取文本宽度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_height:(CGFloat)str_height;


@end
