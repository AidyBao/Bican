//
//  AddMingtiViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/2.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AddMingtiViewController.h"
#import "ZLPhotoActionSheet.h"
#import "ZLShowBigImage.h"
#import "ZLDefine.h"
#import "ZLCollectionCell.h"

@interface AddMingtiViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;//命题
@property (nonatomic, strong) UITextField *titleTextField;
@property (nonatomic, strong) UIView *titleLineView;

@property (nonatomic, strong) UILabel *fromLabel;//来源
@property (nonatomic, strong) UITextField *fromTextField;
@property (nonatomic, strong) UIView *fromLineView;

@property (nonatomic, strong) UILabel *addTypeLabel;//上传图片
@property (nonatomic, strong) UILabel *addLabel;
@property (nonatomic, strong) UIView *addView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *addLineView;

@property (nonatomic, strong) UILabel *contentLabel;//内容
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *contentPlaceholderLabel;

@property (nonatomic, strong) NSArray<ZLSelectPhotoModel *> *lastSelectMoldels;
@property (nonatomic, strong) NSArray *arrDataSources;
    
@end

@implementation AddMingtiViewController

- (NSArray *)arrDataSources
{
    if (!_arrDataSources) {
        _arrDataSources = [NSArray array];
    }
    return _arrDataSources;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传命题";
    [self createRightNavigationItem:nil Title:@"提交" RithtTitleColor:ZTTitleColor BackgroundColor:ZTOrangeColor CornerRadius:GTH(10)];
    
    
    [self createUI];
    
}

#pragma mark - 右侧提交按钮
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    if ([NSString isEmptyOrWhitespace:self.fromTextField.text]) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请填写命题来源" Time:3.0];
        return;
    }
    if ([NSString isEmptyOrWhitespace:self.contentTextView.text]) {
        [ZTToastUtils showToastIsAtTop:NO Message:@"请填写命题内容" Time:3.0];
        return;
    }
    //调用接口
    [self fileUpload];
    
}

#pragma mark - 命题图片上传
- (void)fileUpload
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];

    //命题图片, ","分割
    NSMutableArray *picPathArray = [NSMutableArray array];
    for (UIImage *image in self.arrDataSources) {
//        NSData *pictureData = UIImagePNGRepresentation(image);
        NSData *pictureData = UIImageJPEGRepresentation(image, 0.5);
        NSString *result = [pictureData base64EncodedStringWithOptions:0];
        [picPathArray addObject:result];
    }
    NSString *filePath = [picPathArray componentsJoinedByString:@","];
    [params setValue:filePath forKey:@"fileList"];

    NSString *url = [NSString stringWithFormat:@"%@api/file/uploadIOS", BASE_URL];

    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {

        NSString *msg = [resultObject objectForKey:@"msg"];
//        NSLog(@"提交图片%@", msg);

        [self hideLoading];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        [ZTToastUtils showToastIsAtTop:NO Message:@"图片上传成功" Time:3.0];
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        NSString *url = [dic objectForKey:@"url"];
        [self savePropositionWithPath:url];

    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];

     
}


