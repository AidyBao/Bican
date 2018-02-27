//
//  CommendArticleDetailViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "CommendArticleDetailViewController.h"
#import "ZTBottomSelecteView.h"
#import "ArticleConclusionModel.h"//总评
#import "ArticleAnnotationModel.h"//批注
#import "MingtiListModel.h"
#import "MingtiHeaderView.h"
#import "ArticleModel.h"

#import "AddCommentViewController.h"
#import "CheckAndEditCommentViewController.h"
#import "CommentConclusionViewController.h"

@interface CommendArticleDetailViewController () <UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, ZTBottomSelecteViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, assign) CGFloat tableViewOffSetY;

@property (nonatomic, strong) UILabel *typeLabel;//主题
@property (nonatomic, strong) UILabel *typeNameLabel;
@property (nonatomic, strong) UIButton *showMingtiButton;//展开命题 || 收起命题
@property (nonatomic, strong) UIView *typeLineView;

@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UIView *fromLineView;
@property (nonatomic, strong) UILabel *mingtiNameLabel;
@property (nonatomic, strong) UIView *backWhiteView;

@property (nonatomic, strong) UILabel *titleLabel;//题目
@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UIView *titleLineView;

@property (nonatomic, strong) UILabel *studentNameLabel;
@property (nonatomic, strong) UIView *studentNameLineView;
@property (nonatomic, strong) UILabel *schoolLabel;
@property (nonatomic, strong) UIView *schoolLineView;
@property (nonatomic, strong) BaseTextView *contentTextView;
@property (nonatomic, strong) UIMenuController *menu;

@property (nonatomic, strong) UITextView *basicTextView;//基础等级
@property (nonatomic, strong) UILabel *basicLabel;
@property (nonatomic, strong) UIView *basicLineView;
@property (nonatomic, strong) UILabel *basicPlaceholderLabel;

@property (nonatomic, strong) UITextView *developTextView;//发展等级
@property (nonatomic, strong) UILabel *developLabel;//发展等级
@property (nonatomic, strong) UIView *developLineView;
@property (nonatomic, strong) UILabel *developPlaceholderLabel;

@property (nonatomic, strong) UITextField *fractionTextField;//打分
@property (nonatomic, strong) UILabel *fractionLabel;
@property (nonatomic, strong) UIView *fractionLineView;

@property (nonatomic, strong) UIButton *checkButton;//查看批注按钮
@property (nonatomic, strong) UIButton *conclusionButton;//总评按钮
@property (nonatomic, strong) ZTBottomSelecteView *bottomSelecteView;
@property (nonatomic, strong) NSMutableArray *articleAnnotationArray;//批注数组
@property (nonatomic, strong) NSMutableArray *articleConclusionArray;//总评数组
@property (nonatomic, strong) ArticleModel *articleModel;
@property (nonatomic, strong) ArticleConclusionModel *articleConclusionModel;

@property (nonatomic, strong) MingtiListModel *mingtiListModel;
@property (nonatomic, strong) MingtiHeaderView *mingtiHeaderView;//命题的headerView
@property (nonatomic, assign) CGFloat scrollBigOffset;//最大
@property (nonatomic, assign) CGFloat scrollSmallOffset;//最小
@property (nonatomic, assign) BOOL isSHow;//是否显示完成命题

@end

@implementation CommendArticleDetailViewController

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
    
    if ([self.inviteModel.bigTypeId isEqualToString:@"2"]) {
        [self getCompleteProposition];
        
    } else {
        //重新请求批注数组
        [self get_Article_Detail];
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightNavigationItem:nil Title:@"提交评阅" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:GTH(10)];
    [self createLeftNavigationItem:[UIImage imageNamed:@"return"] Title:@""];
    if ([self.inviteModel.bigTypeId isEqualToString:@"2"]) {
        self.isSHow = YES;
    } else {
        self.isSHow = NO;
    }
    [self createCheckButton];
    [self createBottomSelectedView];
    [self createMenuController];
    
}

#pragma mark - 返回到上一级
- (void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    [self resignAllFirstResponder];
    //直接返回
    if (self.basicTextView.text.length == 0 && self.developTextView.text.length == 0 && self.fractionTextField.text.length == 0) {
        [self popVCAnimated:YES];
        return;
    }
    //弹出提示, 是否保存草稿
    self.bottomSelecteView.hidden = NO;

}

#pragma mark - 根据文章id查询文章详情


