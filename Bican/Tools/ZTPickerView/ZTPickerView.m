//
//  ZTPickerView.m
//  Bican
//
//  Created by 迟宸 on 2017/12/28.
//  Copyright © 2017年 ZT. All rights reserved.
//

#import "ZTPickerView.h"

@interface ZTPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) NSInteger componentsCount;

@property (nonatomic, strong) NSMutableArray *dataSource;//年月日大数组
@property (nonatomic, strong) NSMutableArray *yearArray;//年数组

@property (nonatomic, assign) NSInteger selectedIndex;//选中的下标
@property (nonatomic, strong) NSString *selectedContent;//选中的内容

@property (nonatomic, assign) NSInteger selelctedYear;//选中的年份
@property (nonatomic, assign) NSInteger selectedMonth;//选中的月份
@property (nonatomic, assign) NSInteger selectedDay;//选中的日

@property (nonatomic, strong) NSString *startStr;//记录开始时间
@property (nonatomic, strong) NSString *endStr;//记录结束时间

@end

@implementation ZTPickerView

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)yearArray
{
    if (!_yearArray) {
        _yearArray = [NSMutableArray array];
    }
    return _yearArray;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubViews];
    }
    return self;
}

- (void)setPickerToNone
{
    [_pickerView selectRow:0 inComponent:0 animated:NO];
    [_pickerView selectRow:0 inComponent:1 animated:NO];
    [_pickerView selectRow:0 inComponent:2 animated:NO];
}

- (void)setPickerViewWithStartDate:(NSString *)startDate
                           EndDate:(NSString *)endDate
                             Title:(NSString *)title
                   ComponentsCount:(NSInteger)componentsCount
{
    _startStr = startDate;
    _endStr = endDate;
    _titleLabel.text = title;
    _componentsCount = componentsCount;
    
    [self getAllArray];
    
    CGFloat picker_width = (ScreenWidth - GTW(28) * 2) - GTW(30) - GTW(136);

    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(GTW(136) + GTW(30), 0,  picker_width, GTH(296))];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
    }
    
    if (startDate.length == 0 || endDate.length == 0) {
        [self setPickerToNone];
        return;
    }
    [_pickerView reloadAllComponents];
    [_pickerView selectRow:self.selelctedYear inComponent:0 animated:NO];
    [_pickerView selectRow:self.selectedMonth inComponent:1 animated:NO];
    [_pickerView selectRow:self.selectedDay inComponent:2 animated:NO];


}

#pragma mark -- 初始化titleLabel
- (void)createSubViews
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = ZTTextGrayColor;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = FONT(30);
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.height.equalTo(self);
        make.width.mas_equalTo(GTW(136));
    }];
    
}

#pragma mark -- UIPickerViewDelegate,UIPickerViewDataSource
//component数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.componentsCount;
}

//row数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.yearArray.count;
        
    } else if (component == 1) {
        NSMutableArray *monthArray = [self getMonthArrayWithYear:self.yearArray[self.selelctedYear]];
        return monthArray.count;
        
        
    } else {
        NSMutableArray *monthArray = [self getMonthArrayWithYear:self.yearArray[self.selelctedYear]];
        if (self.selectedMonth > monthArray.count - 1) {
            return 0;
        }
        NSMutableArray *dayArray = [self getDayArrayWithYear:self.yearArray[self.selelctedYear] Month:monthArray[self.selectedMonth]];
        return dayArray.count;
    }
    
}

//component的宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return self.pickerView.frame.size.width / self.componentsCount;
}

//rowHeight
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return GTH(90);
}

//row的样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = ZTTitleColor;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor whiteColor];
        pickerLabel.font = FONT(30);
        pickerLabel.adjustsFontSizeToFitWidth = YES;
    }
    //设置内容
    if (component == 0) {
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    if (component == 1) {
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    if (component == 2) {
        pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
    
    return pickerLabel;
}

//设置row的数据
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        if (row >= self.yearArray.count) {
            return nil;
        }
        return self.yearArray[row];
        
    } else if (component == 1) {
        NSMutableArray *monthArray = [self getMonthArrayWithYear:self.yearArray[self.selelctedYear]];
        if (row >= monthArray.count) {
            return nil;
        }
        return monthArray[row];
        
    } else {
        NSMutableArray *monthArray = [self getMonthArrayWithYear:self.yearArray[self.selelctedYear]];
        if (self.selectedMonth > monthArray.count - 1) {
            return nil;
        }
        NSMutableArray *dayArray = [self getDayArrayWithYear:self.yearArray[self.selelctedYear] Month:monthArray[self.selectedMonth]];
        if (self.selectedDay > dayArray.count - 1) {
            return nil;
        }
        if (row >= dayArray.count) {
            return nil;
        }
        return dayArray[row];
    }
    
}

