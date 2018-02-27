//
//  CustomWKWebViewController.h
//  ZAInvestProject
//
//  Created by 迟宸 on 17/4/10.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"
#import <WebKit/WebKit.h>
#import "WYWeakScriptMessageDelegate.h"
#import "NJKWebViewProgressView.h"

@interface CustomWKWebViewController : ZTBaseViewController <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *URLString;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NJKWebViewProgressView *webViewProgressView;//进度条

- (void)loadFileWithFileName:(NSString *)fileName;
- (void)loadRequestWithURL:(NSURL *)URL;
- (void)loadRequestWithURLString:(NSString *)URLString;

@end
