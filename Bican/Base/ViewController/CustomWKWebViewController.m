//
//  CustomWKWebViewController.m
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "CustomWKWebViewController.h"

@implementation CustomWKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mark - iOS 11 新特性
    if (@available(iOS 11.0, *)) {

    } else {
        //ios 11 - 废弃
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self initUI];
    [self createLeftNavigationItem:[UIImage imageNamed:@"return"] Title:@""];
}

//点击navigationBar上的返回按钮,进行网页返回和原生界面的返回
- (void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    if ([_wkWebView canGoBack]) {
        [_wkWebView goBack];
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)initUI
{
    WKWebViewConfiguration *configuration = [[NSClassFromString(@"WKWebViewConfiguration") alloc] init];
    configuration.preferences = [NSClassFromString(@"WKPreferences") new];
    configuration.userContentController = [NSClassFromString(@"WKUserContentController") new];

    _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, ScreenHeight - NAV_HEIGHT) configuration:configuration];
    _wkWebView.backgroundColor = [UIColor whiteColor];
    _wkWebView.navigationDelegate = self;
    _wkWebView.UIDelegate = self;
    _wkWebView.opaque = NO;
    //侧滑返回webView的上一级
    [_wkWebView setAllowsBackForwardNavigationGestures:true];
    
    [self.view addSubview:_wkWebView];
    
    //监控WKWebView的title的变化
//    [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    //添加加载进度条
    CGRect navBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navBounds.size.height - 2,
                                 navBounds.size.width,
                                 2);
    _webViewProgressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _webViewProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [_webViewProgressView setProgress:0 animated:YES];
    [self.navigationController.navigationBar addSubview:_webViewProgressView];
    
    // estimatedProgress  WKWebView 这个属性添加观察者
    [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    //防止self释放不了
    WKUserContentController *userContentController = configuration.userContentController;
    
//    self.wkWebView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self.wkWebView reload];
//    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.wkWebView reload];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.webViewProgressView removeFromSuperview];
    self.webViewProgressView = nil;
}

#pragma mark - 加载URL
- (void)loadRequestWithURL:(NSURL *)URL
{
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [self.wkWebView loadRequest:request];
}

- (void)loadRequestWithURLString:(NSString *)URLString
{
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [self.wkWebView loadRequest:request];
}

#pragma mark - 加载本地HTML
- (void)loadFileWithFileName:(NSString *)fileName
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath =[resourcePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    //encoding:NSUTF8StringEncoding error:nil 这一段一定要加，不然中文字会乱码
    NSString * htmlstring=[[NSString alloc] initWithContentsOfFile:filePath  encoding:NSUTF8StringEncoding error:nil];
    [self.wkWebView loadHTMLString:htmlstring baseURL:[NSURL fileURLWithPath:[ [NSBundle mainBundle] bundlePath]]];
}

//JS调用OC方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // 方法名
    NSString *methods = [[NSString alloc] init];
    //如果没有传回参数
    if ([message.body isEqual:[NSNull null]]) {
        methods = [NSString stringWithFormat:@"%@", message.name];
        SEL selector = NSSelectorFromString(methods);
        // 调用方法
        [self performSelector:selector];
    }
    else {
        methods = [NSString stringWithFormat:@"%@:", message.name];
        SEL selector = NSSelectorFromString(methods) ;
        // 调用方法
        [self performSelector:selector withObject:[NSString stringWithFormat:@"%@",message.body]];
    }
}

- (void)loginChange:(NSNotification *)notification
{
    
}

#pragma mark - WKNavigationDelegate
//页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
    //    NSLog(@"webView.URL = %@",webView.URL);
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

//页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    if ([self.wkWebView.scrollView.mj_header isRefreshing]) {
        [self.wkWebView.scrollView.mj_header endRefreshing];
    }
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
}

#pragma mark -  WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    //    NSLog(@"警告框     message = %@", message);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler

{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler

{
    //    NSLog(@"%@",prompt);
    //主要的判断逻辑及回调就是在这里
    /*
     if ([prompt isEqualToString:@"getCustNo"]) {
     NSUserDefaults *myDic = [NSUserDefaults standardUserDefaults];
     NSDictionary *dictionary = [myDic objectForKey:@"userDectionary"];
     NSString *custno = dictionary[@"custno"];
     if (custno == nil) {
     custno = @"";
     }
     NSLog(@"custno = %@",custno);
     // 将分享的结果返回到JS中
     NSString *result = [NSString stringWithFormat:@"%@",custno];
     completionHandler(result);
     return;
     }
     */
    //解析json字符串获得json对象
    NSDictionary * dic = [NSString dictionaryWithJsonString:prompt];
    if (dic == nil) {
        return;
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    
}

#pragma mark - 监控网页title 监听webView进度条的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == _wkWebView && [keyPath isEqualToString:@"estimatedProgress"] ) {
            // 这里就不写进度条了，把加载的进度打印出来，进度条可以自己加上去！
            CGFloat currentProgress = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
            [self.webViewProgressView setProgress:currentProgress animated:YES];
        }
        return;
    }
    
    if ([keyPath isEqualToString:@"title"]) {
        if (object == self.wkWebView) {
//            self.title = change[NSKeyValueChangeNewKey];
//            self.tabBarItem.title = [NSString stringWithFormat:@""];
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc
{
//    [_wkWebView removeObserver:self forKeyPath:@"title"];
    [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
}



@end
