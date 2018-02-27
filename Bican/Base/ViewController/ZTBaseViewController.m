//
//  ZTBaseViewController.m
//  Bican
//
//  Created by 迟宸 on 2017/12/21.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTBaseViewController.h"
#import "MineLoginViewController.h"

@interface ZTBaseViewController ()

@end

@implementation ZTBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    //    [UIViewController attemptRotationToDeviceOrientation];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO];
    
#pragma mark - iOS 11新特性
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - 设置透明导航栏
- (void)setClearColorNavgationBar
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - 创建导航拦左按钮
- (void)createLeftNavigationItem:(UIImage *)leftImage Title:(NSString *)leftTitle
{
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 30, 30);
    leftBtn.imageView.contentMode = UIViewContentModeCenter;
    [leftBtn addTarget:self action:@selector(LeftNavigationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    if (leftImage) {
        [leftBtn setImage:leftImage forState:UIControlStateNormal];
        [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    }
    if (leftTitle) {
        [leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        leftBtn.titleLabel.font = FONT(30);
        [leftBtn setTitleColor:ZTTitleColor forState:UIControlStateNormal];
        //        leftBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
}

#pragma mark - 创建导航拦右按钮
- (void)createRightNavigationItem:(UIImage *)RightImage
                            Title:(NSString *)RightTitle
                  RithtTitleColor:(UIColor *)RithtTitleColor
                  BackgroundColor:(UIColor *)backgroundColor
                     CornerRadius:(CGFloat)cornerRadius
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, GTW(80), GTH(60));
    [rightBtn setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [rightBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightBtn addTarget:self action:@selector(RightNavigationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (RightImage) {
        [rightBtn setImage:RightImage forState:UIControlStateNormal];
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, -10)];
    }
    if (RightTitle) {
        [rightBtn setTitle:RightTitle forState:UIControlStateNormal];
        rightBtn.titleLabel.font = FONT(30);
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightBtn setTitleColor:RithtTitleColor forState:UIControlStateNormal];
        if (RightTitle.length > 3) {
            rightBtn.frame = CGRectMake(0, 0, GTW(150), 30);
        }
        if (RightTitle.length > 5) {
            rightBtn.frame = CGRectMake(0, 0, GTW(270), 30);
        }
        //        [rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    }
    if (backgroundColor) {
        [rightBtn setBackgroundColor:backgroundColor];
        rightBtn.layer.masksToBounds = YES;
        rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        rightBtn.layer.cornerRadius = cornerRadius;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}

#pragma mark - 点击左按钮
- (void)LeftNavigationButtonClick:(UIButton *)leftbtn
{
    
}

#pragma mark - 点击右按钮
- (void)RightNavigationButtonClick:(UIButton *)rightbtn
{
    
}

#pragma mark - 创建系统样式的左右按钮
- (void)createLeftSystemNavigationItemWith:(UIBarButtonSystemItem )systemBarStyle
{
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:systemBarStyle target:self action:@selector(LeftSystemNavigationButtonClick)];
    self.navigationItem.leftBarButtonItem = bar;
}

- (void)createRightSystemNavigationItemWith:(UIBarButtonSystemItem )systemBarStyle
{
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:systemBarStyle target:self action:@selector(RightSystemNavigationButtonClick)];
    self.navigationItem.rightBarButtonItem = bar;
}

#pragma mark - 系统的样式的点击事件
-(void)LeftSystemNavigationButtonClick
{
    
}

-(void)RightSystemNavigationButtonClick
{
    
}

#pragma mark - popToVC
- (void)popToVC:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.navigationController popToViewController:viewController animated:animated];
}

#pragma mark - pushVC
- (void)pushVC:(UIViewController *)viewController animated:(BOOL)animated IsNeedLogin:(BOOL)isNeedLogin
{
    if (isNeedLogin) {
        if ([GetUserInfo getUserInfoModel].userId.length == 0) {
            [self pushToLoginVC];
            return;
        }
        if ([[GetUserInfo getUserInfoModel].roleType isEqualToString:@"1"]) {
            [ZTToastUtils showToastIsAtTop:NO Message:@"敬请期待" Time:3.0];
            return;
        }
    }
    [self.navigationController pushViewController:viewController animated:animated];
}

#pragma mark - popVC
- (void)popVCAnimated:(BOOL)animated
{
    [self.navigationController popViewControllerAnimated:animated];
}

