//
//  CheckCommentViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/13.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CheckCommentViewController.h"
#import "WJItemsControlView.h"
#import "CheckCommentView.h"
#import "AnnotationUserListModel.h"

@interface CheckCommentViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic, strong) WJItemsControlView *itemControlView;
@property (nonatomic, assign) NSInteger selectedIndex;//记录选中的位置
@property (nonatomic, strong) CheckCommentView *checkCommentView;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@end

@implementation CheckCommentViewController

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"作文批注";
    
    [self getAnnotationUserList];
    [self createScrollView];
    
}

#pragma mark - 获取批注用户列表
- (void)getAnnotationUserList
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.articleIdStr forKey:@"articleId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/annotation/userList", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.titleArray removeAllObjects];
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //存入大的model
        NSMutableArray *array = [resultObject objectForKey:@"data"];
        for (NSMutableDictionary *dic in array) {
            AnnotationUserListModel *model = [[AnnotationUserListModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.titleArray addObject:model];
        }
        //创建头部滚动
        [self createWJItemsView];
        
    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {
        
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - 创建头部
- (void)createWJItemsView
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[WJItemsControlView class]] || [view isKindOfClass:[CheckCommentView class]]) {
            [view removeFromSuperview];
            
        }
    }
    
    CGFloat header_height = GTH(76);

    //创建顶部的scrollView
    WJItemsConfig *config = [[WJItemsConfig alloc] init];
    config.selectedColor = ZTOrangeColor;
    config.textColor = ZTTitleColor;
    if (self.titleArray.count + 1 > 4) {
        config.itemWidth = ScreenWidth / 4.5;
    } else {
        config.itemWidth = ScreenWidth / (self.titleArray.count + 1);
    }
    config.itemFont = FONT(26);
    config.linePercent = 0.3;
    
    self.itemControlView = [[WJItemsControlView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, header_height)];
    self.itemControlView.tapAnimation = YES;
    self.itemControlView.config = config;
    self.itemControlView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"全部"];
    for (int i = 0; i < self.titleArray.count; i++) {
        AnnotationUserListModel *model = self.titleArray[i];
        [array addObject:model.nickname];
    }
    self.itemControlView.titleArray = array;
    
    __weak typeof (_bigScrollView)weakScrollView = _bigScrollView;
    [self.itemControlView setTapItemWithIndex:^(NSInteger index,BOOL animation){
        
        _selectedIndex = index;
        [weakScrollView scrollRectToVisible:CGRectMake(index * weakScrollView.frame.size.width, 0.0, weakScrollView.frame.size.width, weakScrollView.frame.size.height) animated:animation];
        
    }];
    [self.view addSubview:self.itemControlView];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(GTW(30), self.itemControlView.frame.size.height + self.itemControlView.frame.origin.y, ScreenWidth - GTW(30) * 2, 1)];
    self.lineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.lineView];
    
    for (int i = 0; i < self.titleArray.count + 1; i++) {
        //创建view
        self.checkCommentView = [[CheckCommentView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight - GTH(76) - NAV_HEIGHT)];
        self.checkCommentView.checkVC = self;
        self.checkCommentView.articleIdStr = self.articleIdStr;
        if (i == 0) {
            self.checkCommentView.annotationUserIdStr = @"0";
            self.checkCommentView.isShowAll = YES;
        } else {
            AnnotationUserListModel *model = self.titleArray[i - 1];
            self.checkCommentView.annotationUserIdStr = model.userId;
            self.checkCommentView.isShowAll = NO;
        }
        [self.bigScrollView addSubview:self.checkCommentView];
    }
    
    CGFloat scroll_height = ScreenHeight - NAV_HEIGHT - header_height - 1;
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth * (self.titleArray.count + 1), scroll_height);

    
}


#pragma mark - 创建ScrollView
- (void)createScrollView
{
    CGFloat header_height = GTH(76);
    CGFloat scroll_height = ScreenHeight - NAV_HEIGHT - header_height - 1;
    
    //底部内容的scrollView
    self.bigScrollView = [[UIScrollView alloc] init];
    self.bigScrollView.frame = CGRectMake(0, header_height + NAV_HEIGHT + 1, ScreenWidth, scroll_height);
    self.bigScrollView.backgroundColor = [UIColor whiteColor];
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.bounces = NO;
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.delegate = self;
    [self.view addSubview:self.bigScrollView];
    

}

#pragma mark - 滚动之后
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView moveToIndex:offset];
}

#pragma mark - 拖拽之后
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = scrollView.contentOffset.x;
    offset = offset / CGRectGetWidth(scrollView.frame);
    [_itemControlView endMoveToIndex:offset];
    
}


@end
