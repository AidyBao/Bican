//
//  FeedbackViewController.m
//  Bican
//
//  Created by bican on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *problemLabel;
@property (nonatomic, strong) UILabel *problemLineLabel;

@property (nonatomic, strong) UITextView *descTextView;
@property (nonatomic, strong) UILabel *descTextLineLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UIButton *clearButton;

@property (nonatomic, strong) UILabel *contactLabel;
@property (nonatomic, strong) UILabel *contactLineLabel;

@property (nonatomic, strong) UITextField *contactText;
@property (nonatomic, strong) UILabel *contactTextLineLabel;

@property (nonatomic, strong) UIButton *footerButton;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"问题反馈";
    
    [self createSubViews];
    
}


- (void)createSubViews
{
    self.problemLabel = [[UILabel alloc] init];
    self.problemLabel.textColor = ZTTextGrayColor;
    self.problemLabel.text = @"问题或意见";
    self.problemLabel.font = FONT(24);
    [self.view addSubview:self.problemLabel];
    
    [self.problemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, GTH(75)));
    }];
    
    self.problemLineLabel = [[UILabel alloc] init];
    self.problemLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.problemLineLabel];

    [self.problemLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.problemLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];

    self.descTextView = [[UITextView alloc] init];
    self.descTextView.font = FONT(28);
    self.descTextView.textColor = ZTTitleColor;
    self.descTextView.textAlignment = NSTextAlignmentLeft;
    self.descTextView.delegate = self;
    [self.view addSubview:self.descTextView];

    [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.right.equalTo(self.view.mas_right).offset(GTW(-28));
        make.top.equalTo(self.problemLineLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, GTH(307)));
    }];

    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.textColor = ZTTextLightGrayColor;
    self.placeholderLabel.font = FONT(28);
    self.placeholderLabel.text = @"输入详细的问题描述";
    [self.view addSubview:self.placeholderLabel];

    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descTextView);
        make.top.equalTo(self.descTextView).offset(GTH(26));
    }];

    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setImage:[UIImage imageNamed:@"eiminate"] forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearAllText) forControlEvents:UIControlEventTouchUpInside];
    self.clearButton.hidden = YES;
    [self.view addSubview:self.clearButton];

    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(GTW(-20));
        make.bottom.equalTo(self.descTextView).offset(GTH(-20));
    }];

    self.descTextLineLabel = [[UILabel alloc] init];
    self.descTextLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.descTextLineLabel];

    [self.descTextLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.problemLineLabel);
        make.top.equalTo(self.descTextView.mas_bottom);
    }];

    self.contactLabel = [[UILabel alloc] init];
    self.contactLabel.textColor = ZTTextGrayColor;
    self.contactLabel.text = @"联系方式";
    self.contactLabel.font = FONT(24);
    [self.view addSubview:self.contactLabel];

    [self.contactLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.top.equalTo(self.descTextLineLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, GTH(75)));
    }];

    self.contactLineLabel = [[UILabel alloc] init];
    self.contactLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.contactLineLabel];

    [self.contactLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.problemLineLabel);
        make.top.equalTo(self.contactLabel.mas_bottom);
    }];

    self.contactText = [[UITextField alloc] init];
    self.contactText.textColor = ZTTitleColor;
    [self.contactText setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.contactText setValue:FONT(28) forKeyPath:@"_placeholderLabel.font"];
    self.contactText.placeholder = @"请输入您的联系方式";
    self.contactText.font = FONT(28);
    self.contactText.keyboardType = UIKeyboardTypeNumberPad;
    self.contactText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contactText.delegate = self;
    [self.view addSubview:self.contactText];

    [self.contactText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(28));
        make.right.equalTo(self.view.mas_right).offset(GTW(-28));
        make.top.equalTo(self.contactLineLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, GTH(75)));
    }];

    self.contactTextLineLabel = [[UILabel alloc] init];
    self.contactTextLineLabel.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.contactTextLineLabel];

    [self.contactTextLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.problemLineLabel);
        make.top.equalTo(self.contactText.mas_bottom);
    }];

    self.footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.footerButton setBackgroundColor:ZTOrangeColor];
    [self.footerButton setTitle:@"提交反馈" forState:UIControlStateNormal];
    self.footerButton.titleLabel.font = FONT(30);
    [self.footerButton setTitleColor:ZTTitleColor forState:UIControlStateNormal];
    self.footerButton.adjustsImageWhenHighlighted = NO;
    [self.footerButton addTarget:self action:@selector(footerButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.footerButton];

    [self.footerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(GTH(96));
    }];
    
}

#pragma mark - 提交反馈按钮
- (void)footerButtonAction
{
    if (self.descTextView.text.length == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请输入详细的问题描述" Time:3.0];
        return;
    }
    if (self.contactText.text.length == 0) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请输入您的联系方式" Time:3.0];
        return;
    }
    if (![NSString isValidatePhone:self.contactText.text]){
        [ZTToastUtils showToastIsAtTop:NO Message:@"请输入正确的手机号码" Time:3.0];
        return;
    }
    
    [self SubmitFeedback];
}
#pragma mark - 提交反馈接口
- (void)SubmitFeedback
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.descTextView.text forKey:@"content"];
    [params setValue:self.contactText.text forKey:@"contact"];

    NSString *url = [NSString stringWithFormat:@"%@api/user/feedback", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"提交成功" Time:3.0];
        [self popVCAnimated:YES];
        
    } errorHandler:^(NSError *error) {
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
    
    
}

#pragma mark - 清空数据
- (void)clearAllText
{
    self.descTextView.text = @"";
}

#pragma mark - 开始隐藏
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = YES;
    self.clearButton.hidden = YES;
    
}

#pragma mark - 结束的时候，判断是否有内容
- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.clearButton.hidden = YES;
    if (self.descTextView.text.length != 0) {
        self.placeholderLabel.hidden = YES;
    } else {
        self.placeholderLabel.hidden = NO;
    }
}

#pragma mark - 在输入的过程中
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.descTextView.text.length != 0) {
        self.placeholderLabel.hidden = YES;
        self.clearButton.hidden = NO;
        
    } else {
        //如果输入框没有内容，判断是否为第一响应
        if ([self.descTextView isFirstResponder]) {
            self.placeholderLabel.hidden = YES;
            self.clearButton.hidden = YES;
            
        } else {
            self.placeholderLabel.hidden = NO;
            self.clearButton.hidden = NO;
        }
    }
}

#pragma mark - UITextField的协议方法
//点击return键,取消键盘第一响应
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contactText resignFirstResponder];
    return YES;
}

//点击空白处,取消键盘第一响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.contactText resignFirstResponder];
    [self.descTextView resignFirstResponder];

}


@end
