//
//  ClassStudentViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/8.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ClassStudentViewController.h"
#import "ArticleListViewController.h"
#import "StudentInfoModel.h"

@interface ClassStudentViewController ()

@property (nonatomic, strong) StudentInfoModel *studentInfoModel;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *classLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) UILabel *readLabel;//评阅文章
@property (nonatomic, strong) UILabel *countLabel;//受邀次数
@property (nonatomic, strong) UILabel *rateLabel;//好评率
@property (nonatomic, strong) UIView *starLineView;

@property (nonatomic, strong) UILabel *pagesLabel;//文集
@property (nonatomic, strong) UILabel *pagesCountLabel;
@property (nonatomic, strong) UIImageView *goImageView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) NSMutableArray *starArray;
@property (nonatomic, assign) double starRate;
@property (nonatomic, strong) NSString *isAttention;//记录关注的状态

@end

@implementation ClassStudentViewController

- (NSMutableArray *)starArray
{
    //总分5分
    if (!_starArray) {
        if (self.starRate * 20 >= 100) {//5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star1", nil];
            
        } else if (self.starRate * 20 > 80 && self.starRate * 20 < 100) {//4.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star2", nil];
            
        } else if (self.starRate * 20 == 80) {//4
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 > 60 && self.starRate * 20 < 80) {//3.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star2", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 == 60) {//3
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star1", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 > 40 && self.starRate * 20 < 60) {//2.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star2", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 == 40) {//2
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star1", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 > 20 && self.starRate * 20 < 40) {//1.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star2", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 == 20) {//1
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star1", @"yellow_star3", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 > 0 && self.starRate * 20 < 20) {//0.5
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star2", @"yellow_star3", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
            
        } else if (self.starRate * 20 <= 0) {//0
            _starArray = [NSMutableArray arrayWithObjects:@"yellow_star3", @"yellow_star3", @"yellow_star3", @"yellow_star3", @"yellow_star3", nil];
        }
        
    }
    return _starArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self markReadAll];
    [self getUserInfoById];

}

#pragma mark - 根据用户ID获取用户基本信息
- (void)getUserInfoById
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //点击用户ID
    [params setValue:self.clickUserIdStr forKey:@"clickUserId"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/getByUseId", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        self.studentInfoModel = [[StudentInfoModel alloc] init];
        [self.studentInfoModel setValuesForKeysWithDictionary:dic];
        //给关注状态赋初始值
        self.isAttention = self.studentInfoModel.isAttention;
        //创建页面
        [self createSubViews];
        [self updateUI];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];
        
    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 更新UI
- (void)updateUI
{
    //评阅文章
    NSInteger readLen = 0;
    if (self.studentInfoModel.reviewNumber.length == 0) {
        self.readLabel.text = @"评阅文章 0";
    } else if ([self.studentInfoModel.reviewNumber integerValue] > 999) {
        self.readLabel.text = @"评阅文章 999+";
        readLen = 4;
    } else {
        self.readLabel.text = [NSString stringWithFormat:@"评阅文章 %@", self.studentInfoModel.reviewNumber];
        readLen = self.studentInfoModel.reviewNumber.length;
    }
    self.readLabel.attributedText = [UILabel changeLabel:self.readLabel Color:ZTOrangeColor Loc:5 Len:readLen Font:self.readLabel.font];
    
    //受邀次数
    NSInteger inviteLen = 0;
    if (self.studentInfoModel.inviteNumber.length == 0) {
        self.countLabel.text = @"受邀次数 0";
    } else if ([self.studentInfoModel.inviteNumber integerValue] > 999) {
        self.countLabel.text = @"受邀次数 999+";
        inviteLen = 4;
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"受邀次数 %@", self.studentInfoModel.inviteNumber];
        inviteLen = self.studentInfoModel.inviteNumber.length;
    }
    self.countLabel.attributedText = [UILabel changeLabel:self.countLabel Color:ZTOrangeColor Loc:5 Len:inviteLen Font:self.countLabel.font];
    
    //文集
    if (self.studentInfoModel.articleCount.length == 0) {
        self.pagesCountLabel.text = @"0篇作文";
    } else if ([self.studentInfoModel.articleCount integerValue] > 999) {
        self.pagesCountLabel.text = @"999+篇作文";
    } else {
        self.pagesCountLabel.text = [NSString stringWithFormat:@"%@篇作文", self.studentInfoModel.articleCount];
    }
    
    self.starRate = [self.studentInfoModel.goodReview doubleValue];
    CGFloat star_width = GTW(30);
    for (int i = 0; i < self.starArray.count; i++) {
        UIImageView *starImageView = [[UIImageView alloc] init];
        starImageView.image = [UIImage imageNamed:self.starArray[i]];
        [self.view addSubview:starImageView];
        
        [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.rateLabel.mas_right).offset(GTW(10) + star_width * i);
            make.top.equalTo(self.lineLabel.mas_bottom).offset(GTH(29));
        }];
    }

}