#pragma mark - 提交评阅按钮
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    [self resignAllFirstResponder];

    if (self.basicTextView.text.length == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请填写基础等级" Time:3.0];
        return;
    }
    if (self.developTextView.text.length == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请填写发展等级" Time:3.0];
        return;
    }
    if (self.fractionTextField.text.length == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请添加评分" Time:3.0];
        return;
    }
    if ([self.fractionTextField.text integerValue] < 0 || [self.fractionTextField.text integerValue] > 60) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"评分在0~60之间" Time:3.0];
        return;
    }
    [self showAlert];
    
}

#pragma mark - 提示
- (void)showAlert
{
    NSString *titleStr = @"提示";
    NSString *messageStr = @"评阅提交后不能撤回哦, 您确定完成吗 ?";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:titleStr message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [cancelAction setValue:ZTTitleColor forKey:@"titleTextColor"];
    [alertVC addAction:cancelAction];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //调用接口
        //先保存总评, 再完成提交
        if (self.articleConclusionModel.developmentLevel.length == 0) {
            [self conclusionSaveWithStatus:@"1"];
        } else {
            //如果之前总评有内容, 就调用修改
            [self conclusionModifyWithStatus:@"1"];
        }

    }];
    [sureAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

#pragma mark - 创建MenuController
- (void)createMenuController
{
    self.menu = [UIMenuController sharedMenuController];
    //防止点击多次创建
    if (self.menu.isMenuVisible) {
        [self.menu setMenuVisible:NO animated:YES];
        
    } else {
        UIMenuItem *addItem = [[UIMenuItem alloc] initWithTitle:@"添加批注" action:@selector(addComment:)];
        self.menu.menuItems = @[addItem];
        [self.menu setMenuVisible:YES animated:YES];
    }
}


#pragma mark - 添加批注
- (void)addComment:(UIMenuController *)menu
{
    [self resignAllFirstResponder];
    
    //获取选中的内容
    NSString *string = [self.contentTextView.text substringWithRange:self.contentTextView.selectedRange];

    NSInteger loc = 0;
    NSInteger len = 0;
    NSRange range;
    if (string.length != 0) {
        range = [self.contentTextView.text rangeOfString:string];
        loc = range.location;
        len = range.length;
    }
    //跳转到添加批注页面
    AddCommentViewController *addCommentVC = [[AddCommentViewController alloc] init];
    addCommentVC.cotentStr = string;
    addCommentVC.articleIdStr = self.inviteModel.articleId;
    addCommentVC.startIndex = [NSString stringWithFormat:@"%ld", loc];
    addCommentVC.endIndex = [NSString stringWithFormat:@"%ld", loc + len];
    [self pushVC:addCommentVC animated:YES IsNeedLogin:YES];
    
}

#pragma mark - 获取完整命题数据
- (void)getCompleteProposition
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.inviteModel.typeId forKey:@"typeId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/proposition/get", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSDictionary *dataDic = [resultObject objectForKey:@"data"];
        self.mingtiListModel = [[MingtiListModel alloc] init];
        [self.mingtiListModel setValuesForKeysWithDictionary:dataDic];
        //获取内容高度
        [self get_Article_Detail];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];
        
    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 获取作文详情(总评 && 批注)
- (void)get_Article_Detail
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    [params setValue:self.inviteModel.articleId forKey:@"articleId"];
    //是否查看批注和总评: 0-查看批注和总评(添加批注数组), 1-评阅批注和总评(没有批注数组)
    [params setValue:@"1" forKey:@"isComment"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/article/get", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
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
        //总评的model
        NSMutableArray *conclusionArray = [dic objectForKey:@"articleConclusionList"];
        if (conclusionArray.count > 0) {
            for (NSMutableDictionary *conclusionDic in conclusionArray) {
                ArticleConclusionModel *model = [[ArticleConclusionModel alloc] init];
                [model setValuesForKeysWithDictionary:conclusionDic];
                [self.articleConclusionArray addObject:model];
            }
            self.articleConclusionModel = [[ArticleConclusionModel alloc] init];
            [self.articleConclusionModel setValuesForKeysWithDictionary:(NSMutableDictionary *)conclusionArray[0]];
        }
        //批注数组
        NSMutableArray *annotationArray = [dic objectForKey:@"articleAnnotationList"];
        if (annotationArray.count > 0) {
            for (NSMutableDictionary *annotationDic in annotationArray) {
                ArticleAnnotationModel *model = [[ArticleAnnotationModel alloc] init];
                [model setValuesForKeysWithDictionary:annotationDic];
                [self.articleAnnotationArray addObject:model];
            }
        }
        [self createScrollView];

    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
}

