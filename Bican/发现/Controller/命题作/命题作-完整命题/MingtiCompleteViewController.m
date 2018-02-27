//
//  MingtiCompleteViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/6.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MingtiCompleteViewController.h"
#import "MingtiListModel.h"

@interface MingtiCompleteViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UILabel *fromUserLabel;
@property (nonatomic, strong) UIView *fromUserLineView;

@property (nonatomic, strong) UILabel *fromTestLabel;
@property (nonatomic, strong) UIView *fromTestLineView;

@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *titleLineView;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) MingtiListModel *model;

@end

@implementation MingtiCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getCompleteProposition];
    
}

#pragma mark - 获取完整命题数据
- (void)getCompleteProposition
{
    [self showLoading];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableDictionary *params_ext = [NSMutableDictionary dictionary];
    
    [params setValue:self.typeIdStr forKey:@"typeId"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/proposition/get", BASE_URL];
    
    [NetWorkingManager postWithUrlStr:url token:TOKEN params:params params_ext:params_ext successHandler:^(id resultObject) {
        
        [self hideLoading];
        NSString *msg = [resultObject objectForKey:@"msg"];
        
        if (![[resultObject objectForKey:@"status"] isEqualToString:@"000000"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:msg Time:3.0];
            return;
        }
        NSDictionary *dataDic = [resultObject objectForKey:@"data"];
        self.model = [[MingtiListModel alloc] init];
        [self.model setValuesForKeysWithDictionary:dataDic];
        //创建页面
        [self createScrollView];
        
    } errorHandler:^(NSError *error) {
        [self hideLoading];

    } reloadHandler:^(BOOL isReload) {
        [self hideLoading];
        if (isReload) {
            [self pushToLoginVC];
        }
    }];
}


#pragma mark - 创建ScrollView
- (void)createScrollView
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, ScreenHeight - NAV_HEIGHT)];
    self.mainScrollView.delegate = self;
    self.mainScrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.bounces = NO;
    [self.view addSubview:self.mainScrollView];

    //创建scrollView上的其他控件
    [self createUI];
    
}