#pragma mark - popToRootVC
- (void)popToRootVCAnimated:(BOOL) animated
{
    [self.navigationController popToRootViewControllerAnimated:animated];
}

#pragma mark - 跳转到登录页面
- (void)pushToLoginVC
{
    MineLoginViewController *mineLoginVC = [[MineLoginViewController alloc] init];
    [self pushVC:mineLoginVC animated:YES IsNeedLogin:NO];
    
}

#pragma mark - 刷新tableview的指定row
- (void)reloadTableView:(UITableView *)tableView Row:(NSInteger)row Section:(NSInteger)section
{
    //刷新-row
    NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:row inSection:section];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:reloadIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - 显示加载
- (void)showLoading
{
    [MBHUDManager showLoading];
}

#pragma mark - 隐藏加载
- (void)hideLoading
{
    [MBHUDManager hideAlert];
}

#pragma mark - tableView 的mj_header mj_footer结束加载动画
- (void)MJHeaderAndMJFooterEndRefreshWithTableView:(UITableView *)tableView
{
    if ([tableView.mj_header isRefreshing]) {
        [tableView.mj_header endRefreshing];
    }
    if ([tableView.mj_footer isRefreshing]) {
        [tableView.mj_footer endRefreshing];
    }
}

#pragma mark - collectionView 的mj_header mj_footer结束加载动画
- (void)MJHeaderAndMJFooterEndRefreshWithCollectionView:(UICollectionView *)collectionView
{
    if ([collectionView.mj_header isRefreshing]) {
        [collectionView.mj_header endRefreshing];
    }
    if ([collectionView.mj_footer isRefreshing]) {
        [collectionView.mj_footer endRefreshing];
    }
}

#pragma mark - 创建MJ_Header
- (MJRefreshGifHeader *)createMJRefreshGifHeaderWithSelector:(SEL)selector
{
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 1; i < 51; i++) {
        NSString *string = [NSString stringWithFormat:@"图层 %d", i];
        UIImage *image = [UIImage imageNamed:string];
        [imageArray addObject:image];
    }
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:selector];
    header.lastUpdatedTimeLabel.hidden = YES;
    
    [header setImages:imageArray duration:2 forState:MJRefreshStateIdle];
    [header setImages:imageArray duration:2 forState:MJRefreshStatePulling];
    [header setImages:imageArray duration:2 forState:MJRefreshStateRefreshing];
    return header;
}

#pragma mark - 创建MJ_Footer
- (MJRefreshBackGifFooter *)createMJRefreshBackGifFooterWithSelector:(SEL)selector
{
    NSArray *imageArray = [NSArray array];
    for (int i = 1; i < 51; i++) {
        NSString *string = [NSString stringWithFormat:@"图层 %d", i];
        UIImage *image = [UIImage imageNamed:string];
        imageArray = [NSArray arrayWithObject:image];
    }
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:selector];
    
    [footer setImages:imageArray duration:2 forState:MJRefreshStateIdle];
    [footer setImages:imageArray duration:2 forState:MJRefreshStatePulling];
    [footer setImages:imageArray duration:2 forState:MJRefreshStateRefreshing];
    return footer;
}

