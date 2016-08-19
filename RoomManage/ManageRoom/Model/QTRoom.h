//
//  QTRoom.h
//  RoomManageDemo
//
//  Created by 赵群涛 on 16/8/18.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTRoom : NSObject

//**房间号/
@property (nonatomic,copy) NSString *roomNo;


//**是否已经预定/

@property (nonatomic, assign, getter=isAlreadyBook) BOOL alreadyBook;
//**预定日期/
@property (nonatomic, copy)NSString *bookDate;

/// 获取房间模型数组
+ (void)loadRoomListSuccess:(void(^)(NSArray *rooms))success failure:(void(^)(NSError *error))failure;

@end
