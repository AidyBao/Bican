//
//  FindDetailViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/11.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "FindDetailViewController.h"
#import "ZiyouReplyTableViewCell.h"
#import "ZiyouTeacherTableViewCell.h"
#import "ArticleModel.h"
#import "ArticleConclusionModel.h"//总评
#import "ArticleAnnotationModel.h"//批注
#import "ArticleCommentModel.h"//评论
#import "ArticleCommentDetailModel.h"//评论-详情
#import "AnnotationListView.h"

#import "CheckCommentViewController.h"

@interface FindDetailViewController ()  <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, ZiyouReplyTableViewCellDelegate, UITextFieldDelegate, AnnotationListViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *articleConclusionArray;//总评数组
@property (nonatomic, strong) NSMutableArray *articleAnnotationArray;//批注数组
@property (nonatomic, strong) NSMutableArray *articleCommentArray;//回复数组

@property (nonatomic, strong) ArticleModel *articleModel;
@property (nonatomic, strong) ArticleConclusionModel *articleConclusionModel;
@property (nonatomic, strong) AnnotationListView *annotationListView;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, assign) BOOL isUpData;//判断上拉下拉
@property (nonatomic, strong) NSString *pageCount;//总页数(number)

@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *typeNameLabel;
@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UIView *typeLineView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UIView *titleLineView;

@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UIView *schoolLineView;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) NSMutableArray *bottomArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) NSString *praiseFlag;//记录点赞的flag
@property (nonatomic, strong) NSString *collectFlag;//记录收藏的flag
@property (nonatomic, strong) NSString *appraiseStatus;//记录评论的flag

@property (nonatomic, strong) UIView *textBackView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendButton;//发送按钮
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;//记录选中的行
@property (nonatomic, assign) BOOL isReplyTextField;//判断是评论还是回复
@property (nonatomic, assign) CGFloat keyboardHeight;//记录键盘的高

@property (nonatomic, assign) CGPoint tapPoint;//记录轻拍的point
@property (nonatomic, assign) NSInteger firstStrindex;//记录字符串中第一个字符串的index

@end

@implementation FindDetailViewController

- (NSMutableArray *)bottomArray
{
    if (!_bottomArray) {
        _bottomArray = [NSMutableArray arrayWithObjects:@"查看批注", @"总评", @"点赞", @"收藏", @"评论", nil];
    }
    return _bottomArray;
}

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)articleCommentArray
{
    if (!_articleCommentArray) {
        _articleCommentArray = [NSMutableArray array];
    }
    return _articleCommentArray;
}

- (NSMutableArray *)articleAnnotationArray
{
    if (!_articleAnnotationArray) {
        _articleAnnotationArray = [NSMutableArray array];
    }
    return _articleAnnotationArray;
}

- (NSMutableArray *)articleConclusionArray
{
    if (!_articleConclusionArray) {
        _articleConclusionArray = [NSMutableArray array];
    }
    return _articleConclusionArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //注册通知
    //键盘将要出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.textField resignFirstResponder];
    //移除键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}

- (void)dealloc
{
    //移除键盘监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.isRecommend isEqualToString:@"0"]) {
        //未推荐, 显示推荐作文按钮
        [self createRightNavigationItem:nil Title:@"推荐作文" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:GTH(10)];
    }
    [self modifyReadStatus];
    [self get_Article_Detail];
    [self get_CommentList];
    [self createBottomView];
    [self createTableView];
    [self createTextField];

}