#pragma mark - 老师上传命题
- (void)savePropositionWithPath:(NSString *)path
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    //题目
    [params setValue:self.titleTextField.text forKey:@"title"];
    //来源
    [params setValue:self.fromTextField.text forKey:@"source"];
    //内容
    [params setValue:self.contentTextView.text forKey:@"description"];
    //图片的路径
    [params setValue:path forKey:@"filePath"];

    NSString *url = [NSString stringWithFormat:@"%@api/proposition/save", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        [self hideLoading];
        [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            return;
        }
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


#pragma mark - 创建界面
- (void)createUI
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = RGBA(251, 251, 251, 1);
    [self.view addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.height.mas_equalTo(GTH(263));
    }];
    
    //命题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"选填";
    self.titleLabel.font = FONT(24);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = ZTGrayColor;
    self.titleLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.view addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(67), GTH(44)));
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.top.equalTo(self.view.mas_top).offset(GTH(35) + NAV_HEIGHT);
    }];
    
    self.titleTextField = [[UITextField alloc] init];
    self.titleTextField.placeholder = @"命题题目";
    self.titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.titleTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.titleTextField setValue:FONT(26) forKeyPath:@"_placeholderLabel.font"];
    self.titleTextField.textColor = ZTTitleColor;
    self.titleTextField.delegate = self;
    self.titleTextField.font = FONT(26);
    [self.titleTextField resignFirstResponder];
    [self.view addSubview:self.titleTextField];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(GTW(18));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.top.equalTo(self.view.mas_top).offset(NAV_HEIGHT);
        make.height.mas_equalTo(GTH(112));
    }];

    self.titleLineView = [[UIView alloc] init];
    self.titleLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.titleLineView];
    
    [self.titleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.height.mas_equalTo(1);
        make.top.equalTo(self.titleTextField.mas_bottom);
    }];
    
    //来源
    self.fromLabel = [[UILabel alloc] init];
    self.fromLabel.text = @"必填";
    self.fromLabel.font = FONT(24);
    self.fromLabel.textAlignment = NSTextAlignmentCenter;
    self.fromLabel.textColor = [UIColor whiteColor];
    self.fromLabel.backgroundColor = ZTOrangeColor;
    self.fromLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.view addSubview:self.fromLabel];
    
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(67), GTH(44)));
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.top.equalTo(self.titleLineView.mas_bottom).offset(GTH(35));
    }];
    
    self.fromTextField = [[UITextField alloc] init];
    self.fromTextField.placeholder = @"命题来源";
    self.fromTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.fromTextField setValue:ZTTextLightGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    [self.fromTextField setValue:FONT(26) forKeyPath:@"_placeholderLabel.font"];
    self.fromTextField.textColor = ZTTitleColor;
    self.fromTextField.delegate = self;
    self.fromTextField.font = FONT(26);
    [self.fromTextField resignFirstResponder];
    [self.view addSubview:self.fromTextField];
    
    [self.fromTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(self.titleTextField);
        make.top.equalTo(self.titleLineView.mas_bottom);
    }];
    
    self.fromLineView = [[UIView alloc] init];
    self.fromLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.fromLineView];
    
    [self.fromLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.titleLineView);
        make.top.equalTo(self.fromTextField.mas_bottom);
    }];
    
    //上传图片
    self.addTypeLabel = [[UILabel alloc] init];
    self.addTypeLabel.text = @"选填";
    self.addTypeLabel.font = FONT(24);
    self.addTypeLabel.textAlignment = NSTextAlignmentCenter;
    self.addTypeLabel.textColor = [UIColor whiteColor];
    self.addTypeLabel.backgroundColor = ZTGrayColor;
    self.addTypeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.view addSubview:self.addTypeLabel];
    
    [self.addTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(67), GTH(44)));
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.top.equalTo(self.backView.mas_bottom).offset(GTH(30));
    }];
    
    self.addLabel = [[UILabel alloc] init];
    self.addLabel.text = @"上传图片";
    self.addLabel.textColor = ZTTitleColor;
    self.addLabel.font = FONT(28);
    [self.view addSubview:self.addLabel];
    
    [self.addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addTypeLabel.mas_right).offset(GTW(20));
        make.centerY.equalTo(self.addTypeLabel);
    }];
    
    CGFloat width = (ScreenWidth - GTW(30) * 4) / 3;

    self.addView = [[UIView alloc] init];
    self.addView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addView];

    [self.addView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.top.equalTo(self.addLabel.mas_bottom).offset(GTH(30));
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, GTH(184)));
    }];

    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setBackgroundColor:ZTGrayColor];
    [self.addButton setImage:[UIImage imageNamed:@"addbig"] forState:UIControlStateNormal];
    self.addButton.adjustsImageWhenHighlighted = NO;
    [self.addButton addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addButton];
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.addView);
        make.width.mas_equalTo(width);
        make.left.equalTo(self.view).offset(GTW(30));
    }];
    
    self.addLineView = [[UIView alloc] init];
    self.addLineView.backgroundColor = ZTLineGrayColor;
    [self.view addSubview:self.addLineView];
    
    [self.addLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.titleLineView);
        make.top.equalTo(self.addButton.mas_bottom).offset(GTH(30));
    }];
    
    //内容
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.text = @"必填";
    self.contentLabel.font = FONT(24);
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.backgroundColor = ZTOrangeColor;
    self.fromLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.view addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(GTW(67), GTH(44)));
        make.left.equalTo(self.view.mas_left).offset(GTW(30));
        make.top.equalTo(self.addLineView.mas_bottom).offset(GTH(35));
    }];
    
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.textColor = ZTTitleColor;
    self.contentTextView.delegate = self;
    self.contentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.contentTextView.backgroundColor = [UIColor whiteColor];
    self.contentTextView.font = FONT(26);
    self.contentTextView.showsVerticalScrollIndicator = NO;
    self.contentTextView.showsHorizontalScrollIndicator = NO;
    [self.contentTextView resignFirstResponder];
    [self.view addSubview:self.contentTextView];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_right).offset(GTW(20));
        make.top.equalTo(self.contentLabel);
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
        make.bottom.equalTo(self.view.mas_bottom).offset(GTH(-30));
    }];
    
    self.contentPlaceholderLabel = [[UILabel alloc] init];
    self.contentPlaceholderLabel.text = @"命题内容";
    self.contentPlaceholderLabel.font = FONT(26);
    self.contentPlaceholderLabel.textColor = ZTTextLightGrayColor;
    [self.view addSubview:self.contentPlaceholderLabel];
    
    [self.contentPlaceholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentTextView);
        make.right.equalTo(self.view.mas_right).offset(GTW(-30));
    }];
    
}

#pragma mark - 上传图片
- (void)addButtonAction
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    //设置照片最大选择数
    actionSheet.maxSelectCount = 3;
    weakify(self);
    
    [actionSheet showPhotoLibraryWithSender:self lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
        
        strongify(weakSelf);
        strongSelf.arrDataSources = selectPhotos;
//        strongSelf.lastSelectMoldels = selectPhotoModels;

        [strongSelf updateUI];
        
    }];
    

}

#pragma mark - 更新页面
- (void)updateUI
{
    if (self.arrDataSources.count == 0) {
        return;
    }
    CGFloat width = (ScreenWidth - GTW(30) * 4) / 3;
    
    for (UIView *view in self.addView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    for (int i = 0; i < self.arrDataSources.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1100 + i;
        [button setImage:self.arrDataSources[i] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
        button.adjustsImageWhenHighlighted = NO;
        [button addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.addView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.addButton);
            make.width.mas_equalTo(width);
            make.left.equalTo(self.view.mas_left).offset(width * i + GTW(30) * (i + 1));
        }];
        
    }
    if (self.arrDataSources.count < 3) {
        self.addButton.hidden = NO;
        [self.addButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset((width * self.arrDataSources.count) + GTW(30) * (self.arrDataSources.count + 1));
        }];
        
    } else {
        self.addButton.hidden = YES;
    }

}

#pragma mark - UITextViewDelegate
//已经编辑结束
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.contentTextView) {
        if (textView.text.length < 1) {
            self.contentPlaceholderLabel.hidden = NO;
            
        } else {
            self.contentPlaceholderLabel.hidden = YES;
        }
    }
    [textView resignFirstResponder];
    
}


//已经进入编辑模式
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    self.contentPlaceholderLabel.hidden = YES;
}





@end
