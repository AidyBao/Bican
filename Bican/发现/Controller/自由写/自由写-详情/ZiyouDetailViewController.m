//
//  ZiyouDetailViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/11.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZiyouDetailViewController.h"
#import "ZiyouDetailModel.h"

@interface ZiyouDetailViewController () <UIScrollViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) BaseTextView *contentTextView;
@property (nonatomic, strong) UIMenuController *menu;
@property (nonatomic, strong) ZiyouDetailModel *model;

@end

@implementation ZiyouDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self textView];
    [self createMenuController];
    
}


#pragma mark - TextView显示HTML文本
- (void)setHtmlStrToChange
{
    self.contentTextView.attributedText = [self htmlStringToChangeWithString:self.model.content];
    
    CGSize size = [self getSizeWithString:self.contentTextView.text font:[UIFont systemFontOfSize:14.0] str_width:ScreenWidth - GTW(30) * 2];
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth, size.height * 1.5 + GTH(20) * 2);
    
}

#pragma mark - 创建接收内容的TextView
- (void)textView
{
    self.contentTextView = [[BaseTextView alloc] init];
    self.contentTextView.frame = CGRectMake(GTW(30), GTH(20) + NAV_HEIGHT, ScreenWidth - GTW(30) * 2, ScreenHeight - NAV_HEIGHT - GTH(20) * 2);
    self.contentTextView.editable = NO;
    //设置光标和选中的颜色
    self.contentTextView.tintColor = ZTOrangeColor;
    self.contentTextView.textColor = ZTTitleColor;
    self.contentTextView.backgroundColor = [UIColor whiteColor];
    self.contentTextView.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:self.contentTextView];
    
    
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
}

#pragma mark - 拖拽时禁用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.menu setMenuVisible:NO animated:YES];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSString *string = [self.contentTextView.text substringWithRange:self.contentTextView.selectedRange];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.contentTextView.text];
    [str addAttribute:NSForegroundColorAttributeName value:ZTTitleColor range:NSMakeRange(self.contentTextView.selectedRange.location, string.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(self.contentTextView.selectedRange.location, string.length)];
    [str addAttribute:NSBackgroundColorAttributeName value:ZTLightOrangeColor range:NSMakeRange(self.contentTextView.selectedRange.location, string.length)];
    self.contentTextView.attributedText = str;
}

- (void)createBigScrollView
{
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, ScreenHeight - NAV_HEIGHT)];
    self.bigScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bigScrollView];
    
    
}

@end
