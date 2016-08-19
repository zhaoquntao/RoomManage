//
//  QTManageViewController.m
//  RoomManageDemo
//
//  Created by 赵群涛 on 16/8/17.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "QTManageViewController.h"
#import "QTDateCollectionView.h"
#import "QTDateTool.h"
#import "QTSelectCollectionView.h"
#import "LeftRoomNumberTableView.h"
#import "QTRoom.h"
@interface QTManageViewController ()<QTDateCollectionViewDelegate,QTSelectCollectionViewDelegate,LeftRoomNumberTableViewDelegate>

@property (nonatomic,strong) UILabel *roomNoView;
/// 显示月份的视图
@property (nonatomic,strong) UILabel *totalNoView;
/// 显示房间号
@property (nonatomic,strong) UILabel *roomView;
/// 暂存上一个创建的roomView
@property (nonatomic,weak) UILabel *tempRoomView;
//底部
@property (nonatomic, strong)UIScrollView *backScrollView;

@property (nonatomic, strong)QTDateCollectionView *dateCollectionView;
/// 暂存当前月号
@property (nonatomic,assign) NSInteger tempDay;
/// 暂存当前月份
@property (nonatomic,weak) NSString *tempMonth;

/// 日期工具类
@property (nonatomic,strong) QTDateTool *dateTool;

/// 存储所有的SelectCollectionView
@property (nonatomic,strong) NSMutableArray *selectCollectionViewArr;
/// 显示在日期列表下的选项
@property (nonatomic,strong) QTSelectCollectionView *selectCollectionView;

/// 暂存当前被拖拽的日期选项
@property (nonatomic,weak) QTSelectCollectionView *currentSelectCollectionView;

/// 房间模型集合
@property (nonatomic,strong) NSArray *rooms;

/// 当前collectionView的偏移量
@property (nonatomic,assign) CGPoint currentContentOffset;
@end
// 列数
int columns = 7;
/// 是否是第一次添加房间
BOOL isFirstAddRoomView = YES;
// 控制器中显示view的宽、高
CGFloat viewWidth = 0;
CGFloat viewHeight = 0;
/// cell的宽
CGFloat itemW = 0;
/// collectionView的宽度
CGFloat collectionViewW = 0;
/// 日期栏高度曾大的倍数
CGFloat heightMultiple = 1.2;
/// 暂存当前日期
NSString *currentDay = nil;
@implementation QTManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    //1.设置导航条
    [self setNav];
    
    // 2. 计算Cell的大小
    [self calculateCellSize];

    [self prepareUI];
    
    
    [self loadRoomList];
 
}

#pragma mark  导航条
- (void)setNav {

    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    self.dateTool = [QTDateTool sharedInstance];
    self.dateTool.index = 0;
    currentDay = [self.dateTool getDay];
     self.navigationItem.title = [NSString stringWithFormat:@"%@年%@月",[self.dateTool getYear],[self.dateTool getMonth]];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"房间管理" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn sizeToFit];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];

}

// 计算cell的大小
- (void)calculateCellSize
{
    viewWidth = (WIDTH - columns + 2)/columns;
    viewHeight = viewWidth;
    collectionViewW = WIDTH - viewWidth * 2;
}

#pragma mark 准备UI
- (void)prepareUI {
    //1,添加子控件
    [self.view addSubview:self.roomNoView];
    [self.view addSubview:self.totalNoView];
    [self.view addSubview:self.dateCollectionView];
    [self.view addSubview:self.backScrollView];
    
    // 2.设置frame
    // 设置roomNoView、totalNoView
    CGFloat viewY = 0;
    self.roomNoView.frame = CGRectMake(0, viewY, viewWidth*2, viewHeight*heightMultiple*0.5);
    self.totalNoView.frame = CGRectMake(0, viewY + viewHeight * heightMultiple * 0.5, viewWidth*2, viewHeight*heightMultiple*0.5);
    // 设置collectionViewW
    self.dateCollectionView.frame = CGRectMake(viewWidth * 2, 0, collectionViewW, viewHeight*heightMultiple);
    itemW = (collectionViewW - 4)*0.2;
    self.dateCollectionView.itemSize = CGSizeMake(itemW, viewHeight*heightMultiple);
    
    
    CGFloat scrollViewY = CGRectGetMaxY(self.dateCollectionView.frame);
    CGFloat scrollViewH = HEIGHT - scrollViewY-64 ;
    self.backScrollView.frame = CGRectMake(0, scrollViewY, WIDTH , scrollViewH);
    self.selectCollectionView.frame = CGRectMake(0, 0, collectionViewW, scrollViewH);

}



