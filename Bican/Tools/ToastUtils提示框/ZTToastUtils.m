//
//  ZTToastUtils.m
//  Bican
//
//  Created by 迟宸 on 2018/1/3.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "ZTToastUtils.h"

@implementation ZTToastUtils

#pragma mark - 显示提示视图
+ (void)showToastIsAtTop:(BOOL)isAtTop Message:(NSString *)message Time:(CGFloat)time
{
    [self show:message atTop:isAtTop showTime:time];
}

static UILabel *toastView = nil;
+ (void)show:(NSString *)message atTop:(BOOL)atTop showTime:(float)showTime
{
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:message atTop:atTop showTime:showTime];
        });
        return;
    }
    @synchronized(self){
        if (toastView == nil) {
            toastView = [[UILabel alloc] init];
            toastView.backgroundColor = ZTTitleColor;
            toastView.textColor = [UIColor whiteColor];
            toastView.font = FONT(30);
            toastView.layer.masksToBounds = YES;
            toastView.layer.cornerRadius = 6.0f;
            toastView.textAlignment = NSTextAlignmentCenter;
            toastView.numberOfLines = 0;
//            toastView.attributedText = [UILabel setLabelSpace:toastView withValue:message withFont:FONT(30)];
            toastView.alpha = 0;
            toastView.lineBreakMode = NSLineBreakByCharWrapping;
            [[UIApplication sharedApplication].keyWindow addSubview:toastView];
        }
    }
    if (toastView.superview != [UIApplication sharedApplication].keyWindow) {
        [toastView removeFromSuperview];
        [[UIApplication sharedApplication].keyWindow addSubview:toastView];
    }
    
    CGFloat width = [self stringText:message font:GTH(30) isHeightFixed:YES fixedValue:30];
    CGFloat height = 30;
    if (width > ScreenWidth - 40) {
        width = ScreenWidth - 40;
        height = [self stringText:message font:GTH(30) isHeightFixed:NO fixedValue:width];
    }

    CGRect frame = CGRectMake((ScreenWidth - width) / 2, atTop ? ScreenHeight * 0.15 - height : ScreenHeight * 0.85 - height, width, height);
    toastView.alpha = 0.9;
    toastView.text = message;
    toastView.frame = frame;

    [UIView animateWithDuration:showTime animations:^{
        toastView.alpha = 0;
    } completion:^(BOOL finished) {

    }];
}

//根据字符串长度获取对应的宽度或者高度
+ (CGFloat)stringText:(NSString *)text font:(CGFloat)font isHeightFixed:(BOOL)isHeightFixed fixedValue:(CGFloat)fixedValue
{
    CGSize size;
    if (isHeightFixed) {
        size = CGSizeMake(MAXFLOAT, fixedValue);
    } else {
        size = CGSizeMake(fixedValue, MAXFLOAT);
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4; //设置行间距
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    CGSize resultSize;
    //返回计算出的size
    resultSize = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@1.5f} context:nil].size;
    
    if (isHeightFixed) {
        return resultSize.width;
    } else {
        return resultSize.height;
    }
    
}

@end