#pragma mark - 推荐作文接口
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.articleIdStr forKey:@"articleId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/recommend", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"推荐作文成功" Time:3.0];
        [self createBottomView];
        [self get_Article_Detail];
        [self get_CommentList];
        
    } errorHandler:^(NSError *error) {
        
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 作文评论列表(回复数据)
- (void)get_CommentList
{
    if (self.isUpData == NO) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.articleIdStr forKey:@"articleId"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.page_size] forKey:@"pageRows"];
    [params setValue:[NSString stringWithFormat:@"%ld", (long)self.start_row] forKey:@"pageStart"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/commentList", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (self.isUpData == NO) {
            [self.articleCommentArray removeAllObjects];
        }
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSDictionary *dataDic = [resultObject objectForKey:@"data"];
        NSDictionary *pages = [dataDic objectForKey:@"pages"];
        self.pageCount = [NSString stringWithFormat:@"%@", [pages objectForKey:@"pageCount"]];
        NSMutableArray *array = [dataDic objectForKey:@"list"];
        for (NSMutableDictionary *dic in array) {
            ArticleCommentModel *model = [[ArticleCommentModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.articleCommentArray addObject:model];
        }
        [self.tableView reloadData];

        if ([self.pageCount integerValue] <= self.start_row) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } errorHandler:^(NSError *error) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];

    } reloadHandler:^(BOOL isReload) {
        
        [self MJHeaderAndMJFooterEndRefreshWithTableView:self.tableView];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 获取作文详情(总评 && 批注)
- (void)get_Article_Detail
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.articleIdStr forKey:@"articleId"];
    //是否查看批注和总评: 0-查看批注和总评(添加批注数组), 1-评阅批注和总评(没有批注数组)
    [params setValue:@"0" forKey:@"isComment"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/get", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self.articleAnnotationArray removeAllObjects];
        [self.articleConclusionArray removeAllObjects];
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        //存入大的model
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        self.articleModel = [[ArticleModel alloc] init];
        [self.articleModel setValuesForKeysWithDictionary:dic];
        //批注数组
        NSMutableArray *annotationArray = [dic objectForKey:@"articleAnnotationList"];
        for (NSMutableDictionary *annotationDic in annotationArray) {
            ArticleAnnotationModel *model = [[ArticleAnnotationModel alloc] init];
            [model setValuesForKeysWithDictionary:annotationDic];
            [self.articleAnnotationArray addObject:model];
        }
        //总评数组
        NSMutableArray *conclusionArray = [dic objectForKey:@"articleConclusionList"];
        for (NSMutableDictionary *conclusionDic in conclusionArray) {
            ArticleConclusionModel *model = [[ArticleConclusionModel alloc] init];
            [model setValuesForKeysWithDictionary:conclusionDic];
            [self.articleConclusionArray addObject:model];
        }
        //更新
        self.praiseFlag = _articleModel.praiseFlag;
        self.collectFlag = _articleModel.collectFlag;
        [self createBottomView];
        [self createTableHeaderView];
        [self.tableView reloadData];
        
    } errorHandler:^(NSError *error) {
        

    } reloadHandler:^(BOOL isReload) {
        
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - 创建键盘
- (void)createTextField
{
    CGFloat text_height = GTH(108);
    
    self.textBackView = [[UIView alloc] init];
    self.textBackView.backgroundColor = ZTNavColor;
    [self.view addSubview:self.textBackView];
    
    [self.textBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(ScreenHeight);
        make.height.mas_equalTo(text_height);
    }];
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sendButton setBackgroundColor:ZTOrangeColor];
    self.sendButton.layer.cornerRadius = GTH(10);
    self.sendButton.titleLabel.font = FONT(28);
    [self.sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.textBackView addSubview:self.sendButton];

    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.textBackView.mas_right).offset(GTW(-10));
        make.width.height.mas_equalTo(text_height - GTH(15) * 2);
        make.top.equalTo(self.textBackView).offset(GTH(15));
    }];

    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.cornerRadius = GTH(10);
    whiteView.layer.masksToBounds = YES;
    [self.textBackView addSubview:whiteView];

    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textBackView.mas_left).offset(GTW(20));
        make.right.equalTo(self.sendButton.mas_left).offset(GTW(-10));
        make.top.equalTo(self.textBackView.mas_top).offset(GTH(15));
        make.bottom.equalTo(self.textBackView.mas_bottom).offset(GTH(-15));
    }];

    UIImageView *messageImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pinglun_icon"]];
    [self.textBackView addSubview:messageImageView];

    [messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textBackView);
        make.left.equalTo(whiteView.mas_left).offset(GTW(10));
        make.size.mas_equalTo(CGSizeMake(GTW(32), GTH(28)));
    }];

    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor whiteColor];
    self.textField.delegate = self;
    self.textField.font = FONT(22);
    self.textField.textColor = ZTTitleColor;
    [self.textField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.textField setValue:FONT(22) forKeyPath:@"_placeholderLabel.font"];
    self.textField.placeholder = @"发表评论";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [whiteView addSubview:self.textField];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(messageImageView.mas_right).offset(GTW(10));
        make.top.height.right.equalTo(whiteView);
    }];
    
    
    
}

