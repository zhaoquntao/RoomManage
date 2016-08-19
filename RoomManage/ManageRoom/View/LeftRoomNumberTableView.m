//
//  LeftRoomNumberTableView.m
//  RoomManage
//
//  Created by 赵群涛 on 16/8/18.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "LeftRoomNumberTableView.h"
#import "QTRoom.h"
@interface LeftRoomNumberTableView()<UITableViewDelegate,UITableViewDataSource>




@end


@implementation LeftRoomNumberTableView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        
        
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allRoomNumberArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"LeftRoomNumberTableViewCell";
    LeftRoomNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[LeftRoomNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    QTRoom *model = [[QTRoom alloc]init];
    model = self.allRoomNumberArray[indexPath.row];
    cell.roomLabel.text = model.roomNo;
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.tableDelegate respondsToSelector:@selector(selectTableView:DidScrollWithContentOffset:)]) {
        [self.tableDelegate selectTableView:self DidScrollWithContentOffset:scrollView.contentOffset];
        
    }
}


- (NSMutableArray *)allRoomNumberArray {
    if (!_allRoomNumberArray) {
        self.allRoomNumberArray = [NSMutableArray arrayWithCapacity:1];
        
    }
    return _allRoomNumberArray;
}

@end

@implementation LeftRoomNumberTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI {
   
    
    self.roomLabel.frame = CGRectMake(0, 0, (WIDTH - 7 + 2)/7 * 2, 50);
//    self.roomLabel.frame = self.contentView.bounds;
    self.lineLabel.frame = CGRectMake(0, 49.5, self.roomLabel.frame.size.width, 0.5);
    
     [self.contentView addSubview:self.roomLabel];
    [self.contentView addSubview:self.lineLabel];
}

- (UILabel *)roomLabel {
    if (!_roomLabel) {
        self.roomLabel= [UILabel labelWithTextColor:[UIColor whiteColor] backgroundColor:kUIColorFromRGB(0xffb400) fontSize:16];
        self.roomLabel.textAlignment = NSTextAlignmentCenter;
        self.roomLabel.textColor = [UIColor redColor];
        
        
    }
    return _roomLabel;
}


- (UILabel *)lineLabel {
    if (!_lineLabel) {
        self.lineLabel = [[UILabel alloc] init];
        self.lineLabel.backgroundColor = kUIColorFromRGB(0xd8d8d8);
    }
    return _lineLabel;
}

@end