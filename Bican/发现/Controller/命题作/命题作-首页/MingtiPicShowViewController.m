//
//  MingtiPicShowViewController.m
//  Bican
//
//  Created by 迟宸 on 2018/1/20.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "MingtiPicShowViewController.h"

@interface MingtiPicShowViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *bigScrollView;

@end

@implementation MingtiPicShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@/%@", self.currentPicCount, self.allPicCount];
    
    [self createImageScrollView];
    
}

#pragma mark - 创建ImageScrollView
- (void)createImageScrollView
{
    //底层滚动的ScrollView
    self.bigScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAV_HEIGHT, ScreenWidth, ScreenHeight - NAV_HEIGHT)];
    self.bigScrollView.backgroundColor = [UIColor blackColor];
    self.bigScrollView.pagingEnabled = YES;
    self.bigScrollView.delegate = self;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.bigScrollView];
    self.bigScrollView.contentOffset = CGPointMake(ScreenWidth * ([self.currentPicCount integerValue] - 1), 0);
    self.bigScrollView.contentSize = CGSizeMake(ScreenWidth * self.picArray.count, ScreenHeight - NAV_HEIGHT);
    
    for (int i = 0; i < self.picArray.count; i++) {
        //缩放的ScrollView
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(ScreenWidth * i, 0, ScreenWidth, ScreenHeight - NAV_HEIGHT)];
        scrollView.delegate = self;
        scrollView.tag = 10010 + i;
        scrollView.minimumZoomScale = 1.0;
        scrollView.maximumZoomScale = 3.0;
        [scrollView setZoomScale:1.0];
        scrollView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - NAV_HEIGHT);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NAV_HEIGHT)];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:(NSString *)self.picArray[i]] placeholderImage:[UIImage imageNamed:@"zhanwei"]];
        imageView.tag = 10010 + i;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.backgroundColor = [UIColor blackColor];
        
        [scrollView addSubview:imageView];
        [self.bigScrollView addSubview:scrollView];


    }
}

#pragma mark - 返回操作的view
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    for (UIView *view in scrollView.subviews){
        return view;
    }
    return nil;
}

#pragma mark - UIScrollView停止缩放
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{

}

#pragma mark - UIScrollView正在缩放
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if(interfaceOrientation == UIInterfaceOrientationPortrait ||
       interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}

#pragma mark - 滚动后返回原来的比例
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.bigScrollView) {
        CGFloat x = scrollView.contentOffset.x;
        if (x != -ScreenWidth){
            for (UIScrollView *view in scrollView.subviews){
                if ([view isKindOfClass:[UIScrollView class]]){
                    //scrollView每次滚动, 把图片的倍数还原
                    [view setZoomScale:1.0];
                }
            }
        }
    }
}



#pragma mark - 滚动结束修改标题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.bigScrollView) {
        CGFloat offset_x = scrollView.contentOffset.x;
        NSString *current_x = [NSString stringWithFormat:@"%.0f", offset_x / ScreenWidth + 1];
        self.title = [NSString stringWithFormat:@"%@/%@", current_x, self.allPicCount];
    }

}


@end
