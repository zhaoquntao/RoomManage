# RoomManage
RoomManage(农家乐房间管理)
RoomManageDemo

RoomManageDemo(农家乐房间管理)



农家乐房间管理 ,方便农家乐主人管理自己的房间.

上部是日期显示 (以当前日期为开始往后 60天)

左侧是 房间号 ,

可以上下,左右滑动,方便管理农家乐的预定情况.

用到的控件: UIScrollView 和 CollectionView

主要代码

QTSelectCollectionView

 @protocol QTSelectCollectionViewDelegate <NSObject>
 @optional
 @protocol QTSelectCollectionViewDelegate <NSObject>
 @optional
 /// 监听dateCollectionView的滚动位移
 - (void)selectCollectionView:(QTSelectCollectionView *)collectionView DidScrollWithContentOffset:(CGPoint)contentOffset;
 // 监听选中某个cell
 - (void)selectCollectionView:(QTSelectCollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index;

 @end

 @interface QTSelectCollectionView : UICollectionView

 /// 所有被选中cell的索引
 @property (nonatomic,strong) NSMutableArray *SelectedCellIndexs;
 /// 所有被选中cell的订单Id
 @property (nonatomic,strong) NSMutableArray *SelectedCellAccountingIds;

 /// cell的大小
 @property (nonatomic,assign) CGSize itemSize;

 //**代理/
 @property (nonatomic, weak)id<QTSelectCollectionViewDelegate> SelectColDelegate;
QTDateCollectionView

  @class QTDate,QTDateCollectionView;

 @protocol QTDateCollectionViewDelegate <NSObject>
  @optional

  /// 监听的滚动位移
  - (void)dateCollectionView:(QTDateCollectionView *)collectionView DidScrollWithContentOffset:(CGPoint)contentOffset;

    @end

 @interface QTDateCollectionView : UICollectionView

  /// cell的大小
  @property (nonatomic,assign) CGSize itemSize;

 //**代理*/
 @property (nonatomic, weak) id<QTDateCollectionViewDelegate> dateDelegate;
 @end
控制器

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
 self.totalNoView.frame = CGRectMake(0, viewY + viewHeight * heightMultiple * 0.5, viewWidth*2,   viewHeight*heightMultiple*0.5);
 // 设置collectionViewW
 self.dateCollectionView.frame = CGRectMake(viewWidth * 2, 0, collectionViewW, viewHeight*heightMultiple);
 itemW = (collectionViewW - 4)*0.2;
 self.dateCollectionView.itemSize = CGSizeMake(itemW, viewHeight*heightMultiple);


 CGFloat scrollViewY = CGRectGetMaxY(self.dateCollectionView.frame);
 CGFloat scrollViewH = HEIGHT - scrollViewY-64 ;
 self.backScrollView.frame = CGRectMake(0, scrollViewY, WIDTH , scrollViewH);
 self.selectCollectionView.frame = CGRectMake(0, 0, collectionViewW, scrollViewH);

 }
创建小cell

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
监听事件

  #pragma mark - ZLTDateCollectionViewDelegate方法
 /// 根据dateCollectionView的滚动，使选项selectCollectionVie同步滚动
 - (void)dateCollectionView:(QTDateCollectionView *)collectionView DidScrollWithContentOffset:(CGPoint)contentOffset
  {
     self.currentContentOffset = contentOffset;
     // 调用监听collectionView滚动的方法
     [self collectionViewDidScrollWithContentOffset:contentOffset];
         // 便利数组
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
### 时间处理 /// 获取分割后的当前日期，形式"yyyy","MM","dd" WithIndex:(NSUInteger)index - (NSArray *)getDate{

  NSDate *date = [NSDate dateWithTimeIntervalSinceNow:60*60*24*self.index];
  //    NSLog(@"--index:%zd",self.index);
 NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
 formatter.dateFormat  = @"yyyy-MM-dd";
 //    formatter.dateFormat =  [date getDayOfWeekShortString];
 NSString *dateStr = [formatter stringFromDate:date];
 //    NSLog(@"%@",dateStr);
 return [dateStr componentsSeparatedByString:@"-"];
 }
#### /// 获取当前周几 - (NSString *)getWeekday { NSDateComponents *_comps = [[NSDateComponents alloc] init]; [_comps setDay:[[self getDay] integerValue]]; NSString *monthStr = [self getDate][1]; [_comps setMonth:[monthStr integerValue]]; [_comps setYear:[[self getYear] integerValue]];

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
如以上有不合适的地方,欢迎大神指点..
