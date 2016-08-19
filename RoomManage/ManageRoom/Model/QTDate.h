//
//  QTDate.h
//  RoomManageDemo
//
//  Created by 赵群涛 on 16/8/18.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTDate : NSObject
/// 星期几
@property (nonatomic,copy) NSString *weekday;
/// 几号
@property (nonatomic,copy) NSString *day;

/// 模型数组
+ (NSArray *)dates;

@end