- (void)createSubViews
{
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.layer.cornerRadius = GTH(100) / 2;
    self.headerImageView.image = [UIImage imageNamed:@"my_header"];
    self.headerImageView.layer.masksToBounds = YES;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.studentInfoModel.avatar] placeholderImage:[UIImage imageNamed:@"my_header"]];
    [self.view addSubview:self.headerImageView];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.top.equalTo(self.view).offset(GTH(40) + NAV_HEIGHT);
        make.width.height.mas_equalTo(GTH(100));
    }];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.studentInfoModel.isAttention isEqualToString:@"0"]) {
        [self.addButton setTitle:@"+ 加关注" forState:UIControlStateNormal];
        [self.addButton setBackgroundColor:ZTOrangeColor];
    } else {
        [self.addButton setBackgroundColor:ZTLineGrayColor];
        [self.addButton setTitle:@"已关注" forState:UIControlStateNormal];
    }
    [self.addButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.addButton.titleLabel.font = FONT(30);
    self.addButton.layer.cornerRadius = GTH(10);
    self.addButton.adjustsImageWhenHighlighted = NO;
    [self.addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(GTH(35) + NAV_HEIGHT);
        make.right.equalTo(self.view.mas_right).offset(GTW(-28));
        make.size.mas_equalTo(CGSizeMake(GTW(151), GTH(63)));
    }];
    
    self.nameLabel = [[UILabel alloc] init];
    if ([self.studentInfoModel.roleType isEqualToString:@"2"]) {//老师
        self.nameLabel.text = [NSString stringWithFormat:@"%@(%@%@)", self.studentInfoModel.nickname, self.studentInfoModel.firstName, self.studentInfoModel.lastName];

    } else {//学生
        self.nameLabel.text = self.studentInfoModel.nickname;
    }
    self.nameLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    self.nameLabel.textColor = ZTTitleColor;
    [self.view addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView.mas_right).offset(GTW(36));
        make.top.equalTo(self.view.mas_top).offset(GTH(50) + NAV_HEIGHT);
        make.right.equalTo(self.addButton.mas_left).offset(GTW(-28));
    }];
    
    self.classLabel = [[UILabel alloc] init];
    self.classLabel.font = FONT(28);
    if ([self.studentInfoModel.roleType isEqualToString:@"2"]) {//老师
        self.classLabel.text = self.studentInfoModel.schoolName;

    } else {//学生
        self.classLabel.text = [NSString stringWithFormat:@"%@  %@", self.studentInfoModel.schoolName, self.studentInfoModel.currentGrade];
    }
    self.classLabel.textColor = ZTTextLightGrayColor;
    [self.view addSubview:self.classLabel];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.view.mas_right).offset(GTW(-28));
        make.top.equalTo(self.nameLabel.mas_bottom).offset(GTH(20));
    }];
    
    self.lineLabel = [[UILabel alloc] init];
    self.lineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.lineLabel];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.right.equalTo(self.view.mas_right).offset(GTW(-28));
        make.top.equalTo(self.headerImageView.mas_bottom).offset(GTH(25));
        make.height.mas_equalTo(1);
    }];
    
    CGFloat star_width = GTW(30);
    CGFloat rate_width = GTW(100);
    CGFloat label_width = (ScreenWidth - GTW(28) * 2 - rate_width - star_width * 5 - GTW(10) * 3) / 2;
    
    self.readLabel = [[UILabel alloc] init];
    self.readLabel.textColor = ZTTextLightGrayColor;
    self.readLabel.font = FONT(28);
    [self.view addSubview:self.readLabel];
    
    [self.readLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerImageView);
        make.top.equalTo(self.lineLabel.mas_bottom).offset(GTH(29));
        make.width.mas_equalTo(label_width);
    }];
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.textColor = ZTTextLightGrayColor;
    self.countLabel.font = FONT(28);
    [self.view addSubview:self.countLabel];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.readLabel.mas_right).offset(GTW(10));
        make.top.width.equalTo(self.readLabel);
    }];
    
    self.rateLabel = [[UILabel alloc] init];
    self.rateLabel.text = @"好评率";
    self.rateLabel.textColor = ZTTextLightGrayColor;
    self.rateLabel.font = FONT(28);
    self.rateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.rateLabel];
    
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countLabel.mas_right).offset(GTW(10));
        make.top.equalTo(self.readLabel);
        make.width.mas_equalTo(rate_width);
    }];
    
    if ([self.studentInfoModel.roleType isEqualToString:@"2"]) {
        return;
    }
    
    self.starLineView = [[UIView alloc] init];
    self.starLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.starLineView];
    
    [self.starLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.lineLabel);
        make.top.equalTo(self.readLabel.mas_bottom).offset(GTH(29));
    }];
    
    self.pagesLabel = [[UILabel alloc] init];
    self.pagesLabel.text = @"文集";
    self.pagesLabel.font = FONT(28);
    self.pagesLabel.textColor = ZTTitleColor;
    [self.view addSubview:self.pagesLabel];
    
    [self.pagesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineLabel);
        make.top.equalTo(self.starLineView.mas_bottom).offset(GTH(29));
    }];
    
    self.goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wode-link-icon"]];
    [self.view addSubview:self.goImageView];
    
    [self.goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.pagesLabel);
        make.size.mas_equalTo(CGSizeMake(GTW(16), GTH(28)));
    }];
    
    self.pagesCountLabel = [[UILabel alloc] init];
    self.pagesCountLabel.textColor = ZTTextGrayColor;
    self.pagesCountLabel.textAlignment = NSTextAlignmentRight;
    self.pagesCountLabel.font = FONT(28);
    [self.view addSubview:self.pagesCountLabel];
    
    [self.pagesCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.goImageView.mas_left).offset(GTW(-10));
        make.centerY.equalTo(self.goImageView);
    }];
    
    self.bottomLineView = [[UIView alloc] init];
    self.bottomLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.bottomLineView];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.starLineView);
        make.top.equalTo(self.pagesCountLabel.mas_bottom).offset(GTH(29));
    }];
    
    UIControl *control = [[UIControl alloc] init];
    [control addTarget:self action:@selector(controlToPush) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    
    [control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starLineView);
        make.bottom.equalTo(self.bottomLineView);
        make.left.right.equalTo(self.view);
    }];
    
}