#pragma mark - 更新总评内容
- (void)updateConclusion
{
    self.basicTextView.text = self.articleConclusionModel.basicLevel;
    self.developTextView.text = self.articleConclusionModel.developmentLevel;
    self.fractionTextField.text = self.articleConclusionModel.articleFraction;
    
    if (self.basicTextView.text.length == 0) {
        self.basicPlaceholderLabel.hidden = NO;
    } else {
        self.basicPlaceholderLabel.hidden = YES;
    }
    
    if (self.developTextView.text.length == 0) {
        self.developPlaceholderLabel.hidden = NO;
    } else {
        self.developPlaceholderLabel.hidden = YES;
    }

    
}

#pragma mark - 为内容的TextView添加批注
- (void)getMarkForContentTextView
{
    //设置批注颜色
    if (self.articleAnnotationArray.count != 0) {
        if (self.articleModel.content.length == 0) {
            return;
        }
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.contentTextView.text];
        
        //遍历添加
        for (int i = 0; i < self.articleAnnotationArray.count; i++) {
            ArticleAnnotationModel *model = self.articleAnnotationArray[i];
            NSInteger loc = [model.startTxt integerValue];
            NSInteger len = [model.endTxt integerValue] - [model.startTxt integerValue];
            
            NSRange range;
            if (self.contentTextView.text.length < (loc + len)) {
                range = [self.contentTextView.text rangeOfString:model.sourceTxt];
                loc = range.location;
                len = range.length;
            }
            
            [str addAttribute:NSBackgroundColorAttributeName value:ZTLightOrangeColor range:NSMakeRange(loc, len)];
            [str addAttribute:NSFontAttributeName value:FONT(28) range:NSMakeRange(loc, len)];
            
        }
        self.contentTextView.attributedText = str;
        self.contentTextView.textColor =ZTTextGrayColor;
        self.contentTextView.font = FONT(28);
    }

}

