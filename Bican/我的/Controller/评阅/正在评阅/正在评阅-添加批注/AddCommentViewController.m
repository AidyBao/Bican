//
//  AddCommentViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/24.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AddCommentViewController.h"

@interface AddCommentViewController () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *contentLineView;
@property (nonatomic, strong) UITextView *commentTextView;
@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation AddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createRightNavigationItem:nil Title:@"确定" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:GTH(10)];
    
    [self createUI];
    
}

#pragma mark - 确认按钮, 保存添加的批注
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    if (self.commentTextView.text.length == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"批注内容不能为空" Time:3.0];
        return;
    }
    if (self.comment.length == 0) {
        //添加批注
        [self annotationSave];
    } else {
        //修改批注
        [self annotationModify];
    }
    
}

#pragma mark - 添加批注
- (void)annotationSave
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.articleIdStr forKey:@"articleId"];
    //原文
    [params setValue:self.cotentStr forKey:@"sourceTxt"];
    //批注内容
    [params setValue:self.commentTextView.text forKey:@"content"];
    //从第几个文字开始(下标)
    [params setValue:self.startIndex forKey:@"startTxt"];
    //在第几个文字结束(下标)
    [params setValue:self.endIndex forKey:@"endTxt"];
    //发布状态：0为草稿，1为发布
    [params setValue:@"1" forKey:@"status"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/annotation/save", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"添加批注成功" Time:3.0];
        [self popVCAnimated:YES];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];
        
    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 编辑批注
- (void)annotationModify
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.annotationIdStr forKey:@"annotationId"];
    //原文
    [params setValue:self.cotentStr forKey:@"sourceTxt"];
    //批注内容
    [params setValue:self.commentTextView.text forKey:@"content"];
    //从第几个文字开始(下标)
    [params setValue:self.startIndex forKey:@"startTxt"];
    //在第几个文字结束(下标)
    [params setValue:self.endIndex forKey:@"endTxt"];
    //发布状态：0为草稿，1为发布
    [params setValue:@"1" forKey:@"status"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/annotation/modify", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"修改批注成功" Time:3.0];
        [self popVCAnimated:YES];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];
        
    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}

#pragma mark - 创建页面
- (void)createUI
{
    self.typeLabel = [[UILabel alloc] init];
    self.typeLabel.text = @"原文";
    self.typeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(80), GTH(60))];
    self.typeLabel.font = FONT(30);
    self.typeLabel.backgroundColor = ZTOrangeColor;
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.typeLabel];
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(GTW(30));
        make.top.equalTo(self.view).offset(GTH(60) + NAV_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(GTW(80), GTH(60)));
    }];
    
   CGSize contentSize = [self getSizeWithString:self.cotentStr font:FONT(28) str_width:ScreenWidth - GTW(30) * 3 - GTW(68)];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = self.cotentStr;
    self.contentLabel.font = FONT(28);
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.numberOfLines = 0;
    [self.view addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right).offset(GTW(30));
        make.top.equalTo(self.typeLabel);
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(contentSize.height);
    }];
    
    self.contentLineView = [[UIView alloc] init];
    self.contentLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.contentLineView];
    
    [self.contentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(GTH(60));
        make.left.equalTo(self.typeLabel);
        make.right.equalTo(self.contentLabel);
    }];
    
    self.commentTextView = [[UITextView alloc] init];
    self.commentTextView.font = FONT(30);
    self.commentTextView.textColor = ZTTitleColor;
    self.commentTextView.delegate = self;
    self.commentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.commentTextView.showsVerticalScrollIndicator = NO;
    self.commentTextView.showsHorizontalScrollIndicator = NO;
    self.commentTextView.text = self.comment;
    [self.commentTextView resignFirstResponder];
    [self.view addSubview:self.commentTextView];
    
    [self.commentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentLineView);
        make.top.equalTo(self.contentLineView.mas_bottom).offset(GTH(60));
        make.bottom.equalTo(self.view);
    }];
    
    self.commentLabel = [[UILabel alloc] init];
    self.commentLabel.text = @"填写批注";
    self.commentLabel.textColor = ZTTextLightGrayColor;
    self.commentLabel.font = FONT(30);
    [self.view addSubview:self.commentLabel];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.commentTextView);
    }];
    
    if (self.comment.length == 0) {
        self.commentLabel.hidden = NO;
    } else {
        self.commentLabel.hidden = YES;
    }
    
}

#pragma mark - UITextViewDelegate
//已经编辑结束
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.commentTextView.text.length < 1) {
        self.commentLabel.hidden = NO;
        
    } else {
        self.commentLabel.hidden = YES;
    }

    [self.commentTextView resignFirstResponder];

    
}


//已经进入编辑模式
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    self.commentLabel.hidden = YES;
}




@end
