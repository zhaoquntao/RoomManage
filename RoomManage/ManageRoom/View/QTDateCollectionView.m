//
//  QTDateCollectionView.m
//  RoomManage
//
//  Created by 赵群涛 on 16/8/17.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "QTDateCollectionView.h"
#import "QTDate.h"

@interface QTDateCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>

/// 流水布局
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
/// 日期模型集合
@property (nonatomic,strong) NSArray *dates;

@end

BOOL isFirstCell = NO;
static NSString * const dateCellreuseIdentifier = @"DateCell";

@implementation QTDateCollectionView

#pragma mark - 构造函数
- (instancetype)init
{
    self.backgroundColor = [UIColor whiteColor];
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:self.layout]) {
        // 设置数据源
        self.dataSource = self;
        // 设置代理
        self.delegate = self;
        // 注册cell
        [self registerClass:[QTDateCollectionViewCell class] forCellWithReuseIdentifier:dateCellreuseIdentifier];
        
    }
    return self;
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.dates = [QTDate dates];
    return self.dates.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QTDate *date = self.dates[indexPath.item];
    
    isFirstCell = indexPath.item == 0 ? YES : NO;
    QTDateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dateCellreuseIdentifier forIndexPath:indexPath];
    
    // 设置显示内容
    cell.date = date;
    
    return cell;
}

//监听滚动

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = scrollView.contentOffset;
    // 调用代理方法
    if ([self.dateDelegate respondsToSelector:@selector(dateCollectionView:DidScrollWithContentOffset:)]) {
        [self.dateDelegate dateCollectionView:self DidScrollWithContentOffset:contentOffset];
    }
}

#pragma mark - setter & getter 

- (void)setItemSize:(CGSize)itemSize {
    _itemSize = itemSize;
    self.layout.itemSize = itemSize;
    
}


#pragma mark - 懒加载

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 1;
        _layout.minimumInteritemSpacing = 1;
        
    }
    return _layout;
}

@end

#pragma mark - 实现自定义cell

@interface QTDateCollectionViewCell()
/// 周几
@property (nonatomic,strong) UILabel *weekdayView;
/// 几号
@property (nonatomic,strong) UILabel *dayView;

@end

@implementation QTDateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 0.1;
        [self prepareUI];
    }
    return self;
    
}

#pragma mark -  setter

- (void)setDate:(QTDate *)date
{
    _date = date;
    self.dayView.text = date.day;
    
    self.weekdayView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    self.dayView.backgroundColor = kUIColorFromRGB(0xFFFFFF);
    
    if (isFirstCell) {
        self.weekdayView.text = @"今天";
        [self setupTodayTextColor];
        //        isFirstCell = NO;
    }else if ([date.weekday isEqualToString:@"周五"] || [date.weekday isEqualToString:@"周六"]) {
        self.weekdayView.text =date.weekday;
        [self setupTextColorRed];
    } else {
        self.weekdayView.text =date.weekday;
        [self setupTextColorGreen];
    }
    
    
}

/// 设置今天cell的颜色
- (void)setupTodayTextColor
{
    self.weekdayView.textColor = kUIColorFromRGB(0xFFFFFF);
    self.weekdayView.backgroundColor = kUIColorFromRGB(0x74c8c9);
    self.dayView.textColor = kUIColorFromRGB(0xFFFFFF);
    self.dayView.backgroundColor = kUIColorFromRGB(0x74c8c9);
}

/// 设置周五、六、日cell的颜色
- (void)setupTextColorRed
{
    self.weekdayView.textColor = kUIColorFromRGB(0xFF5656);
    self.dayView.textColor = kUIColorFromRGB(0xFF5656);
}
/// 设置文本字体为白色
- (void)setupTextColorGreen
{
    self.weekdayView.textColor = kUIColorFromRGB(0x999999);
    self.dayView.textColor = kUIColorFromRGB(0x666666);
}


#pragma mark - 准备UI
- (void)prepareUI
{
    // 1. 添加子控件
    [self.contentView addSubview:self.weekdayView];
    [self.contentView addSubview:self.dayView];
    
    // 2.设置frame
    
    CGSize itemSize = self.bounds.size;
    self.weekdayView.frame = CGRectMake(0, 0, itemSize.width, itemSize.height*0.5+0.5);
    self.dayView.frame = CGRectMake(0, itemSize.height*0.5, itemSize.width, itemSize.height*0.5);
}

#pragma mark - 懒加载

- (UILabel *)weekdayView
{
    if (!_weekdayView) {
        _weekdayView = [UILabel labelWithTextColor:kUIColorFromRGB(0x999999) backgroundColor:kUIColorFromRGB(0xFFFFFF) fontSize:12];
    }
    return _weekdayView;
}

- (UILabel *)dayView
{
    if (!_dayView) {
        _dayView = [UILabel labelWithTextColor:kUIColorFromRGB(0x666666) backgroundColor:kUIColorFromRGB(0xFFFFFF) fontSize:16];
    }
    return _dayView;
}


@end