#pragma mark - 保存总评(草稿)
- (void)conclusionSaveWithStatus:(NSString *)status
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //基础等级
    [params setValue:self.basicTextView.text forKey:@"basicLevel"];
    //发展等级
    [params setValue:self.developTextView.text forKey:@"developLevel"];
    //打分
    [params setValue:self.fractionTextField.text forKey:@"fraction"];
    [params setValue:self.inviteModel.articleId forKey:@"articleId"];
    //总评状态: 1-发布, 0-草稿
    [params setValue:status forKey:@"status"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/conclusion/save", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        if ([status isEqualToString:@"0"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"保存草稿成功" Time:3.0];
            [self popVCAnimated:YES];
        } else {
            //完成提交评阅
            [self inviteComplete];
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

#pragma mark -  修改总评(草稿)
- (void)conclusionModifyWithStatus:(NSString *)status
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //总评id
    [params setValue:self.articleConclusionModel.articleConclusion_id forKey:@"conclusionId"];
    //基础等级
    [params setValue:self.basicTextView.text forKey:@"basicLevel"];
    //发展等级
    [params setValue:self.developTextView.text forKey:@"developLevel"];
    //打分
    [params setValue:self.fractionTextField.text forKey:@"fraction"];
    [params setValue:self.inviteModel.articleId forKey:@"articleId"];
    //总评状态: 1-发布, 0-草稿
    [params setValue:status forKey:@"status"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/conclusion/modify", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        if ([status isEqualToString:@"0"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"保存草稿成功" Time:3.0];
            [self popVCAnimated:YES];
        } else {
            //完成提交评阅
            [self inviteComplete];
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

#pragma mark - 完成评阅(最后的提交, 获得礼物)
- (void)inviteComplete
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //基础等级
    [params setValue:self.basicTextView.text forKey:@"basicLevel"];
    //发展等级
    [params setValue:self.developTextView.text forKey:@"developLevel"];
    //打分
    [params setValue:self.fractionTextField.text forKey:@"fraction"];
    [params setValue:self.inviteModel.articleId forKey:@"articleId"];
    //总评状态: 1-发布, 0-草稿
    [params setValue:@"1" forKey:@"status"];
    //评阅邀请ID
    [params setValue:self.inviteModel.invite_id forKey:@"inviteId"];

    NSString *url = [NSString stringWithFormat:@"%@api/invite/complete", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [self popVCAnimated:YES];
        //显示礼物
        if ([self.delegate respondsToSelector:@selector(saveCommendSuccess)]) {
            [self.delegate saveCommendSuccess];
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

#pragma mark - 创建bottomSelectedView
- (void)createBottomSelectedView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.bottomSelecteView = [[ZTBottomSelecteView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.bottomSelecteView.delegate = self;
    self.bottomSelecteView.hidden = YES;
    
    [self.bottomSelecteView setZTBottomSelecteViewWithArray:@[@"确定", @"是否保存草稿"] CancelButtonTitle:@"取消" TextColor:ZTTextGrayColor TextFont:FONT(30) IsShowOrangeColor:NO OrangeColorIndex:0];

    [window addSubview:self.bottomSelecteView];
    
}

#pragma makr - ZTBottomSelecteViewDelegate
- (void)selecetedIndex:(NSInteger)selecetedIndex
{
    if (selecetedIndex == 0) {
        //确定保存
        self.bottomSelecteView.hidden = YES;
        //如果内容为空
        if (self.articleConclusionModel.developmentLevel.length == 0) {
            //保存草稿
            [self conclusionSaveWithStatus:@"0"];
        } else {
            //修改草稿
            [self conclusionModifyWithStatus:@"0"];
        }
        return;
    }
    self.bottomSelecteView.hidden = NO;

}

- (void)cancelButtonClick
{
    //不保存, 离开
    [self popVCAnimated:YES];
}

#pragma mark - 创建底部查看批注按钮
- (void)createCheckButton
{
    if (self.isFromInvite) {
        //从邀请评阅进入
        self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkButton.frame = CGRectMake(0, ScreenHeight - GTH(88), ScreenWidth, GTH(88));
        [self.checkButton setTitle:@"查看批注" forState:UIControlStateNormal];
        [self.checkButton setTitleColor:ZTTextGrayColor forState:UIControlStateNormal];
        self.checkButton.titleLabel.font = FONT(28);
        [self.checkButton setBackgroundColor:ZTNavColor];
        [self.checkButton addTarget:self action:@selector(checkButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.checkButton];
        
    } else {
        //从班级文集进入
        self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkButton.frame = CGRectMake(0, ScreenHeight - GTH(88), ScreenWidth / 2, GTH(88));
        [self.checkButton setTitle:@"查看批注" forState:UIControlStateNormal];
        [self.checkButton setTitleColor:ZTTextGrayColor forState:UIControlStateNormal];
        self.checkButton.titleLabel.font = FONT(28);
        [self.checkButton setBackgroundColor:ZTNavColor];
        [self.checkButton addTarget:self action:@selector(checkButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.checkButton];
        
        self.conclusionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.conclusionButton.frame = CGRectMake(ScreenWidth / 2, ScreenHeight - GTH(88), ScreenWidth / 2, GTH(88));
        [self.conclusionButton setTitle:@"总评" forState:UIControlStateNormal];
        [self.conclusionButton setTitleColor:ZTTextGrayColor forState:UIControlStateNormal];
        self.conclusionButton.titleLabel.font = FONT(28);
        [self.conclusionButton setBackgroundColor:ZTNavColor];
        [self.conclusionButton addTarget:self action:@selector(conclusionButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.conclusionButton];
    }
}

#pragma mark - 创建ScrollView
- (void)createScrollView
{
    for (UIView *view in self.bigScrollView.subviews) {
        [view removeFromSuperview];
    }
    [self.bigScrollView removeFromSuperview];
    
    self.bigScrollView = [[UIScrollView alloc] init];
    self.bigScrollView.backgroundColor = [UIColor whiteColor];
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        self.bigScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.bigScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.bigScrollView.scrollIndicatorInsets = self.bigScrollView.contentInset;
    }
    [self.bigScrollView setContentInset:UIEdgeInsetsZero];
    [self.view addSubview:self.bigScrollView];
    
    [self.bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight - NAV_HEIGHT - GTH(88)));
    }];
    
    //label的高度
    CGFloat label_height = GTH(88);
    CGFloat label_width = ScreenWidth - GTW(30) * 2;
    //完整命题文字的宽度
    CGFloat mingti_width = ScreenWidth - GTW(30) * 4;
    //一张图片的高度
    CGFloat picAllHeight = GTH(210);
    //命题内容的高度
    CGSize contentSize = [self getSizeWithString:self.mingtiListModel.content font:FONT(24) str_width:mingti_width];
    //获取图片的数组
    NSArray *array = [self.mingtiListModel.picture componentsSeparatedByString:@","];
    
    //栏目
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.backgroundColor = ZTOrangeColor;
    self.typeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    self.typeLabel.font = FONT(30);
    [self.bigScrollView addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(67), GTH(44)));
        make.left.equalTo(self.bigScrollView).offset(GTW(30));
        make.top.equalTo(self.bigScrollView).offset((label_height - GTH(44)) / 2);
    }];

    self.showMingtiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.showMingtiButton setTitle:@"[展开命题]" forState:UIControlStateNormal];
    [self.showMingtiButton setTitle:@"[收起命题]" forState:UIControlStateSelected];
    self.showMingtiButton.selected = self.isSHow;
    self.showMingtiButton.titleLabel.font = FONT(24);
    [self.showMingtiButton setTitleColor:ZTOrangeColor forState:UIControlStateNormal];
    [self.showMingtiButton setTitleColor:ZTOrangeColor forState:UIControlStateSelected];
    self.showMingtiButton.adjustsImageWhenHighlighted = NO;
    [self.showMingtiButton addTarget:self action:@selector(showMingtiButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bigScrollView addSubview:self.showMingtiButton];
    
    [self.showMingtiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(160), label_height));
        make.left.equalTo(self.bigScrollView.mas_left).offset(ScreenWidth - GTW(160) - GTW(30));
        make.top.equalTo(self.bigScrollView);
    }];
    
    self.typeNameLabel = [[UILabel alloc] init];
    self.typeNameLabel.textColor = ZTTextGrayColor;
    self.typeNameLabel.font = FONT(30);
    self.typeNameLabel.numberOfLines = 0;
    [self.bigScrollView addSubview:self.typeNameLabel];
    
    if ([self.inviteModel.bigTypeId isEqualToString:@"2"]) {
        self.showMingtiButton.hidden = NO;
        [self.typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeLabel.mas_right).offset(GTW(30));
            make.height.mas_equalTo(label_height);
            make.top.equalTo(self.bigScrollView);
            make.right.equalTo(self.showMingtiButton.mas_left).offset(GTW(-30));
        }];
    } else {
        self.showMingtiButton.hidden = YES;
        [self.typeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.typeLabel.mas_right).offset(GTW(30));
            make.height.mas_equalTo(label_height);
            make.top.equalTo(self.bigScrollView);
            make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        }];
    }
    
    self.typeLineView = [[UIView alloc] init];
    self.typeLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.typeLineView];
    
    [self.typeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.typeLabel);
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        make.top.equalTo(self.typeNameLabel.mas_bottom);
    }];
    
    //命题作文才显示
    self.fromLabel = [[UILabel alloc] init];
    self.fromLabel.text = [NSString stringWithFormat:@"@%@提供", self.mingtiListModel.provider];
    self.fromLabel.font = FONT(28);
    self.fromLabel.textColor = ZTTextGrayColor;
    [self.bigScrollView addSubview:self.fromLabel];
    
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(label_width, label_height));
        make.left.equalTo(self.typeLabel);
        make.top.equalTo(self.typeLineView.mas_bottom);
    }];
    
    self.fromLineView = [[UIView alloc] init];
    self.fromLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.fromLineView];
    
    [self.fromLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fromLabel.mas_bottom);
        make.left.right.height.equalTo(self.typeLineView);
    }];
    
    self.mingtiNameLabel = [[UILabel alloc] init];
    self.mingtiNameLabel.text = self.inviteModel.typeName;
    self.mingtiNameLabel.font = FONT(28);
    self.mingtiNameLabel.textColor = ZTTextGrayColor;
    [self.bigScrollView addSubview:self.mingtiNameLabel];
    
    [self.mingtiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.fromLineView);
        make.height.mas_equalTo(label_height);
        make.top.equalTo(self.fromLineView);
    }];
    
    //完整命题view
    self.mingtiHeaderView = [[MingtiHeaderView alloc] init];
    [self.mingtiHeaderView setMingtiHeaderViewWithContent:self.mingtiListModel.content ImageArray:(NSMutableArray *)array];
    [self.bigScrollView addSubview:self.mingtiHeaderView];
    
    [self.mingtiHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(label_width, GTH(30) * 5 + picAllHeight * array.count + contentSize.height));
        make.left.equalTo(self.typeLabel);
        make.top.equalTo(self.mingtiNameLabel.mas_bottom).offset(GTH(30));
    }];

    //题目
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"题目";
    self.titleLabel.font = FONT(30);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = ZTOrangeColor;
    self.titleLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.bigScrollView addSubview:self.titleLabel];
    
    if (self.isSHow) {
        self.mingtiHeaderView.hidden = NO;
        self.mingtiNameLabel.hidden = NO;
        self.fromLabel.hidden = NO;
        self.fromLineView.hidden = NO;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(GTW(67), GTH(44)));
            make.top.equalTo(self.mingtiHeaderView.mas_bottom).offset((label_height - GTH(44)) / 2);
            make.left.equalTo(self.bigScrollView).offset(GTW(30));
        }];
        
    } else {
        self.mingtiHeaderView.hidden = YES;
        self.mingtiNameLabel.hidden = YES;
        self.fromLabel.hidden = YES;
        self.fromLineView.hidden = YES;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.typeLineView.mas_bottom).offset((label_height - GTH(44)) / 2);
            make.size.mas_equalTo(CGSizeMake(GTW(67), GTH(44)));
            make.left.equalTo(self.bigScrollView).offset(GTW(30));
            
        }];
    }

    self.titleNameLabel = [[UILabel alloc] init];
    self.titleNameLabel.textColor = ZTTextGrayColor;
    self.titleNameLabel.font = FONT(30);
    if (self.inviteModel.title.length != 0) {
        self.titleNameLabel.text = self.inviteModel.title;
    }
    self.titleNameLabel.numberOfLines = 0;
    [self.bigScrollView addSubview:self.titleNameLabel];
    
    [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(label_height);
        make.left.equalTo(self.titleLabel.mas_right).offset(GTW(30));
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 3 - GTW(67));
        make.centerY.equalTo(self.titleLabel);
    }];

 
    self.titleLineView = [[UIView alloc] init];
    self.titleLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.titleLineView];
    
    [self.titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.typeLineView);
        make.top.equalTo(self.titleNameLabel.mas_bottom);

    }];
 
    //计算学生名字的宽度
    CGSize studentNameSize = [self getSizeWithString:self.inviteModel.nickname font:FONT(28) str_height:label_height];
    
    self.studentNameLabel = [[UILabel alloc] init];
    self.studentNameLabel.font = FONT(28);
    self.studentNameLabel.textColor = ZTTextGrayColor;
    self.studentNameLabel.text = self.inviteModel.nickname;
    [self.bigScrollView addSubview:self.studentNameLabel];
    
    [self.studentNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(studentNameSize.width, label_height));
        make.left.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLineView.mas_bottom);
    }];
    
    self.studentNameLineView = [[UIView alloc] init];
    self.studentNameLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.studentNameLineView];

    [self.studentNameLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(label_height - GTH(20));
        make.width.mas_equalTo(1);
        make.left.equalTo(self.studentNameLabel.mas_right).offset(GTW(30));
        make.top.equalTo(self.studentNameLabel).offset(GTH(10));
    }];
    
    self.schoolLabel = [[UILabel alloc] init];
    self.schoolLabel.font = FONT(28);
    self.schoolLabel.textColor = ZTTextGrayColor;
    self.schoolLabel.text = self.inviteModel.schoolName;
    [self.bigScrollView addSubview:self.schoolLabel];
    
    [self.schoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(label_height);
        make.left.equalTo(self.studentNameLineView.mas_right).offset(1 + GTW(30));
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 3 - 1);
        make.top.equalTo(self.studentNameLabel);
    }];
    
    self.schoolLineView = [[UIView alloc] init];
    self.schoolLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.schoolLineView];
    
    [self.schoolLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.equalTo(self.titleLineView);
        make.top.equalTo(self.schoolLabel.mas_bottom);
        make.width.equalTo(self.titleLineView);
    }];
    
   
    self.contentTextView = [[BaseTextView alloc] init];
    if (self.articleModel.content.length != 0) {
        if ([NSString isHtmlString:self.articleModel.content]) {
            self.contentTextView.attributedText = [self htmlStringToChangeWithString:self.articleModel.content];
        } else {
            self.contentTextView.text = self.articleModel.content;
        }
    }
    //计算
    CGSize size = [self getSizeWithString:self.contentTextView.text font:FONT(28) str_width:ScreenWidth - GTW(30) * 2];
    self.contentTextView.textColor = ZTTextGrayColor;
    self.contentTextView.editable = NO;
    [self.contentTextView resignFirstResponder];
    self.contentTextView.font = FONT(28);
    self.contentTextView.showsVerticalScrollIndicator = NO;
    self.contentTextView.showsHorizontalScrollIndicator = NO;
    self.contentTextView.tintColor = ZTOrangeColor;
    self.contentTextView.delegate = self;
    self.contentTextView.scrollEnabled = NO;
    self.contentTextView.backgroundColor = [UIColor whiteColor];
    self.contentTextView.adjustsFontForContentSizeCategory = YES;
    [self.bigScrollView addSubview:self.contentTextView];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
        make.left.equalTo(self.bigScrollView.mas_left).offset(GTW(30));
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        make.top.equalTo(self.schoolLineView.mas_bottom).offset(GTH(30));
    }];
    
    //基础等级
    self.basicLabel = [[UILabel alloc] init];
    self.basicLabel.text = @"基础等级";
    self.basicLabel.textColor = ZTTitleColor;
    self.basicLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(30)];
    [self.bigScrollView addSubview:self.basicLabel];
    
    [self.basicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(label_height);
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        make.left.equalTo(self.bigScrollView).offset(GTW(30));
        make.top.equalTo(self.contentTextView.mas_bottom).offset(GTH(160));
    }];
    
    self.basicTextView = [[UITextView alloc] init];
    self.basicTextView.font = FONT(28);
    self.basicTextView.textColor = ZTTitleColor;
    self.basicTextView.delegate = self;
    self.basicTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.basicTextView.showsVerticalScrollIndicator = NO;
    self.basicTextView.showsHorizontalScrollIndicator = NO;
    [self.basicTextView resignFirstResponder];
    [self.bigScrollView addSubview:self.basicTextView];
    
    [self.basicTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(GTH(280));
        make.left.width.equalTo(self.basicLabel);
        make.top.equalTo(self.basicLabel.mas_bottom);
    }];

    self.basicPlaceholderLabel = [[UILabel alloc] init];
    self.basicPlaceholderLabel.text = @"输入内容";
    self.basicPlaceholderLabel.textColor = ZTTextLightGrayColor;
    self.basicPlaceholderLabel.font = FONT(28);
    [self.bigScrollView addSubview:self.basicPlaceholderLabel];
    
    [self.basicPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(120), GTH(44)));
        make.left.top.equalTo(self.basicTextView);
    }];
    
    if (self.basicTextView.text.length == 0) {
        self.basicPlaceholderLabel.hidden = NO;
    } else {
        self.basicPlaceholderLabel.hidden = YES;
    }
    
    self.basicLineView = [[UIView alloc] init];
    self.basicLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.basicLineView];
    
    [self.basicLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.width.equalTo(self.basicLabel);
        make.top.equalTo(self.basicTextView.mas_bottom);
    }];
    
    //发展等级
    self.developLabel = [[UILabel alloc] init];
    self.developLabel.text = @"发展等级";
    self.developLabel.textColor = ZTTitleColor;
    self.developLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(30)];
    [self.bigScrollView addSubview:self.developLabel];
    
    [self.developLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(label_height);
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        make.left.equalTo(self.bigScrollView).offset(GTW(30));
        make.top.equalTo(self.basicLineView.mas_bottom);
    }];
    
    self.developTextView = [[UITextView alloc] init];
    self.developTextView.textColor = ZTTitleColor;
    self.developTextView.delegate = self;
    self.developTextView.font = FONT(28);
    self.developTextView.delegate = self;
    self.developTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.developTextView.showsVerticalScrollIndicator = NO;
    self.developTextView.showsHorizontalScrollIndicator = NO;
    [self.developTextView resignFirstResponder];
    [self.bigScrollView addSubview:self.developTextView];
    
    [self.developTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.developLabel);
        make.top.equalTo(self.developLabel.mas_bottom);
        make.height.mas_equalTo(GTH(280));
    }];
    
    self.developPlaceholderLabel = [[UILabel alloc] init];
    self.developPlaceholderLabel.text = @"输入内容";
    self.developPlaceholderLabel.textColor = ZTTextLightGrayColor;
    self.developPlaceholderLabel.font = FONT(28);
    [self.bigScrollView addSubview:self.developPlaceholderLabel];
    
    [self.developPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(120), GTH(44)));
        make.left.top.equalTo(self.developTextView);
    }];
    
    if (self.developTextView.text.length == 0) {
        self.developPlaceholderLabel.hidden = NO;
    } else {
        self.developPlaceholderLabel.hidden = YES;
    }
    
    self.developLineView = [[UIView alloc] init];
    self.developLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.developLineView];
    
    [self.developLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.width.equalTo(self.developLabel);
        make.top.equalTo(self.developTextView.mas_bottom);
    }];
    
    //打分
    self.fractionLabel = [[UILabel alloc] init];
    self.fractionLabel.text = @"评分";
    self.fractionLabel.textColor = ZTTitleColor;
    self.fractionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(30)];
    [self.bigScrollView addSubview:self.fractionLabel];
    
    [self.fractionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(120), label_height));
        make.left.equalTo(self.bigScrollView).offset(GTW(30));
        make.top.equalTo(self.developLineView.mas_bottom);
    }];
    
    self.fractionTextField = [[UITextField alloc] init];
    //输入内容居中
    self.fractionTextField.textAlignment = NSTextAlignmentCenter;
    self.fractionTextField.backgroundColor = ZTLineGrayColor;
    self.fractionTextField.textColor = ZTTitleColor;
    self.fractionTextField.font = FONT(28);
    self.fractionTextField.delegate = self;
    self.fractionTextField.placeholder = @"0";
    self.fractionTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.fractionTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.fractionTextField setValue:FONT(28) forKeyPath:@"_placeholderLabel.font"];
    [self.fractionTextField resignFirstResponder];
    [self.bigScrollView addSubview:self.fractionTextField];

    [self.fractionTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(120), label_height - GTH(20) * 2));
        make.top.equalTo(self.fractionLabel).offset(GTH(20));
        make.right.equalTo(self.showMingtiButton.mas_right);
    }];
    
    self.fractionLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.fractionLineView];

    [self.fractionLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        make.left.equalTo(self.bigScrollView).offset(GTW(30));
        make.top.equalTo(self.fractionLabel.mas_bottom);
    }];
    
    //如果是命题作文
    if (self.isSHow) {
        self.typeLabel.text = @"主题";
        self.typeNameLabel.text = self.inviteModel.bigTypeName;
        
        self.fromLabel.hidden = NO;
        self.fromLineView.hidden = NO;
        self.mingtiNameLabel.hidden = NO;
        self.mingtiHeaderView.hidden = NO;

        //如果有图片
        if (self.mingtiListModel.picture.length != 0) {
            self.bigScrollView.contentSize = CGSizeMake(ScreenWidth, GTH(88) * 8 + 6 + size.height + GTH(30) * 10 + GTH(280) * 2 + GTH(160) + contentSize.height + picAllHeight * array.count);
            self.scrollBigOffset = GTH(88) * 8 + 6 + size.height + GTH(30) * 8 + GTH(280) * 2 + GTH(160) + contentSize.height + picAllHeight * array.count;

        } else {
            self.bigScrollView.contentSize = CGSizeMake(ScreenWidth, GTH(88) * 8 + 6 + size.height + GTH(30) * 8 + GTH(280) * 2 + GTH(160) + contentSize.height);
        }
    
    } else {
        //如果不是命题作文, 不计算完整命题的高度
        self.fromLabel.hidden = YES;
        self.fromLineView.hidden = YES;
        self.mingtiNameLabel.hidden = YES;
        self.mingtiHeaderView.hidden = YES;

        self.bigScrollView.contentSize = CGSizeMake(ScreenWidth, GTH(88) * 6 + 5 + size.height + GTH(30) * 4 + GTH(280) * 2 + GTH(160));
        self.scrollSmallOffset = GTH(88) * 6 + 5 + size.height + GTH(30) * 2 + GTH(280) * 2 + GTH(160);
        self.typeLabel.text = @"栏目";
        self.typeNameLabel.text = [NSString stringWithFormat:@"%@-%@", self.inviteModel.bigTypeName, self.inviteModel.typeName];

    }
    //设置总评默认文字
    [self updateConclusion];
    //添加批注颜色
    [self getMarkForContentTextView];

}