#pragma mark - 创建UI
- (void)createUI
{
    //计算标题和文本的高度, 如果有图片, 还需要计算图片的高度
    CGFloat label_width = ScreenWidth - GTW(30) * 2;
    CGFloat title_width = ScreenWidth - GTW(30) * 3 - GTW(67);
    CGSize titleSize = [self getSizeWithString:self.model.title font:[UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)] str_width:title_width];
    CGSize textSize = [self getSizeWithString:self.model.content font:FONT(28) str_width:label_width];
    CGFloat picAllHeight = 0.0;
    
    //获取图片的高度
    NSMutableArray *picHeightArray = [NSMutableArray array];
    NSArray *array = [self.model.picture componentsSeparatedByString:@","];
    if (self.model.picture.length != 0) {
        for (NSString *pic in array) {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:pic]];
            UIImage *image = [UIImage imageWithData:data];
            CGFloat pic_Height = (image.size.height * label_width) / image.size.width;
            [picHeightArray addObject:[NSString stringWithFormat:@"%.2f", pic_Height]];
            picAllHeight += pic_Height;
        }

    }
    
    //设置contentSize
    CGFloat ScrollContentHeight = textSize.height + GTH(96) * 2 + 3 + titleSize.height + GTH(26) * 4 + picAllHeight + GTH(30) * (picHeightArray.count + 1);
    self.mainScrollView.contentSize = CGSizeMake(0, ScrollContentHeight);
    
    self.fromUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(GTW(30), 0, label_width, GTH(96))];
    if (self.model.provider.length != 0) {
        self.fromUserLabel.text = [NSString stringWithFormat:@"@%@ 提供", self.model.provider];
    }    self.fromUserLabel.textColor = ZTTextGrayColor;
    self.fromUserLabel.font = FONT(28);
    [self.mainScrollView addSubview:self.fromUserLabel];
    
    self.fromUserLineView = [[UIView alloc] initWithFrame:CGRectMake(GTW(30), GTH(96), label_width, 1)];
    self.fromUserLineView.backgroundColor = ZTLineGrayColor;
    [self.mainScrollView addSubview:self.fromUserLineView];
    
    self.fromTestLabel = [[UILabel alloc] initWithFrame:CGRectMake(GTW(30), self.fromUserLineView.frame.size.height + self.fromUserLineView.frame.origin.y, label_width, GTH(96))];
    if (self.model.source.length != 0) {
        self.fromTestLabel.text = self.model.provider;
    }
    self.fromTestLabel.textColor = ZTTextGrayColor;
    self.fromTestLabel.font = FONT(28);
    [self.mainScrollView addSubview:self.fromTestLabel];
    
    self.fromTestLineView = [[UIView alloc] initWithFrame:CGRectMake(GTW(30), self.fromTestLabel.frame.size.height + self.fromTestLabel.frame.origin.y, label_width, 1)];
    self.fromTestLineView.backgroundColor = ZTLineGrayColor;
    [self.mainScrollView addSubview:self.fromTestLineView];
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(GTW(30), self.fromTestLineView.frame.size.height + self.fromTestLineView.frame.origin.y + GTH(26), GTW(67), GTH(44))];
    self.typeLabel.text = @"题目";
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.backgroundColor = ZTOrangeColor;
    self.typeLabel.font = FONT(28);
    self.typeLabel.textAlignment = NSTextAlignmentCenter;
    self.typeLabel.layer.mask = [UILabel addRoundedWithCorners:UIRectCornerTopLeft | UIRectCornerBottomRight Radii:CGSizeMake(5.0f, 5.0f) Rect:CGRectMake(0, 0, GTW(67), GTH(44))];
    [self.mainScrollView addSubview:self.typeLabel];

    self.titleLabel = [[UILabel alloc] init];
    if (self.model.title.length != 0) {
        self.titleLabel.text = self.model.title;
        self.titleLabel.frame = CGRectMake(GTW(30) + self.typeLabel.frame.size.width + self.typeLabel.frame.origin.x, self.typeLabel.frame.origin.y, title_width, titleSize.height);
    }
    self.titleLabel.textColor = ZTTitleColor;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:GTW(32)];
    [self.mainScrollView addSubview:self.titleLabel];
    
    self.titleLineView = [[UIView alloc] initWithFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.size.height + GTH(26) + self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, 1)];
    self.titleLineView.backgroundColor = ZTLineGrayColor;
    [self.mainScrollView addSubview:self.titleLineView];
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.frame = CGRectMake(GTW(30), self.titleLineView.frame.size.height + GTH(26) + self.titleLineView.frame.origin.y, label_width, textSize.height);
    self.contentLabel.textColor = ZTTextGrayColor;
    self.contentLabel.numberOfLines = 0;
    if ([NSString isHtmlString:self.model.content]) {
        [self.contentLabel htmlStringToChangeWithLabel:self.contentLabel String:self.model.content];
    } else {
        self.contentLabel.text = self.model.content;
    }
    self.contentLabel.font = FONT(28);
    [self.mainScrollView addSubview:self.contentLabel];
    
    //如果有图片, 添加图片
    if (self.model.picture.length != 0) {
        
        UIImageView *imageViewOne = [[UIImageView alloc] init];
        imageViewOne.frame = CGRectMake(GTW(30), self.contentLabel.frame.size.height + self.contentLabel.frame.origin.y + GTH(30), label_width, [picHeightArray[0] floatValue]);
        [imageViewOne sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        [self.mainScrollView addSubview:imageViewOne];

        if (picHeightArray.count == 1) {
            return;
        }
        UIImageView *imageViewTwo = [[UIImageView alloc] init];
        imageViewTwo.frame = CGRectMake(GTW(30), imageViewOne.frame.size.height + imageViewOne.frame.origin.y + GTH(30), label_width, [picHeightArray[1] floatValue]);
        [imageViewTwo sd_setImageWithURL:[NSURL URLWithString:array[1]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        [self.mainScrollView addSubview:imageViewTwo];
        
        if (picHeightArray.count == 2) {
            return;
        }
        UIImageView *imageViewThree = [[UIImageView alloc] init];
        imageViewThree.frame = CGRectMake(GTW(30), imageViewTwo.frame.size.height + imageViewTwo.frame.origin.y + GTH(30), label_width, [picHeightArray[2] floatValue]);
        [imageViewThree sd_setImageWithURL:[NSURL URLWithString:array[2]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        [self.mainScrollView addSubview:imageViewThree];
        
    }
    
    
}





@end