// 添加日期选项
- (void)addSelectCollectionView {
    // 创建selectCollectionView
    self.selectCollectionView = [[QTSelectCollectionView alloc]init];
    // 指定代理
    self.selectCollectionView.SelectColDelegate = self;
    // 取消显示水平滚动指示器
    self.selectCollectionView.showsHorizontalScrollIndicator = NO;
    // 1. 添加子控件
    [self.backScrollView addSubview:self.selectCollectionView];
    // 2. 设置frame
    CGFloat selectColX = CGRectGetMaxX(self.roomView.frame);
    CGFloat selectColY = self.roomView.frame.origin.y;
    CGFloat selectColW = self.roomView.height;
    self.selectCollectionView.frame = CGRectMake(selectColX, selectColY, collectionViewW, selectColW);
   
    self.selectCollectionView.itemSize = CGSizeMake(itemW, viewHeight);
    // 添加到数组中
    [self.selectCollectionViewArr addObject:self.selectCollectionView];
}

#pragma mark 房间管理
- (void)rightBarButtonItemAction
{
    NSLog(@"房间管理,此处自己实现吧");
}

#pragma mark - 添加房间和日期选项表格
- (void)addRoomandSelectCellActionWithRooms:(NSArray *)rooms {
    for (QTRoom *room in rooms) {
        // 1. 添加房间
        [self addRoomViewWithRoom:room];
        // 2. 添加日期选项
        [self addSelectCollectionView];
    }
}

//  设置房间号
- (void)addRoomViewWithRoom:(QTRoom *)room
{
    
    self.roomView  = [UILabel labelWithTextColor:kUIColorFromRGB(0x666666) backgroundColor:kUIColorFromRGB(0xFFFFFF) fontSize:15];
    self.roomView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.roomView.layer.borderWidth = 1;
    [self.backScrollView addSubview:self.roomView];
    
    CGFloat roomViewY = 0;
    
    if (isFirstAddRoomView) {
        roomViewY = 1;
        isFirstAddRoomView = NO;
    }else {
        roomViewY = CGRectGetMaxY(self.tempRoomView.frame) + 1;
    }
    self.roomView.frame = CGRectMake(0, roomViewY, viewWidth*2, viewHeight);
    self.roomView.text = room.roomNo;
    // 暂存roomView为了下次创建时，可以获取到上一个roomView的frame
    self.tempRoomView = self.roomView;
    
    // 分割线
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, CGRectGetMinY(self.roomView.frame)-1, viewWidth*2, 1);
    lineView.backgroundColor = kUIColorFromRGB(0xf4f4f4);
    [self.backScrollView addSubview:lineView];
    
}




- (void)setRooms:(NSArray *)rooms {
    
    _rooms = rooms;
    NSInteger roomCount = rooms.count;
    self.backScrollView.contentSize = CGSizeMake(0, (viewHeight+1)*roomCount);
    self.roomNoView.text = @"房间号";
    
    self.totalNoView.text = [NSString stringWithFormat:@"共%ld间",(long)roomCount];
    
    // 显示日期选项表格
    [self addRoomandSelectCellActionWithRooms:rooms];
    // 加载首页数据
    [self loadBookedRoomList];
}


/**
 *  加载房间列表
 */
- (void)loadRoomList {
    __weak typeof(self) weakSelf = self;
    [self.selectCollectionViewArr removeAllObjects];
    
    [QTRoom loadRoomListSuccess:^(NSArray *rooms) {
        weakSelf.rooms = rooms;
    } failure:^(NSError *error) {
        
    }];
}

/**
 *  加载已经预订的房间数据
 */
- (void)loadBookedRoomList {
    for (QTRoom *room in self.rooms){
        //已经预定房间
        if (room.alreadyBook) {
            
            /**
             *  此处 从服务器得到 数据  便利数组 ,以下只是简单的示范
             */
            NSUInteger index = [self.rooms indexOfObject:room];
            QTSelectCollectionView *selectCollectionView = self.selectCollectionViewArr[index];
            NSString *accountingDate = room.bookDate;
            // 根据accountingDate返回预定的cell的index
            NSInteger indexQ = [self getSelectedCellIndexWithAccountingDate:accountingDate];
            [selectCollectionView.SelectedCellIndexs addObject:@(indexQ)];
            
            NSDictionary *AccountingIdDict = @{@"bookDate":room.roomNo,
                                               @"index":@(index)
                                               };
            [selectCollectionView.SelectedCellAccountingIds addObject:AccountingIdDict];
            [selectCollectionView reloadData];
        }
    }
    
    // 回到上次位置
    self.dateCollectionView.contentOffset = self.currentContentOffset;
    for (QTSelectCollectionView *selectCollectionView in self.selectCollectionViewArr) {
        selectCollectionView.contentOffset = self.currentContentOffset;
    }
    
}


