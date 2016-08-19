//
//  QTRoom.m
//  RoomManage
//
//  Created by 赵群涛 on 16/8/18.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "QTRoom.h"

@implementation QTRoom

+ (void)loadRoomListSuccess:(void(^)(NSArray *rooms))success failure:(void(^)(NSError *error))failure {
  
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"RoomList" ofType:@"plist"];
   
    NSArray *commonList = [[NSArray alloc]initWithContentsOfFile:path];
    
    NSMutableArray *rooms = [NSMutableArray array];
    for (NSDictionary *dict in commonList) {
        QTRoom *room = [[QTRoom alloc]init];
        [room setValuesForKeysWithDictionary:dict];
        [rooms addObject:room];
    }
    success([rooms copy]);
}

@end