#pragma mark - 发表评论
- (void)sendButtonAction
{
    if (self.isReplyTextField) {
        //回复
        if (self.textField.text.length == 0) {
            [ZTToastUtils showToastIsAtTop:YES Message:@"请输入回复内容" Time:3.0];
            return;
        }
        [self.textField resignFirstResponder];
        ArticleCommentModel *model = self.articleCommentArray[self.selectedIndexPath.row];
        //调用评论接口
        [self replyCommentWithModel:model];
        
    } else {
        //评论
        if (self.textField.text.length == 0) {
            [ZTToastUtils showToastIsAtTop:YES Message:@"请输入评论内容" Time:3.0];
            return;
        }
        [self.textField resignFirstResponder];
        [self addComment];
    }
    
}


#pragma mark - 键盘将要出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    // 获取用户信息
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // 获取键盘高度
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    self.keyboardHeight = keyboardRect.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        
        [self.textBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(ScreenHeight - GTH(108) - GTH(88));
        }];
        
    }];

    
}

#pragma mark - 键盘将要隐藏
- (void)keyboardWillHide:(NSNotification *)notification
{
    [self.textField resignFirstResponder];
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    self.keyboardHeight = 0;
    [UIView animateWithDuration:animationTime animations:^{
        
        [self.textBackView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(ScreenHeight);
        }];
        
    }];
}

