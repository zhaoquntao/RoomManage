//
//  QTDateTool.h
//  RoomManage
//
//  Created by 赵群涛 on 16/8/17.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTDateTool : NSObject

/// 距离今天往后第几天
@property (nonatomic,assign) NSInteger index;

/// 获取当前年份
- (NSString *)getYear;

/// 获取当前月份
- (NSString *)getMonth;

/// 获取当前天（几号）
- (NSString *)getDay;

/// 获取当前日期，形式"yyyy-MM-dd"
//- (NSString *)getCurrentDate;

/// 获取当前星期几
- (NSString *)getWeekday;

/// 单例
+ (instancetype)sharedInstance;

@end
