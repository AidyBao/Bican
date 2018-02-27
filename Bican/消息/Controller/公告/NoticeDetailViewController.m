//
//  NoticeDetailViewController.m
//  Bican
//
//  Created by bican on 2018/1/27.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "NoticeModel.h"

@interface NoticeDetailViewController ()

@property (nonatomic, strong) UIScrollView *bigScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *picImageView;

@property (nonatomic, assign) NSInteger page_size;// 需要查询的条数
@property (nonatomic, assign) NSInteger start_row;//当前页数
@property (nonatomic, strong) NSString *pageCount;//总页数(number)
@property (nonatomic, strong) NSMutableArray *dateArray;

@end

@implementation NoticeDetailViewController

- (NSMutableArray *)dateArray
{
    if (!_dateArray) {
        _dateArray = [NSMutableArray array];
    }
    return _dateArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self modifyReadStatusBulletin];
    [self createScrollView];
    
}

#pragma mark - 创建ScrollView
- (void)createScrollView
{
    CGFloat pic_height = 0.0;
    if (self.noticeModel.picture.length != 0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.noticeModel.picture]];
        UIImage *image = [UIImage imageWithData:data];
        pic_height = image.size.height;
    }
    
    CGSize titleSize = [self getSizeWithString:self.noticeModel.title font:FONT(30) str_width:ScreenWidth - GTW(30) * 2];

    CGSize contentSize = [self getSizeWithString:self.noticeModel.content font:FONT(26) str_width:ScreenWidth - GTW(30) * 2];
    
    self.bigScrollView = [[UIScrollView alloc] init];
    self.bigScrollView.backgroundColor = [UIColor whiteColor];
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth - GTW(30) * 2, contentSize.height + titleSize.height + GTH(36) * 4 + GTH(44) + pic_height);
    [self.view addSubview:self.bigScrollView];
    
    [self.bigScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NAV_HEIGHT);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = FONT(30);
    self.titleLabel.text = self.noticeModel.title;
    self.titleLabel.textColor = ZTTitleColor;
    [self.bigScrollView addSubview:self.titleLabel];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bigScrollView.mas_left).offset(GTW(30));
        make.width.mas_equalTo(ScreenWidth - GTW(30) * 2);
        make.top.equalTo(self.bigScrollView.mas_top).offset(GTH(50));
    }];

    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = FONT(26);
    self.timeLabel.text = self.noticeModel.pubTime;
    self.timeLabel.textColor = ZTTitleColor;
    [self.bigScrollView addSubview:self.timeLabel];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(GTH(36));
        make.height.mas_equalTo(GTH(44));
    }];

    self.contentLabel = [[UILabel alloc] init];
    if ([NSString isHtmlString:self.noticeModel.content]) {
        [self.contentLabel htmlStringToChangeWithLabel:self.contentLabel String:self.noticeModel.content];
    } else {
        self.contentLabel.text = self.noticeModel.content;
    }
    self.contentLabel.textColor = ZTTitleColor;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.font = FONT(26);
    [self.bigScrollView addSubview:self.contentLabel];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(GTH(36));
    }];

    if (self.noticeModel.picture.length != 0) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.noticeModel.picture]];
        UIImage *image = [UIImage imageWithData:data];

        self.picImageView = [[UIImageView alloc] init];
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:self.noticeModel.picture] placeholderImage:[UIImage imageNamed:@""]];
        [self.bigScrollView addSubview:self.picImageView];

        [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(GTH(36));
            make.height.mas_equalTo((image.size.height * (ScreenWidth - GTW(30) * 2)) / image.size.width);
        }];
    }

    
}

#pragma mark - 修改公告状态
- (void)modifyReadStatusBulletin
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setObject:self.noticeModel.bullitenId forKey:@"bulletinId"];

    NSString *url = [NSString stringWithFormat:@"%@api/bulletin/modifyReadStatus", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {

        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
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

@end