//解决, tableview下移后自动返回的bug
- (void)setScrollIndicatorInsetsForTabelView:(UITableView *)tableView ContentInset:(UIEdgeInsets)contentInset
{
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //解决刷新时候的偏移量(!!!没有下拉刷新的时候, 这两句不用写, 暂时没改)
        tableView.contentInset = contentInset;
        tableView.scrollIndicatorInsets = tableView.contentInset;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//解决, collectionView下移后自动返回的bug
- (void)setScrollIndicatorInsetsForCollectionView:(UICollectionView *)collectionView ContentInset:(UIEdgeInsets)contentInset
{
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //解决刷新时候的偏移量
        collectionView.contentInset = contentInset;
        collectionView.scrollIndicatorInsets = collectionView.contentInset;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//解决:push到有searchBar的页面, 返回后页面下移的问题
- (void)setConstraintsForSearchBar:(UISearchBar *)searchBar TitleView:(UIView *)navTitleView
{
    [NSLayoutConstraint activateConstraints:
     @[[searchBar.topAnchor constraintEqualToAnchor:navTitleView.topAnchor],
       [searchBar.leftAnchor constraintEqualToAnchor:navTitleView.leftAnchor constant:0],
       [searchBar.rightAnchor constraintEqualToAnchor:navTitleView.rightAnchor constant:0],
       [searchBar.bottomAnchor constraintEqualToAnchor:navTitleView.bottomAnchor],
       [searchBar.centerXAnchor constraintEqualToAnchor:navTitleView.centerXAnchor constant:0],]];
}

- (void)showTipAlertWithTitle:(NSString *)title
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [sureAction setValue:ZTOrangeColor forKey:@"titleTextColor"];
    [alertVC addAction:sureAction];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - 从16进制代码创建颜色
- (UIColor *)getColor:(NSString *)hexColor
{
    if([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    NSScanner *scanner = [NSScanner scannerWithString:hexColor];
    unsigned hexNum;
    
    if(![scanner scanHexInt:&hexNum]) {
        return nil;
    }
    
    return [self colorWithRGBHex:hexNum];
    
}

- (UIColor *)colorWithRGBHex:(UInt32)hex
{
    
    int r = (hex >>16) &0xFF;
    int g = (hex >>8) &0xFF;
    int b = (hex) &0xFF;
    return [UIColor colorWithRed:r /255.0f
                           green:g /255.0f
                            blue:b /255.0f
                           alpha:1.0f];
}

#pragma mark - 创建背景颜色的图片
- (UIImage *)createImageWithColor:(UIColor *)color Height:(CGFloat)height
{
    CGRect rect = CGRectMake(0.0f, 0.0f, ScreenWidth, height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}

#pragma mark - 获取系统时间（年月日）
- (NSString *)getSystemTimeWithFormatter:(NSString *)formatter
{
    NSDate *currentDate            = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    NSString *dateString           = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

#pragma mark 将身份证最后一位变为大写X
- (NSString *)changeTheLastLetterToUpperLetterWith:(NSString *)string
{
    if ([NSString validateIdentityCard:string]) {
        NSString * lastStr = [string substringWithRange:NSMakeRange(string.length - 1, 1)];
        if ([lastStr isEqualToString:@"x"]) {
            return [string stringByReplacingCharactersInRange:NSMakeRange(string.length - 1, 1) withString:@"X"];
        }
        return string;
    }
    return string;
}

- (NSAttributedString *)htmlStringToChangeWithString:(NSString *)string
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3; //设置行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    // ,NSParagraphStyleAttributeName:paragraphStyle
    return attributedString;
    
}

#pragma mark - 获取文本高度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_width:(CGFloat)str_width
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3; //设置行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;

    CGRect rect = [string boundingRectWithSize:CGSizeMake(str_width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil];
//    ,NSKernAttributeName:@1.5f
//
    return rect.size;
}

#pragma mark - 获取文本宽度
- (CGSize)getSizeWithString:(NSString *)string font:(UIFont *)font str_height:(CGFloat)str_height
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4; //设置行间距
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(8000, str_height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@1.5f} context:nil];
    
    return rect.size;
}

#pragma mark - 获取label文字的行数和每行的内容(array.count就是行数)
- (NSArray *)getLinesArrayOfStringInLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

#pragma mark - 获取lable中的点击位置的字符的index
- (CFIndex)getindexArrayOfStringInLabel:(UILabel *)label Point:(CGPoint)point
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label bounds];
    
    point = CGPointMake(point.x, rect.size.height - point.y);
    NSUInteger idx = NSNotFound;
    CTFontRef myFont = CTFontCreateWithName((CFStringRef)font.fontName,
                                            font.pointSize,
                                            NULL);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height +20));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    // 获得CTLine数组
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines =CFArrayGetCount(lines);
    //    NSLog(@"numberOfLines = %ld",(long)numberOfLines);
    
    CGPoint lineOrigins[numberOfLines];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);

        if (point.y > yMax) {
            break;
        }
        if (point.y >= yMin) {
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    return idx;
}