//选中
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //省市区
    if (component == 0) {
        self.selelctedYear = row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:self.selectedMonth inComponent:1 animated:YES];
        [pickerView reloadComponent:2];
        [pickerView selectRow:self.selectedDay inComponent:2 animated:YES];
        
    } else if (component == 1) {
        self.selectedMonth = row;
        self.selectedDay = [pickerView selectedRowInComponent:2];
        [pickerView reloadComponent:2];
        [pickerView selectRow:self.selectedDay inComponent:2 animated:YES];
        
    }
    //协议
    if ([self.delegate respondsToSelector:@selector(selectedPickerView:WithContent:)]) {
        
        self.selelctedYear = [self.pickerView selectedRowInComponent:0];
        self.selectedMonth = [self.pickerView selectedRowInComponent:1];
        self.selectedDay = [self.pickerView selectedRowInComponent:2];
        
        NSMutableArray *monthArray = [self getMonthArrayWithYear:self.yearArray[self.selelctedYear]];
        if (self.selectedMonth > monthArray.count - 1) {
            self.selectedMonth = monthArray.count - 1;
        }
        NSMutableArray *dayArray = [self getDayArrayWithYear:self.yearArray[self.selelctedYear] Month:monthArray[self.selectedMonth]];
        if (self.selectedDay > dayArray.count - 1) {
            self.selectedDay = dayArray.count - 1;
        }
        //选中的内容
        NSString *year = [NSString string];
        NSString *month = [NSString string];
        NSString *day = [NSString string];

        if (self.selelctedYear != 0) {
            year = self.yearArray[self.selelctedYear];
        }
        if (self.selectedMonth != 0) {
            month = monthArray[self.selectedMonth];
        }
        if (self.selectedDay != 0) {
            day = dayArray[self.selectedDay];
        }
        _selectedContent = [NSString stringWithFormat:@"%@%@%@", year, month, day];
        [self.delegate selectedPickerView:self WithContent:_selectedContent];
    }
}

#pragma mark - 获取两个时间段之间的所有日期
- (void)getAllArray
{
    NSDateFormatter *formatterOld = [[NSDateFormatter alloc] init];
    [formatterOld setDateFormat:@"yyyyMMdd"];
    NSDate *startDate = [formatterOld dateFromString:self.startStr];
    NSDate *endDate = [formatterOld dateFromString:self.endStr];
    
    long long nowTime = [startDate timeIntervalSince1970], //开始时间
    endTime = [endDate timeIntervalSince1970],//结束时间
    dayTime = 24*60*60,
    
    time = nowTime - nowTime % dayTime;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    
    [self.yearArray addObject:@"--"];

    while (time <= endTime) {
        time += dayTime;
        NSString *string = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
        [self.dataSource addObject:string];
        
        NSString *yearStr = [string substringWithRange:NSMakeRange(0, 4)];
        if (![self.yearArray containsObject:yearStr]) {
            [self.yearArray addObject:yearStr];
        }
    }
}

#pragma mark - 根据选择的年份, 获取所有的月份
- (NSMutableArray *)getMonthArrayWithYear:(NSString *)year
{
    NSMutableArray *array = [NSMutableArray array];
    
    [array addObject:@"--"];

    for (int i = 0; i < self.dataSource.count; i++) {
        NSString *date = self.dataSource[i];
        NSString *yearNew = [date substringWithRange:NSMakeRange(0, 4)];
        if ([yearNew isEqualToString:year]) {
            NSString *month = [date substringWithRange:NSMakeRange(4, 2)];
            if (![array containsObject:month]) {
                [array addObject:month];
            }
        }
    }
    return array;
}


#pragma mark - 根据选择的年份和月份, 获取所有的日期
- (NSMutableArray *)getDayArrayWithYear:(NSString *)year Month:(NSString *)month
{
    NSMutableArray *array = [NSMutableArray array];
    
    [array addObject:@"--"];

    for (int i = 0; i < self.dataSource.count; i++) {
        NSString *date = self.dataSource[i];
        NSString *yearNew = [date substringWithRange:NSMakeRange(0, 4)];
        NSString *monthNew = [date substringWithRange:NSMakeRange(4, 2)];
        if ([yearNew isEqualToString:year] && [monthNew isEqualToString:month]) {
            NSString *day = [date substringWithRange:NSMakeRange(date.length - 2, 2)];
            if (![array containsObject:day]) {
                [array addObject:day];
            }
        }
    }
    return array;
}

@end