#pragma mark - 收起命题 || 展开命题 按钮
- (void)showMingtiButtonAction:(UIButton *)sender
{
    if (sender.selected == YES) {
        self.isSHow = NO;
    } else {
        self.isSHow = YES;
    }
    sender.selected = !sender.selected;
    
    //创建crollView
    [self createScrollView];

}

#pragma mark - 查看批注按钮
- (void)checkButtonAction
{
    CheckAndEditCommentViewController *checkVC = [[CheckAndEditCommentViewController alloc] init];
    checkVC.dataSourceArray = self.articleAnnotationArray;
    checkVC.articleIdStr = self.inviteModel.articleId;
    [self pushVC:checkVC animated:YES IsNeedLogin:YES];
    
}

#pragma mark - 总评按钮
- (void)conclusionButtonAction
{
    CommentConclusionViewController *conclusionVC = [[CommentConclusionViewController alloc] init];
    conclusionVC.dataSourceArray = self.articleConclusionArray;
    [self pushVC:conclusionVC animated:YES IsNeedLogin:YES];
    
}


#pragma mark - UITextField的协议方法
//点击return键,取消键盘第一响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.fractionTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.fractionTextField resignFirstResponder];
}

//已经编辑结束
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.basicTextView.text.length < 1) {
        self.basicPlaceholderLabel.hidden = NO;
        
    } else {
        self.basicPlaceholderLabel.hidden = YES;
    }

    if (self.developTextView.text.length < 1) {
        self.developPlaceholderLabel.hidden = NO;
        
    } else {
        self.developPlaceholderLabel.hidden = YES;
    }

    [self resignAllFirstResponder];

}

//已经进入编辑模式
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    self.basicPlaceholderLabel.hidden = YES;
    self.developPlaceholderLabel.hidden = YES;
}

#pragma mark - 取消所有的第一响应
- (void)resignAllFirstResponder
{
    [self.fractionTextField resignFirstResponder];
    [self.basicTextView resignFirstResponder];
    [self.developTextView resignFirstResponder];
    [self.contentTextView resignFirstResponder];
}



@end