#pragma mark - ZLTDateCollectionViewDelegate方法
/// 根据dateCollectionView的滚动，使选项selectCollectionVie同步滚动
- (void)dateCollectionView:(QTDateCollectionView *)collectionView DidScrollWithContentOffset:(CGPoint)contentOffset
{
    self.currentContentOffset = contentOffset;
    // 调用监听collectionView滚动的方法
    [self collectionViewDidScrollWithContentOffset:contentOffset];

    for (QTSelectCollectionView *selectCollectionView in self.selectCollectionViewArr) {
        selectCollectionView.contentOffset = contentOffset;
    }
}

#pragma mark - ZLTSelectCollectionViewDelegate方法
/// 根据selectCollectionVie的滚动，使显示日期的dateCollectionView同步滚动
- (void)selectCollectionView:(QTSelectCollectionView *)collectionView DidScrollWithContentOffset:(CGPoint)contentOffset
{
    self.dateCollectionView.contentOffset = contentOffset;
    // 调用监听collectionView滚动的方法
    [self collectionViewDidScrollWithContentOffset:contentOffset];
}

/// 监听选中的cell
- (void)selectCollectionView:(QTSelectCollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index {
    
    
    
    self.currentSelectCollectionView = collectionView;
    int accountingId = -110;
    for (NSDictionary *dict in self.currentSelectCollectionView.SelectedCellAccountingIds) {
        NSInteger indexDict = [dict[@"index"] integerValue];
        if (indexDict == index) {
            accountingId = [dict[@"accountingId"] intValue];
        }
    }
//    NSUInteger indexRoom = [self.selectCollectionViewArr indexOfObject:collectionView];
    
    
    
}

#pragma mark - 监听collectionView的滚动
/// 监听collectionView滚动的方法，为了实现随着滚动切换月份
- (void)collectionViewDidScrollWithContentOffset:(CGPoint)contentOffset
{
    NSInteger index = ((NSInteger)contentOffset.x - itemW*0.5)/ itemW;
    self.dateTool.index = index;
    NSString  *month = [self.dateTool getMonth];
    // 如果当前月份和暂存的上一个月份不同，则更新
    if (![self.tempMonth isEqualToString:month]) {
        //        self.totalNoView.text = month;
        self.navigationItem.title = [NSString stringWithFormat:@"%@年%@月",[self.dateTool getYear],month];
    }
    
    self.tempMonth = month;
}


/**
 *  根据accountingDate返回预定的cell的index
 */
- (NSInteger)getSelectedCellIndexWithAccountingDate:(NSString *)accountingDate
{
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat  = @"yyyy-MM-dd";
    NSDate *selectedDate = [formatter dateFromString:accountingDate];
    NSString *currentDateStr = [formatter stringFromDate:currentDate];
    
    NSInteger index = (NSInteger)[selectedDate timeIntervalSinceDate:currentDate]/(24*60*60);
    if ([currentDateStr isEqualToString:accountingDate]) {
        return 0;
    }
    if (index<0) {
        return -1;
    }
    return index+1;
}




- (UILabel *)roomNoView
{
    if (!_roomNoView) {
        _roomNoView = [UILabel labelWithTextColor:kUIColorFromRGB(0x999999) backgroundColor:kUIColorFromRGB(0xFFFFFF) fontSize:12];
       
    }
    return _roomNoView;
}

- (UILabel *)totalNoView
{
    if (!_totalNoView) {
        _totalNoView = [UILabel labelWithTextColor:kUIColorFromRGB(0x666666) backgroundColor:kUIColorFromRGB(0xFFFFFF) fontSize:16];
        
    }
    return _totalNoView;
}


- (QTDateCollectionView *)dateCollectionView
{
    if (!_dateCollectionView) {
        _dateCollectionView = [[QTDateCollectionView alloc]init];
        // 取消显示水平滚动指示器
        _dateCollectionView.showsHorizontalScrollIndicator = NO;
        // 指定代理
        _dateCollectionView.dateDelegate = self;
        
        
    }
    return _dateCollectionView;
}

- (UIScrollView *)backScrollView {
    if (!_backScrollView) {
        self.backScrollView = [[UIScrollView alloc]init];
        self.backScrollView.showsVerticalScrollIndicator  = NO;
        
        self.backScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _backScrollView;
}

- (NSMutableArray *)selectCollectionViewArr
{
    if (!_selectCollectionViewArr) {
        _selectCollectionViewArr = [NSMutableArray array];
    }
    return _selectCollectionViewArr;
}


@end