#pragma mark - 创建ToolBar
- (void)createBottomView
{
    for (UIView *view in self.bottomView.subviews) {
        [view removeFromSuperview];
    }
    [self.bottomView removeFromSuperview];
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.frame = CGRectMake(0, ScreenHeight - GTH(88), ScreenWidth, GTH(88));
    //设置背景色
    self.bottomView.backgroundColor = ZTNavColor;
    [self.view addSubview:self.bottomView];
    
    CGFloat button_width;
    [self.buttonArray removeAllObjects];
    
    if ([self.isRecommend isEqualToString:@"0"]) {//未推荐
        button_width = (ScreenWidth - GTW(30) * 4) / 3;
        for (int i = 0; i < 3; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(GTW(30) * (i + 1) + button_width * i, 0, button_width, GTH(88));
            button.tag = 1001 + i;
            if (i == 0) {
                [button setTitle:@"查看批注" forState:UIControlStateNormal];
            }
            if (i == 1) {
                [button setTitle:@"总评" forState:UIControlStateNormal];
            }
            if (i == 2 && _articleModel.commentNumber.length != 0) {
                //评论
                [button setTitle:[NSString stringWithFormat:@"评论 %@", _articleModel.commentNumber] forState:UIControlStateNormal];
            }
            [button setTitleColor:ZTTextLightGrayColor forState:UIControlStateNormal];
            [button setTitleColor:ZTOrangeColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = FONT(24);
            [self.bottomView addSubview:button];
            [self.buttonArray addObject:button];
        }
        
    } else {
        //推荐
        button_width = (ScreenWidth - GTW(30) * 6) / 5;
        for (int i = 0; i < 5; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(GTW(30) * (i + 1) + button_width * i, 0, button_width, GTH(88));
            button.tag = 1001 + i;
            [button setTitle:(NSString *)self.bottomArray[i] forState:UIControlStateNormal];
            if (i == 2 && _articleModel.praiseNumber.length != 0) {
                //点赞
                //记录flag
                if ([self.praiseFlag isEqualToString:@"1"]) {
                    button.selected = YES;
                }
                [button setTitle:[NSString stringWithFormat:@"点赞 %@", _articleModel.praiseNumber] forState:UIControlStateNormal];
            }
            if (i == 3 && _articleModel.collectionNumber.length != 0) {
                //收藏
                //记录flag
                if ([self.collectFlag isEqualToString:@"1"]) {
                    button.selected = YES;
                }
                [button setTitle:[NSString stringWithFormat:@"收藏 %@", _articleModel.collectionNumber] forState:UIControlStateNormal];
            }
            if (i == 4 && _articleModel.commentNumber.length != 0) {
                //评论
                [button setTitle:[NSString stringWithFormat:@"评论 %@", _articleModel.commentNumber] forState:UIControlStateNormal];
            }
            [button setTitleColor:ZTTextLightGrayColor forState:UIControlStateNormal];
            [button setTitleColor:ZTOrangeColor forState:UIControlStateSelected];
            [button addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = FONT(24);
            [self.bottomView addSubview:button];
            [self.buttonArray addObject:button];
        }
    
    }

}

#pragma mark - button点击方法
- (void)bottomButtonAction:(UIButton *)sender
{
    if (sender.tag == 1001) {
        //查看批注
        CheckCommentViewController *checkCommentVC = [[CheckCommentViewController alloc] init];
        checkCommentVC.articleIdStr = _articleModel.articleId;
        [self pushVC:checkCommentVC animated:YES IsNeedLogin:NO];
    }
    if (sender.tag == 1002) {
        //总评
        if (self.articleConclusionArray.count == 0 && self.articleCommentArray.count != 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        if (self.articleCommentArray.count == 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            return;
        }
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    if ([self.isRecommend isEqualToString:@"0"]) {//未推荐
        if (sender.tag == 1003) {
            //评论
            if (![GetUserInfo judgIsloginByUserModel]) {
                [self pushToLoginVC];
                return;
            }
            self.isReplyTextField = NO;
            [self.textField setText:@""];
            [self.textField becomeFirstResponder];
        }
        
    } else {//已经推荐
        if (sender.tag == 1003) {
            //点赞
            if (![GetUserInfo judgIsloginByUserModel]) {
                [self pushToLoginVC];
                return;
            }
            sender.selected = !sender.selected;
            if ([self.praiseFlag isEqualToString:@"1"]) {
                self.praiseFlag = @"0";
                [self articlePraiseOrNot];
            } else {
                self.praiseFlag = @"1";
                [self articlePraiseOrNot];
            }
        }
        if (sender.tag == 1004) {
            //收藏
            if (![GetUserInfo judgIsloginByUserModel]) {
                [self pushToLoginVC];
                return;
            }
            sender.selected = !sender.selected;
            if ([self.collectFlag isEqualToString:@"1"]) {
                self.collectFlag = @"0";
                [self articleCollectOrNot];
            } else {
                self.collectFlag = @"1";
                [self articleCollectOrNot];
            }
        }
        if (sender.tag == 1005) {
            //评论
            if (![GetUserInfo judgIsloginByUserModel]) {
                [self pushToLoginVC];
                return;
            }
            self.isReplyTextField = NO;
            [self.textField setText:@""];
            [self.textField becomeFirstResponder];
        }
    }
}

#pragma mark - 作文点赞与取消点赞
- (void)articlePraiseOrNot
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.articleIdStr forKey:@"articleId"];
    //1-点赞, 0-取消点赞
    [params setValue:self.praiseFlag forKey:@"praiseFlag"];

    NSString *url = [NSString stringWithFormat:@"%@api/article/praise", BASE_URL];

    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {

        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        if ([self.praiseFlag isEqualToString:@"1"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"点赞成功" Time:3.0];
            self.praiseFlag = @"0";
        } else {
            [ZTToastUtils showToastIsAtTop:NO Message:@"取消点赞成功" Time:3.0];
            self.praiseFlag = @"1";
        }
        //重新请求
        [self get_Article_Detail];
        
    } errorHandler:^(NSError *error) {
        

    } reloadHandler:^(BOOL isReload) {
        
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - 作文收藏与取消收藏
- (void)articleCollectOrNot
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.articleIdStr forKey:@"articleId"];
    //1-收藏, 0-取消收藏
    [params setValue:self.collectFlag forKey:@"collectFlag"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/collect", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        if ([self.collectFlag isEqualToString:@"1"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"收藏成功" Time:3.0];
            self.collectFlag = @"0";
        } else {
            [ZTToastUtils showToastIsAtTop:NO Message:@"取消收藏成功" Time:3.0];
            self.collectFlag = @"1";
        }
        //重新请求
        [self get_Article_Detail];
        
    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {
        
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 添加作文评论
- (void)addComment
{
    if (![GetUserInfo judgIsloginByUserModel]) {
        [self pushToLoginVC];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.articleIdStr forKey:@"articleId"];
    [params setValue:self.textField.text forKey:@"content"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/comment/addComment", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"评论成功" Time:3.0];
        //重新请求
        [self get_CommentList];
        
    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {
        
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 回复作文评论
- (void)replyCommentWithModel:(ArticleCommentModel *)model
{
    if (![GetUserInfo judgIsloginByUserModel]) {
        [self pushToLoginVC];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.articleIdStr forKey:@"articleId"];
    [params setValue:self.textField.text forKey:@"content"];
    // 评论ID
    [params setValue:model.comment_id forKey:@"commentId"];

    NSString *url = [NSString stringWithFormat:@"%@api/comment/replyComment", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"回复评论成功" Time:3.0];
        //重新请求
        [self get_Article_Detail];
        [self get_CommentList];
        
    } errorHandler:^(NSError *error) {
        
    
    } reloadHandler:^(BOOL isReload) {
        
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 删除评论
- (void)remove_CommentWithModel:(ArticleCommentModel *)model
{
    if (![GetUserInfo judgIsloginByUserModel]) {
        [self pushToLoginVC];
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.articleIdStr forKey:@"articleId"];
    // 评论ID
    [params setValue:model.comment_id forKey:@"commentId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/comment/remove", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"删除评论成功" Time:3.0];
        //重新请求
        [self get_Article_Detail];
        [self get_CommentList];
        
    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {
        
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 创建UITableView
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
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.bottom.equalTo(self.view.mas_bottom).offset(GTH(-88));
    }];

    //刷新数据
    //mj_header
    self.tableView.mj_header = [self createMJRefreshGifHeaderWithSelector:@selector(refreshData)];
    
    //mj_footer
    self.tableView.mj_footer = [self createMJRefreshBackGifFooterWithSelector:@selector(loadMoreData)];
    
    if (![self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header beginRefreshing];
    }
    
}

//刷新数据
- (void)refreshData
{
    self.isUpData = NO;
    self.start_row = 1;
    self.page_size = 10;
    [self get_CommentList];
    [self get_Article_Detail];
    
}

//加载更多
- (void)loadMoreData
{
    self.isUpData = YES;
    self.start_row += 1;
    [self get_CommentList];
}

#pragma mark - 创建TableHeaderView
- (void)createTableHeaderView
{
    for (UIView *view in self.tableHeaderView.subviews) {
        [view removeFromSuperview];
    }
    [self.tableHeaderView removeFromSuperview];
    
    CGFloat label_height = GTH(88);
    
    self.tableHeaderView = [[UIView alloc] init];
    self.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    //栏目
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(GTW(30), (label_height - GTH(44)) / 2, GTW(67), GTH(44))];
    self.typeLabel.text = @"栏目";
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.backgroundColor = ZTOrangeColor;
    self.typeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    self.typeLabel.font = FONT(30);
    [self.tableHeaderView addSubview:self.typeLabel];
    
    self.readLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - GTW(30) - GTW(150), (label_height - GTH(27)) / 2, GTW(150), GTH(27))];
    self.readLabel.textColor = ZTTextLightGrayColor;
    self.readLabel.font = FONT(28);
    self.readLabel.textAlignment = NSTextAlignmentRight;
    [self.tableHeaderView addSubview:self.readLabel];
    
    self.typeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.frame.size.width + self.typeLabel.frame.origin.x + GTW(30), 0, ScreenWidth - self.typeLabel.frame.size.width - self.typeLabel.frame.origin.x - GTW(30) * 2 - self.readLabel.frame.size.width, label_height)];
    self.typeNameLabel.textColor = ZTTextGrayColor;
    self.typeNameLabel.font = FONT(30);
    [self.tableHeaderView addSubview:self.typeNameLabel];
    
    self.typeLineView = [[UIView alloc] initWithFrame:CGRectMake(GTW(30), self.typeNameLabel.frame.size.height + self.typeNameLabel.frame.origin.y, ScreenWidth - GTW(30) * 2, 1)];
    self.typeLineView.backgroundColor = ZTLineGrayColor;
    [self.tableHeaderView addSubview:self.typeLineView];
    
    //题目
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(GTW(30), self.typeLineView.frame.size.height + self.typeLineView.frame.origin.y +  (label_height - GTH(44)) / 2, GTW(67), GTH(44))];
    self.titleLabel.text = @"题目";
    self.titleLabel.font = FONT(30);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = ZTOrangeColor;
    self.titleLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.tableHeaderView addSubview:self.titleLabel];
    
    self.titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.frame.size.width + self.titleLabel.frame.origin.x + GTW(30), self.typeLineView.frame.size.height + self.typeLineView.frame.origin.y, ScreenWidth - self.titleLabel.frame.size.width - self.titleLabel.frame.origin.x - GTW(30) * 2, label_height)];
    self.titleNameLabel.textColor = ZTTextGrayColor;
    self.titleNameLabel.font = FONT(30);
    if (self.articleModel.title.length != 0) {
        self.titleNameLabel.text = self.articleModel.title;
    }
    self.titleNameLabel.numberOfLines = 0;
    [self.tableHeaderView addSubview:self.titleNameLabel];
    
    self.titleLineView = [[UIView alloc] initWithFrame:CGRectMake(GTW(30), self.titleNameLabel.frame.size.height + self.titleNameLabel.frame.origin.y, ScreenWidth - GTW(30) * 2, 1)];
    self.titleLineView.backgroundColor = ZTLineGrayColor;
    [self.tableHeaderView addSubview:self.titleLineView];
    
    self.schoolLabel = [[UILabel alloc] initWithFrame:CGRectMake(GTW(30), self.titleLineView.frame.size.height + self.titleLineView.frame.origin.y, ScreenWidth - GTW(30) * 2, GTH(80))];
    self.schoolLabel.textColor = ZTTextLightGrayColor;
    self.schoolLabel.font = FONT(26);
    [self.tableHeaderView addSubview:self.schoolLabel];
    
    self.schoolLineView = [[UIView alloc] initWithFrame:CGRectMake(self.schoolLabel.frame.origin.x, self.schoolLabel.frame.size.height + self.schoolLabel.frame.origin.y, self.schoolLabel.frame.size.width, 1)];
    self.schoolLineView.backgroundColor = ZTLineGrayColor;
    [self.tableHeaderView addSubview:self.schoolLineView];
    
    self.contentLabel = [[UILabel alloc] init];
    [self.tableHeaderView addSubview:self.contentLabel];

    if (self.articleModel.readNumber.length == 0) {
        self.readLabel.text = @"阅读 0";
    } else {
        self.readLabel.text = [NSString stringWithFormat:@"阅读 %@", self.articleModel.readNumber];
    }
    if (self.articleModel.bigTypeName.length != 0) {
        if (self.articleModel.typeName.length == 0) {
            self.typeNameLabel.text = self.articleModel.bigTypeName;
        } else {
            self.typeNameLabel.text = [NSString stringWithFormat:@"%@-%@", self.articleModel.bigTypeName, self.articleModel.typeName];
        }
    }
    if (self.articleModel.schoolName.length == 0) {
        self.schoolLabel.text  = self.articleModel.nickname;
    } else if (self.articleModel.nickname.length == 0) {
        self.schoolLabel.text  = self.articleModel.schoolName;
    } else if (self.articleModel.nickname.length != 0 && self.articleModel.schoolName.length != 0) {
        self.schoolLabel.text = [NSString stringWithFormat:@"%@ | %@", self.articleModel.nickname, self.articleModel.schoolName];
    }
    if (self.articleModel.content.length != 0) {
        if ([NSString isHtmlString:self.articleModel.content]) {
            self.contentLabel.attributedText = [self htmlStringToChangeWithString:self.articleModel.content];
        } else {
            self.contentLabel.text = self.articleModel.content;
        }
        //记录第一个字的文字下标
//        self.firstStrindex = [self getindexArrayOfStringInLabel:self.contentLabel Point:CGPointMake(0, GTH(30))] + 1;
    }
    //计算高度的时候, 用转成字符串后的text去计算, 而不是用html字符串去计算
    CGSize size = [self getSizeWithString:self.contentLabel.text font:FONT(28) str_width:ScreenWidth - GTW(30) * 2];
    self.contentLabel.frame = CGRectMake(GTW(30), _schoolLineView.frame.size.height + self.schoolLineView.frame.origin.y + GTH(30), ScreenWidth - GTW(30) * 2, size.height);

    //设置批注颜色
    if (self.articleAnnotationArray.count != 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.contentLabel.text];

        //遍历添加
        for (int i = 0; i < self.articleAnnotationArray.count; i++) {
            ArticleAnnotationModel *model = self.articleAnnotationArray[i];
            NSInteger loc = [model.startTxt integerValue];
            NSInteger len = [model.endTxt integerValue] - [model.startTxt integerValue];

            NSRange range;
            if (self.contentLabel.text.length < (loc + len)) {
                range = [self.contentLabel.text rangeOfString:model.sourceTxt];
                loc = range.location;
                len = range.length;
            }

            [str addAttribute:NSBackgroundColorAttributeName value:ZTLightOrangeColor range:NSMakeRange(loc, len)];
            [str addAttribute:NSFontAttributeName value:self.contentLabel.font range:NSMakeRange(loc, len)];

        }
        self.contentLabel.attributedText = str;
    }
    //最后再适应字体大小
    self.contentLabel.font = FONT(28);
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.backgroundColor = [UIColor whiteColor];
    [self.contentLabel sizeToFit];
    self.contentLabel.adjustsFontSizeToFitWidth = YES;

    //在tableView上添加轻拍
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(self.contentLabel.frame.origin.x, self.contentLabel.frame.origin.y, self.contentLabel.frame.size.width, self.contentLabel.frame.size.height)];
    [control addTarget:self action:@selector(controlAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tableHeaderView addSubview:control];
    
    self.tableHeaderView.frame = CGRectMake(0, 0, ScreenWidth, self.contentLabel.frame.origin.y + size.height + GTH(30));
    self.tableView.tableHeaderView = self.tableHeaderView;
}

