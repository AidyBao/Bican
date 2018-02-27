//
//  ZTBaseViewController.h
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZTBaseViewController : UIViewController

#pragma mark - 创建导航拦左按钮
- (void)createLeftNavigationItem:(UIImage *)leftImage Title:(NSString *)leftTitle;
#pragma mark - 创建导航拦右按钮
- (void)createRightNavigationItem:(UIImage *)RightImage
                            Title:(NSString *)RightTitle
                  RithtTitleColor:(UIColor *)RithtTitleColor
                  BackgroundColor:(UIColor *)backgroundColor
                     CornerRadius:(CGFloat)cornerRadius;

#pragma mark - 点击左按钮
- (void)LeftNavigationButtonClick:(UIButton *)leftbtn;
#pragma mark - 点击右按钮
- (void)RightNavigationButtonClick:(UIButton *)rightbtn;
#pragma mark - 创建系统样式的左右按钮
- (void)createLeftSystemNavigationItemWith:(UIBarButtonSystemItem )systemBarStyle;
- (void)createRightSystemNavigationItemWith:(UIBarButtonSystemItem )systemBarStyle;

#pragma mark - 系统的样式的点击事件
-(void)LeftSystemNavigationButtonClick;

-(void)RightSystemNavigationButtonClick;

#pragma mark - 从16进制代码创建颜色
- (UIColor *)getColor:(NSString*)hexColor;

#pragma mark - 创建背景颜色的图片
- (UIImage *)createImageWithColor:(UIColor *)color Height:(CGFloat)height;

#pragma mark - 获取系统时间（年月日）
- (NSString *)getSystemTimeWithFormatter:(NSString *)formatter;

#pragma mark - popToVC
- (void)popToVC:(UIViewController *)viewController animated:(BOOL)animated;

#pragma mark - pushVC
- (void)pushVC:(UIViewController *)viewController animated:(BOOL)animated IsNeedLogin:(BOOL)isNeedLogin;

#pragma mark - popVC
- (void)popVCAnimated:(BOOL)animated;

#pragma mark - popToRootVC
- (void)popToRootVCAnimated:(BOOL) animated;

#pragma mark - 跳转到登录页面
- (void)pushToLoginVC;

#pragma mark - 刷新tableview的指定row
- (void)reloadTableView:(UITableView *)tableView Row:(NSInteger)row Section:(NSInteger)section;

#pragma mark - 显示加载
- (void)showLoading;

#pragma mark - 隐藏加载
- (void)hideLoading;

#pragma mark - tableView 的mj_header mj_footer结束加载动画
- (void)MJHeaderAndMJFooterEndRefreshWithTableView:(UITableView *)tableView;
- (void)MJHeaderAndMJFooterEndRefreshWithCollectionView:(UICollectionView *)collectionView;

#pragma mark - 创建MJ_Header MJ_Footer
- (MJRefreshGifHeader *)createMJRefreshGifHeaderWithSelector:(SEL)selector;
- (MJRefreshBackGifFooter *)createMJRefreshBackGifFooterWithSelector:(SEL)selector;

#pragma mark - 适配iPhone X中的tableView出现的问题
- (void)setScrollIndicatorInsetsForTabelView:(UITableView *)tableView ContentInset:(UIEdgeInsets)contentInset;

#pragma mark - 适配iPhone X中的collectionView出现的问题
- (void)setScrollIndicatorInsetsForCollectionView:(UICollectionView *)collectionView ContentInset:(UIEdgeInsets)contentInset;

#pragma mark - 适配iPhone X中的searchBar出现的问题
- (void)setConstraintsForSearchBar:(UISearchBar *)searchBar TitleView:(UIView *)navTitleView;

#pragma mark - 只有一个确认按钮的alert, 按钮没有回调
- (void)showTipAlertWithTitle:(NSString *)title;

#pragma mark - 身份证最后一位是x 变为大写X
- (NSString *)changeTheLastLetterToUpperLetterWith:(NSString *)string;

#pragma mark - 转换html字符串
- (NSAttributedString *)htmlStringToChangeWithString:(NSString *)string;

#pragma mark - 获取文本高度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_width:(CGFloat)str_width;

#pragma mark - 获取文本宽度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_height:(CGFloat)str_height;


#pragma mark - 获取label文字的行数和每行的文字
- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label;
#pragma mark - 获取label文字的行数和每行的内容(array.count就是行数)
- (CFIndex)getindexArrayOfStringInLabel:(UILabel *)label Point:(CGPoint)point;
- (CFIndex)getindexArrayOfStringInTextView:(UITextView *)textView Point:(CGPoint)point;

#pragma mark - 格式化手机号
- (NSString *)formatPhoneNumber:(NSString *)phone;

#pragma mark - 格式化身份证号
- (NSString *)formatCerNo:(NSString *)cerno;

#pragma mark - 格式化邮箱
- (NSString *)formatEmail:(NSString *)email;

#pragma mark - 根据身份证号, 获取生日
- (NSString *)getBrithdayWithCerNo:(NSString *)cerNo;

#pragma mark - 根据身份证号, 获取性别
-(NSString *)getIdentityCardSex:(NSString *)numberStr;

#pragma mark - 退出app
- (void)notExistCall;



@end