#pragma mark - 跳转到文集列表
- (void)controlToPush
{
    ArticleListViewController *articleVC = [[ArticleListViewController alloc] init];
    articleVC.studentIdStr = self.studentInfoModel.userId;
    articleVC.nickName = self.studentInfoModel.nickname;
    articleVC.schoolName = self.studentInfoModel.schoolName;

    [self pushVC:articleVC animated:YES IsNeedLogin:YES];
}

#pragma mark - 关注和取消关注按钮
- (void)addButtonAction
{
    if ([self.studentInfoModel.isAttention isEqualToString:@"0"]) {
        [self.addButton setBackgroundColor:ZTLineGrayColor];
        [self.addButton setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        [self.addButton setTitle:@"+ 加关注" forState:UIControlStateNormal];
        [self.addButton setBackgroundColor:ZTOrangeColor];
    }
    //调用接口
    [self attentionChange];
    
}


#pragma mark - 关注/取消关注
- (void)attentionChange
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //关注用户ID
    [params setValue:self.studentInfoModel.userId forKey:@"attentionUserId"];
    //状态: 1-关注, 2-取消关注
    if ([self.isAttention isEqualToString:@"0"]) {
        self.isAttention = @"1";
        [params setValue:@"1" forKey:@"status"];
    } else {
        self.isAttention = @"0";
        [params setValue:@"2" forKey:@"status"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@api/user/attentionChange", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        if ([self.isAttention isEqualToString:@"0"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"取消关注成功" Time:3.0];
            [self.addButton setTitle:@"+ 加关注" forState:UIControlStateNormal];
            [self.addButton setBackgroundColor:ZTOrangeColor];
        }
        if ([self.isAttention isEqualToString:@"1"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"关注成功" Time:3.0];
            [self.addButton setBackgroundColor:ZTLineGrayColor];
            [self.addButton setTitle:@"已关注" forState:UIControlStateNormal];
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

#pragma mark - 获取分类消息全部标记为已读
- (void)markReadAll
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:@"4" forKey:@"type"];

    NSString *url = [NSString stringWithFormat:@"%@api/message/markReadAll", BASE_URL];
    
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
