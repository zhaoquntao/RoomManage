//
//  QTDateTool.m
//  RoomManageDemo
//
//  Created by 赵群涛 on 16/8/17.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "QTDateTool.h"

@implementation QTDateTool

/// 单例
+ (instancetype)sharedInstance
{
    return [[self alloc]init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

/// 获取当前年份
- (NSString *)getYear
{
    return [self getDate][0];
}

/// 获取当前月份
- (NSString *)getMonth
{
    return [self getDate][1];
}

/// 获取当前天（几号）
- (NSString *)getDay
{
    return [self getDate][2];
}

/// 获取分割后的当前日期，形式"yyyy","MM","dd" WithIndex:(NSUInteger)index
- (NSArray *)getDate{
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60*60*24*self.index];
    //    NSLog(@"--index:%zd",self.index);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat  = @"yyyy-MM-dd";
    //    formatter.dateFormat =  [date getDayOfWeekShortString];
    NSString *dateStr = [formatter stringFromDate:date];
    //    NSLog(@"%@",dateStr);
    return [dateStr componentsSeparatedByString:@"-"];
}

/// 获取当前周几
- (NSString *)getWeekday
{
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[[self getDay] integerValue]];
    NSString *monthStr = [self getDate][1];
    [_comps setMonth:[monthStr integerValue]];
    [_comps setYear:[[self getYear] integerValue]];

    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSCalendarUnitWeekday fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday]-1; // 此处结果多了一天，减1，得到当前是周几}
    
    // 转为字符串
    NSString *weekdayStr = nil;
    //    NSLog(@"_weekday:%zd",_weekday);
    switch (_weekday) {
        case 1:
            weekdayStr = @"周一";
            break;
        case 2:
            weekdayStr = @"周二";
            break;
        case 3:
            weekdayStr = @"周三";
            break;
        case 4:
            weekdayStr = @"周四";
            break;
        case 5:
            weekdayStr = @"周五";
            break;
        case 6:
            weekdayStr = @"周六";
            break;
        case 0:
            weekdayStr = @"周日";
            break;
    }
    //     NSLog(@"_weekday::%@",weekdayStr);
    return weekdayStr;
}


@end
