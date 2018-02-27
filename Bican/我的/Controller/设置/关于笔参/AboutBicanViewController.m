//
//  AboutBicanViewController.m
//  Bican
//
//  Created by bican on 2017/12/26.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "AboutBicanViewController.h"
#import "AboutBicanView.h"

@interface AboutBicanViewController ()

@end

@implementation AboutBicanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于笔参";
    
    AboutBicanView *aboutBicanView = [[AboutBicanView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, ScreenHeight - NAV_HEIGHT)];
    [self.view addSubview:aboutBicanView];
}



@end
