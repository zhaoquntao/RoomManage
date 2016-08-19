//
//  LeftRoomNumberTableView.h
//  RoomManageDemo
//
//  Created by 赵群涛 on 16/8/18.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LeftRoomNumberTableView,LeftRoomNumberTableViewCell;

@protocol LeftRoomNumberTableViewDelegate <NSObject>
@optional
/// 监听tableView的滚动位移
- (void)selectTableView:(LeftRoomNumberTableView *)tableView DidScrollWithContentOffset:(CGPoint)contentOffset;

@end

@interface LeftRoomNumberTableView : UITableView

/**
 *  房间总数
 */
@property (nonatomic,strong) NSMutableArray *allRoomNumberArray;

//**代理*/
@property (nonatomic, weak) id<LeftRoomNumberTableViewDelegate> tableDelegate;

@end

@interface LeftRoomNumberTableViewCell : UITableViewCell

/**
 *  显示文字的标签
 */
@property (nonatomic,strong) UILabel *roomLabel;

//*线 */
@property (nonatomic, strong) UILabel *lineLabel;

@end