#pragma mark - 点击label方法
- (void)controlAction
{
    [self showAnnotationListViewWithArray:self.articleAnnotationArray];

}

#pragma mark - 显示批注的view
- (void)showAnnotationListViewWithArray:(NSMutableArray *)array
{
    if (array.count == 0) {
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.annotationListView = [[AnnotationListView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.annotationListView.delegate = self;
    //传值数组
    self.annotationListView.dataSourceArray = array;
    [window addSubview:self.annotationListView];
        
}

#pragma mark - AnnotationListViewDelegate
- (void)cancelButtonAction
{
    [self.annotationListView removeFromSuperview];
}

#pragma mark - TableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        //总评
        return self.articleConclusionArray.count;
    }
    //回复
    if (self.articleConclusionArray.count == 0 && self.articleCommentArray.count == 0) {
        return 1;
    }
    return self.articleCommentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //总评
    if (indexPath.section == 0) {
        static NSString *defaultCellID = @"teacherTableViewCell";
        ZiyouTeacherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
        if (!cell) {
            cell = [[ZiyouTeacherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
       
        if (self.articleConclusionArray.count == 0) {
            return cell;
        }
        ArticleConclusionModel *model = self.articleConclusionArray[indexPath.row];
        
        [cell setZiyouTeacherCellWithTeachNickName:model.nickname
                                    TeachFirstName:model.firstname
                                            Basice:model.basicLevel
                                       Development:model.developmentLevel
                                   ArticleFraction:model.articleFraction];
        
        return cell;
        
    } else {
        //回复
        static NSString *defaultCellID = @"ziyouDetailTableViewCell";
        ZiyouReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
        if (!cell) {
            cell = [[ZiyouReplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
        
        if (self.articleCommentArray.count == 0) {
            [cell setZiyouReplyCellWithHeadImage:@""
                                            Name:@""
                                            Date:@""
                                         Content:@""
                                     ButtonTitle:@""
                                             Tip:@""
                                       IsShowTip:NO];
            return cell;
        }
        
        ArticleCommentModel *model = self.articleCommentArray[indexPath.row];
        ArticleCommentDetailModel *detailModel = [[ArticleCommentDetailModel alloc] init];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model.comment];
        if (dic.count != 0) {
            [detailModel setValuesForKeysWithDictionary:dic];
        }
        NSString *buttonTitle = [NSString string];
        if ([model.replyMemberId isEqualToString:[GetUserInfo getUserInfoModel].userId]) {
            buttonTitle = @"删除";
        } else {
            buttonTitle = @"回复";
        }
    
        if (dic.count == 0) {
            //正常显示
            [cell setZiyouReplyCellWithHeadImage:model.avatar
                                            Name:model.nickname
                                            Date:model.sendDate
                                         Content:model.content
                                     ButtonTitle:buttonTitle
                                             Tip:@""
                                       IsShowTip:NO];
        } else {
            //有回复的显示
            [cell setZiyouReplyCellWithHeadImage:model.avatar
                                            Name:model.nickname
                                            Date:model.sendDate
                                         Content:[NSString stringWithFormat:@"回复 %@ : %@", detailModel.nickname, model.content]
                                     ButtonTitle:buttonTitle
                                             Tip:[NSString stringWithFormat:@"%@的评阅", detailModel.nickname]
                                       IsShowTip:YES];
        }

        return cell;
        
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //总评 && 评论都有数据的时候
    if (self.articleCommentArray.count != 0 &&
        self.articleConclusionArray.count != 0) {
        if (indexPath.section == 1) {
            //评论
            return [self getCommentHeightWithRow:indexPath.row];
        }
        //总评
        return [self getConclusionHeightWithRow:indexPath.row];
        
    } else if (self.articleCommentArray.count != 0 && self.articleConclusionArray.count == 0) {
        //只有评论的数据的时候
      return [self getCommentHeightWithRow:indexPath.row];
   
    } else if (self.articleConclusionArray.count != 0 && self.articleCommentArray.count == 0) {
        //只有总评的时候
       return [self getConclusionHeightWithRow:indexPath.row];
  
    }
    return GTH(700);
}

#pragma mark - 获取总评部分行高
- (CGFloat)getConclusionHeightWithRow:(NSInteger)row
{
    ArticleConclusionModel *model = self.articleConclusionArray[row];
    NSString *string = [NSString stringWithFormat:@"%@(%@老师)的总评", model.nickname, model.firstname];
    CGFloat label_width = ScreenWidth - GTW(30) * 4;
    //老师
    CGSize teacherWidthSize = [self getSizeWithString:string font:FONT(26) str_height:GTH(44)];
    //基础等级
    CGSize basicSize = [self getSizeWithString:model.basicLevel font:FONT(24) str_width:label_width];
    //发展等级
    CGSize developSize = [self getSizeWithString:model.developmentLevel font:FONT(24) str_width:label_width];
    
    //如果评分为负数-不显示评分
    if ([model.articleFraction integerValue] < 0) {
        //如果老师总评显示大于一行
        if (teacherWidthSize.width >= ScreenWidth - GTW(30) * 2) {
            return GTH(700) + teacherWidthSize.height + basicSize.height + developSize.height - GTH(140);
        }
        return GTH(700) + GTH(44) + basicSize.height + developSize.height - GTH(140);
    }
    if (teacherWidthSize.width >= ScreenWidth - GTW(30) * 2) {
        return GTH(700) + teacherWidthSize.height + basicSize.height + developSize.height;
    }
    return GTH(700) + teacherWidthSize.height + basicSize.height + developSize.height - GTH(44);

}

#pragma mark - 获取评论部分行高
- (CGFloat)getCommentHeightWithRow:(NSInteger)row
{
    CGFloat width = ScreenWidth - GTW(30) * 2 - GTW(20) - GTW(50);
    CGSize contentSize, tipSize;
    
    if (self.articleCommentArray.count == 0) {
        return GTH(700);
    }
    ArticleCommentModel *model = self.articleCommentArray[row];
    ArticleCommentDetailModel *detailModel = [[ArticleCommentDetailModel alloc] init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model.comment];
    if (dic.count != 0) {
        [detailModel setValuesForKeysWithDictionary:dic];
    }
    if (dic.count != 0) {
        //如果有回复
        contentSize = [self getSizeWithString:[NSString stringWithFormat:@"回复 %@ : %@", detailModel.nickname, model.content] font:FONT(26) str_width:width];
        tipSize = [self getSizeWithString:[NSString stringWithFormat:@"%@的评阅", detailModel.nickname] font:FONT(22) str_width:width - GTW(50) * 2];
        return GTH(220) + contentSize.height + tipSize.height + 1;
        
    } else {
        //没有回复
        contentSize = [self getSizeWithString:model.content font:FONT(26) str_width:width];
        return GTH(180) + contentSize.height + 1;
    }
}

#pragma mark - ZiyouReplyTableViewCellDelegate
- (void)replyButtonWithCell:(ZiyouReplyTableViewCell *)cell
{
    self.selectedIndexPath = [self.tableView indexPathForCell:cell];
    ArticleCommentModel *model = self.articleCommentArray[self.selectedIndexPath.row];
    
    if ([model.replyMemberId isEqualToString:[GetUserInfo getUserInfoModel].userId]) {
        //删除
        [self showDeleteAlertWithModel:model];
        
    } else {
        //回复
        self.isReplyTextField = YES;
        [self.textField setText:@""];
        [self.textField becomeFirstResponder];
    }
    
}

#pragma mark - 是否删除评论
- (void)showDeleteAlertWithModel:(ArticleCommentModel *)model
{
    NSString *titleStr = @"提示";
    NSString *messageStr = @"是否删除评论";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    //这是按钮的背景颜色
    [cancelAction setValue:ZTTitleColor forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用删除接口
        [self remove_CommentWithModel:model];

    }];
    [sureAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - UITextField的协议方法
//点击return键,取消键盘第一响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
}


#pragma mark - 修改消息状态
- (void)modifyReadStatus
{
    if (self.messageId.length == 0) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:@"1" forKey:@"type"];
    //消息ID集合，英文逗号分隔
    [params setValue:self.messageId forKey:@"idList"];

    NSString *url = [NSString stringWithFormat:@"%@api/message/modifyReadStatus", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}



@end