- (CFIndex)getindexArrayOfStringInTextView:(UITextView *)textView Point:(CGPoint)point
{
    NSString *text = [textView text];
    UIFont   *font = [textView font];
    CGRect    rect = [textView bounds];
    
    point = CGPointMake(point.x, rect.size.height - point.y);
    NSUInteger idx = NSNotFound;
    CTFontRef myFont = CTFontCreateWithName((CFStringRef)font.fontName,
                                            font.pointSize,
                                            NULL);
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height +GTH(40)));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    // 获得CTLine数组
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines =CFArrayGetCount(lines);
    //    NSLog(@"numberOfLines = %ld",(long)numberOfLines);
    
    CGPoint lineOrigins[numberOfLines];
    
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        if (point.y > yMax) {
            break;
        }
        if (point.y >= yMin) {
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    return idx;
}

#pragma mark - 格式化手机号(134****554)保留前3,后4
- (NSString *)formatPhoneNumber:(NSString *)phone
{
    if (phone.length == 0) {
        return @"";
    }
    if (phone.length < 3) {
        return phone;
    }
    NSString *first = [phone substringWithRange:NSMakeRange(0, 3)];
    NSString *last = [phone substringWithRange:NSMakeRange(phone.length - 4, 4)];
    
    return [NSString stringWithFormat:@"%@****%@", first, last];
    
    //    NSString *phoneStr = [phone stringByReplacingCharactersInRange:NSMakeRange(3, phone.length - 7) withString:@"****"];
    
}

#pragma mark - 格式化身份证号(21*********22)保留前2,后2
- (NSString *)formatCerNo:(NSString *)cerno
{
    if (cerno.length == 0) {
        return @"";
    }
    if (cerno.length < 2) {
        return cerno;
    }
    NSString *first = [cerno substringWithRange:NSMakeRange(0, 2)];
    NSString *last = [cerno substringWithRange:NSMakeRange(cerno.length - 2, 2)];
    
    return [NSString stringWithFormat:@"%@****%@", first, last];
    
    //    NSString *cerStr = [cerno stringByReplacingCharactersInRange:NSMakeRange(2, cerno.length - 2) withString:@"****"];
}

#pragma mark - 格式化邮箱地址(24****5@qq.com)
- (NSString *)formatEmail:(NSString *)email
{
    if (email.length == 0) {
        return @"";
    }
    if (email.length < 2) {
        return email;
    }
    NSString *firstStr = [email substringWithRange:NSMakeRange(0, 2)];
    NSString *index = [NSString string];
    
    for (int i = 0; i < email.length; i++) {
        NSString *temp = [email substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@"@"]) {
            index = [NSString stringWithFormat:@"%d", i];
        }
    }
    if (index.length == 0) {
        return email;
    }
    NSString *centerStr = [email substringWithRange:NSMakeRange([index intValue] - 1, 1)];
    NSString *lastStr = [email substringWithRange:NSMakeRange([index intValue], email.length - [index intValue])];
    
    NSString *emailStr = [NSString stringWithFormat:@"%@****%@%@", firstStr,centerStr, lastStr];
    return emailStr;
    
    //    NSString *cerStr = [email stringByReplacingCharactersInRange:NSMakeRange(2, email.length - 2) withString:@"****"];
    
    
}

//根据身份证号, 获取生日
- (NSString *)getBrithdayWithCerNo:(NSString *)cerNo
{
    if (cerNo.length < 15) {
        return @"";
    }
    NSString *string = [NSString string];
    if (cerNo.length == 15) {
        string = [NSString stringWithFormat:@"19%@", [cerNo substringWithRange:NSMakeRange(6, 6)]];
    }
    if (cerNo.length == 18) {
        string = [cerNo substringWithRange:NSMakeRange(6, 8)];
    }
    return [NSString newStringDateFromString:string];
}

//获取身份证性别
-(NSString *)getIdentityCardSex:(NSString *)numberStr
{
    //1-男, 0-女
    NSString *sex = nil;
    //获取18位 二代身份证  性别
    if (numberStr.length == 18) {
        int sexInt = [[numberStr substringWithRange:NSMakeRange(16, 1)] intValue];
        if (sexInt % 2 != 0) {
            sex = @"男";
        } else {
            sex = @"女";
        }
    }
    //  获取15位 一代身份证  性别
    if (numberStr.length == 15) {
        int sexInt = [[numberStr substringWithRange:NSMakeRange(14, 1)] intValue];
        if (sexInt % 2 != 0) {
            sex = @"男";
        } else {
            sex = @"女";
        }
        
    }
    return sex;
    
}

#pragma mark - 退出app
- (void)notExistCall
{
    exit(0);
    
}



@end

