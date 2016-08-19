//
//  UILabel+QTCategory.m
//  RoomManageDemo
//
//  Created by 赵群涛 on 16/8/17.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "UILabel+QTCategory.h"

@implementation UILabel (QTCategory)
+ (instancetype)labelWithTextColor:(UIColor *)textColor backgroundColor:(UIColor *)bkgColor fontSize:(CGFloat)size
{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:size];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = textColor;
    if (bkgColor!=nil) {
        label.backgroundColor = bkgColor;
    }
    return label;
}
@end
