//
//  MineWebViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/29.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MineWebViewController.h"

@interface MineWebViewController ()

@end

@implementation MineWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.navTitle;
    [self loadFileWithFileName:self.pathStr];
    
}



@end
