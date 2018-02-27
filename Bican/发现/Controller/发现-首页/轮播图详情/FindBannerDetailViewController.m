//
//  FindBannerDetailViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/16.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "FindBannerDetailViewController.h"
#import "ZiyouDetailModel.h"
#import "CustomWKWebViewController.h"

@interface FindBannerDetailViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleLineView;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIView *dateLineView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIImageView *picImageView;

@property (nonatomic, strong) ZiyouDetailModel *model;

@end

@implementation FindBannerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getgetBannerById];
}

#pragma mark - 查询banner详情
- (void)getgetBannerById
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.bannerID forKey:@"bannerId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/sys/getBannerById", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSMutableDictionary *dic = [resultObject objectForKey:@"data"];
        self.model = [[ZiyouDetailModel alloc] init];
        [self.model setValuesForKeysWithDictionary:dic];
        
        [self createScrollView];
        
    } errorHandler:^(NSError *error) {
        
        
    } reloadHandler:^(BOOL isReload) {
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}


#pragma mark - 创建ScrollView
- (void)createScrollView
{
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, ScreenHeight - NAV_HEIGHT)];
    self.bigScrollView.backgroundColor = [UIColor whiteColor];
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.bigScrollView];

    CGFloat label_width = ScreenWidth - GTW(30) * 2;
    CGFloat label_height = GTH(90);
    CGFloat label_originX = GTW(30);

    //标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.frame =CGRectMake(label_originX, 0, label_width, label_height);
    if (self.model.title.length != 0) {
        self.titleLabel.text = self.model.title;
    }
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.font = FONT(28);
    self.titleLabel.textColor = ZTTitleColor;
    [self.bigScrollView addSubview:self.titleLabel];

    self.titleLineView = [[UIView alloc] init];
    self.titleLineView.frame = CGRectMake(label_originX, label_height, label_width, 1);
    self.titleLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.titleLineView];

    //日期
    self.dateLabel = [[UILabel alloc] init];
    self.dateLabel.frame =CGRectMake(label_originX, label_height + 1, label_width, label_height);
    self.dateLabel.font = FONT(24);
    if (self.model.createDate.length != 0) {
        self.dateLabel.text = self.model.createDate;
    }
    self.dateLabel.textColor = ZTTextGrayColor;
    [self.bigScrollView addSubview:self.dateLabel];

    self.dateLineView = [[UIView alloc] init];
    self.dateLineView.frame = CGRectMake(label_originX, label_height * 2 + 1, label_width, 1);
    self.dateLineView.backgroundColor = ZTLineGrayColor;
    [self.bigScrollView addSubview:self.dateLineView];
    
//    NSLog(@"%@", self.model.content);
    
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    
    NSString *content = [self.model.content stringByReplacingOccurrencesOfString:@"&amp;quot" withString:@"'"];
    content = [content stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    content = [content stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    content = [content stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:30px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       "$img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>%@"
                       "</body>"
                       "</html>", content];
    
    [self.webView loadHTMLString:htmls baseURL:nil];
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue] + 20;
    self.webView.frame = CGRectMake(0, label_height * 2 + 1 + 1, ScreenWidth, height);
    self.webView.scrollView.scrollEnabled = NO;
    [self.bigScrollView addSubview:self.webView];
    
    self.picImageView = [[UIImageView alloc] init];
    self.picImageView.contentMode = UIViewContentModeScaleAspectFill;
    //获取图片的高度
    if (self.model.picture.length != 0) {
        self.picImageView.hidden = NO;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.picture]];
        UIImage *image = [UIImage imageWithData:data];
        CGFloat pic_Height = (image.size.height * label_width) / image.size.width;
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.model.picture] placeholderImage:[UIImage imageNamed:@""]];
        self.picImageView.frame = CGRectMake(GTW(30), self.webView.frame.size.height + self.webView.frame.origin.y + GTH(30), label_width, pic_Height);

    } else {
        self.picImageView.hidden = YES;
    }
    [self.bigScrollView addSubview:self.picImageView];

    //设置bigScrollView的偏移量
    if (self.model.picture.length == 0) {
        self.bigScrollView.contentSize = CGSizeMake(ScreenWidth, self.webView.frame.size.height + self.webView.frame.origin.y + GTH(30));

    } else {
        self.bigScrollView.contentSize = CGSizeMake(ScreenWidth, self.picImageView.frame.size.height +  self.picImageView.frame.origin.y + GTH(30));
    }

}

- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}


@end
