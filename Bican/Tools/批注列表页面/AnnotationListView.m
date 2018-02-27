//
//  AnnotationListView.m
//  Bican
//
//  Created by 迟宸 on 2018/1/18.
//  Copyright © 2018年 ZT. All rights reserved.
//

#import "AnnotationListView.h"
#import "AnnotationListTableViewCell.h"
#import "ArticleAnnotationModel.h"//批注

@interface AnnotationListView () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AnnotationListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    self.backView = [[UIView alloc] init];
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.5;
    [self addSubview:self.backView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setBackgroundColor:[UIColor whiteColor]];
    self.cancelButton.layer.cornerRadius = GTH(60) / 2;
    self.cancelButton.layer.masksToBounds = YES;
    [self.cancelButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(GTW(30));
        make.bottom.equalTo(self.mas_bottom).offset(GTH(-30) - TABBAR_HEIGHT);
        make.width.height.mas_equalTo(GTH(60));
    }];

    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    
    [self setScrollIndicatorInsetsForTabelView:self.tableView ContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_top).offset(NAV_HEIGHT);
        make.bottom.equalTo(self.cancelButton.mas_top).offset(GTH(-30));
    }];
    
}

- (void)cancelButtonClick
{
    if ([self.delegate respondsToSelector:@selector(cancelButtonAction)]) {
        [self.delegate cancelButtonAction];
    }
}


#pragma mark - DZNEmptyDataSetSource协议方法
//设置title
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"什么都没有";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:FONT(28), NSForegroundColorAttributeName:ZTTitleColor, NSParagraphStyleAttributeName:paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"no_neirong"];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultCellID = @"annotationListCell";
    AnnotationListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultCellID];
    if (!cell) {
        cell = [[AnnotationListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    if (self.dataSourceArray.count == 0) {
        return cell;
    }
    ArticleAnnotationModel *model = self.dataSourceArray[indexPath.row];
    
    NSString *name = [NSString stringWithFormat:@"%@(%@%@)批注:", model.nickname, model.firstname, model.role];
    [cell setAnnotationListCellWithName:name
                                   Page:[NSString stringWithFormat:@"\"%@\"", model.sourceTxt]
                                Content:model.content];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ArticleAnnotationModel *model = self.dataSourceArray[indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@(%@%@)批注:", model.nickname, model.firstname, model.role];
    NSString *page = model.sourceTxt;
    NSString *content = model.content;
    
    CGSize nameSize = [self getSizeWithString:name font:FONT(26) str_width:ScreenWidth - GTW(30) * 4];
    
    CGSize pageSize = [self getSizeWithString:page font:FONT(24) str_width:ScreenWidth - GTW(30) * 4];

    CGSize contentSize = [self getSizeWithString:content font:FONT(24) str_width:ScreenWidth - GTW(30) * 4];

    return GTH(30) * 4 + GTH(20) + contentSize.height + pageSize.height + nameSize.height;
    
}


@end
