//
//  ADLOrderVCAddressView.m
//  lockboss
//
//  Created by bailun91 on 2019/9/19.
//  Copyright © 2019年 adel. All rights reserved.
//

#import "ADLOrderVCAddressView.h"

@interface ADLOrderVCAddressView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UITableView *table;

@end

@implementation ADLOrderVCAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubviews];
    }
    return self;
}
- (void)setupSubviews {
    self.focusIndex = 0;
    
    //日期label
    UILabel *titLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20+SCREEN_WIDTH/4, 40)];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.font = [UIFont systemFontOfSize:15.5];
    titLab.textColor = [UIColor blackColor];
//    titLab.text = [NSString stringWithFormat:@"今天 (%@)", [self getWeekDayFordate:[[self getCurrentTimestamp] doubleValue]]];
    [self addSubview:titLab];
    self.dateLabel = titLab;
    
    
    
    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 20+SCREEN_WIDTH/4, 240+BOTTOM_H)];
    grayView.backgroundColor = SEPARATOR_COLOR;
    [self addSubview:grayView];
    
    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(40+SCREEN_WIDTH/4, 0, SCREEN_WIDTH*3/4-40, 280)];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 40;
    [self addSubview:tableView];
    self.table = tableView;
}
- (NSString *)getFirstSendTime {
    NSString *timeSp = [self getCurrentTimestamp];//获取当前时间戳
    NSString *timeStr = [self getTimeFromTimestamp:timeSp.doubleValue+1800];
    return [timeStr substringWithRange:NSMakeRange(timeStr.length-5, 5)];
}
#pragma mark --- 刷新view
- (void)updateViewInfos {
    self.dateLabel.text = [NSString stringWithFormat:@"今天 (%@)", [self getWeekDayFordate:[[self getCurrentTimestamp] doubleValue]]];
    
    self.itemArray = [self getItemArray];
    [self.table reloadData];
}

- (NSMutableArray *)getItemArray {
    NSMutableArray *itemArr = [NSMutableArray array];
    
    NSString *timeSp = [self getCurrentTimestamp];//获取当前时间戳
    NSString *timeStr = [self getTimeFromTimestamp:timeSp.doubleValue+1800];
   
    //add the first object
    [itemArr addObject:[timeStr substringWithRange:NSMakeRange(timeStr.length-5, 5)]];
    
    NSString *firstTimeStr = [timeStr substringWithRange:NSMakeRange(timeStr.length-5, 5)];
    NSString *secTimeStr = [NSString stringWithFormat:@"%@0", [firstTimeStr substringWithRange:NSMakeRange(0, 4)]];
    
    //新时间戳
    NSInteger newTimesp = [self timeSwitchTimestamp:[NSString stringWithFormat:@"%@%@", [timeStr substringWithRange:NSMakeRange(0, 11)], secTimeStr] andFormatter:@"YYYY-MM-dd HH:mm"];
    
    //add the second object
    NSString *secObj = [self getTimeFromTimestamp:newTimesp+1800];
    [itemArr addObject:[secObj substringWithRange:NSMakeRange(secObj.length-5, 5)]];
    
    NSInteger timeStamp = newTimesp+1800;
    for (int i = 0 ; i < 5; i++) {
        timeStamp += 1200;
        NSString *newObj = [self getTimeFromTimestamp:timeStamp];
        [itemArr addObject:[newObj substringWithRange:NSMakeRange(secObj.length-5, 5)]];
    }
    
    return itemArr;
}
#pragma mark --- 获取星期日期
//获取星期
- (NSString *)getWeekDayFordate:(NSTimeInterval)data {
    NSArray *weekday = [NSArray arrayWithObjects:[NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}
#pragma mark --- 获取当前时间戳
- (NSString *)getCurrentTimestamp {
    NSDate *date = [NSDate date];//现在时间
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"当前时间戳timeSp: %@",timeSp);//时间戳的值
    
    return timeSp;
}
#pragma mark --- 获取当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];//设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beiji"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:datenow];//----------将nsdate按formatter格式转成nsstring
    NSLog(@"当前时间nowtimeStr = %@", nowtimeStr);
    
    return nowtimeStr;
}

#pragma mark ---- 将时间戳转换成时间
- (NSString *)getTimeFromTimestamp:(double)time {
    NSLog(@"time : %zd", (NSInteger)time);
    
    //将对象类型的时间转换为NSDate类型
    NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:time];
    
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:myDate];
    NSLog(@"时间timeSp : %@",timeStr);//时间
    
    return timeStr;
}
#pragma mark - 将时间转化成时间戳
- (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    //(@"YYYY-MM-dd HH:mm:ss")设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:format];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];
    
    //将字符串按formatter转成nsdate
    NSDate *date = [formatter dateFromString:formatTime];
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    
    return timeSp;
}

#pragma mark ------ 按钮点击事件 ------
- (void)clickButtonAction:(UIButton *)sender {
    
}


#pragma mark ------ UITableView ------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (orderCell == nil) {
        orderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    } else {
        while ([orderCell.contentView.subviews lastObject] != nil) {
            [(UIView*)[orderCell.contentView.subviews lastObject] removeFromSuperview];  //删除并进行重新分配
        }
    }
    
    //自定义view
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*3/4-40, 40)];
    
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 40)];
    titleLab.textAlignment = NSTextAlignmentLeft;
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = [UIColor grayColor];
    titleLab.text = self.itemArray[indexPath.row];
    [content addSubview:titleLab];
    
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3/4-80, 10, 20, 20)];
    icon.image = [UIImage imageNamed:@"icon_xuanzhong"];
    icon.hidden = YES;
    [content addSubview:icon];
    
    if (indexPath.row == self.focusIndex) {//被选中index
        titleLab.textColor = COLOR_E0212A;
        icon.hidden = NO;
    }
    
    if (indexPath.row == 0) {
        titleLab.text = [NSString stringWithFormat:@"大约%@送达", self.itemArray[indexPath.row]];
    }
    
    
    [orderCell.contentView addSubview:content];
    
    return orderCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.focusIndex = indexPath.row;
    
    //刷新cell
    [self.table reloadData];
    self.didSelectedRowBlock(indexPath.row, self.itemArray[indexPath.row]);
}


@end
