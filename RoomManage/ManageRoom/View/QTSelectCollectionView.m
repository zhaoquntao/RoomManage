//
//  QTSelectCollectionView.m
//  RoomManageDemo
//
//  Created by 赵群涛 on 16/8/18.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import "QTSelectCollectionView.h"
#import "QTDate.h"

@interface QTSelectCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>

/// 流水布局
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
/// 日期模型集合
@property (nonatomic,strong) NSArray *dates;


@end

static NSString *const dateCellreuseIdentifier = @"SelectCell";

@implementation QTSelectCollectionView

- (instancetype)init {
    self.backgroundColor = [UIColor whiteColor];
    if (self = [super initWithFrame:CGRectZero collectionViewLayout:self.layout]) {
        self.dataSource = self;
        self.delegate = self;
        
        [self registerClass:[QTSelectCollectionViewCell class] forCellWithReuseIdentifier:dateCellreuseIdentifier];
        
    }
    return self;
    
}

#pragma mark - UICollcetionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QTSelectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dateCellreuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = kUIColorFromRGB(0xf4f4f4);
    cell.textLabel.hidden= YES;
    
    for (id indexObj in self.SelectedCellIndexs) {
        NSInteger index = [indexObj integerValue];
        if (index == indexPath.item) {
            cell.textLabel.hidden = NO;
            break;
        }
    }
    
    return cell;
}

//滚动监听

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 调用代理方法
    if ([self.SelectColDelegate respondsToSelector:@selector(selectCollectionView:DidScrollWithContentOffset:)]) {
        [self.SelectColDelegate selectCollectionView:self DidScrollWithContentOffset:scrollView.contentOffset];
    }
}


//监听选中的某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.SelectColDelegate respondsToSelector:@selector(selectCollectionView:didSelectItemAtIndex:)]) {
        [self.SelectColDelegate selectCollectionView:self didSelectItemAtIndex:indexPath.item];
    }
}

#pragma mark - setter & getter

- (void)setItemSize:(CGSize)itemSize
{
    _itemSize = itemSize;
    self.layout.itemSize = itemSize;
}

#pragma mark - 懒加载

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        // 设置水平滚动
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.minimumLineSpacing = 1;
        _layout.minimumInteritemSpacing = 1;
        
    }
    return _layout;
}

- (NSArray *)dates
{
    if (!_dates) {
        _dates = [QTDate dates];
    }
    return _dates;
}

- (NSMutableArray *)SelectedCellIndexs
{
    if (!_SelectedCellIndexs) {
        _SelectedCellIndexs = [NSMutableArray array];
    }
    return _SelectedCellIndexs;
}

- (NSMutableArray *)SelectedCellAccountingIds
{
    if (!_SelectedCellAccountingIds) {
        _SelectedCellAccountingIds = [NSMutableArray array];
    }
    return _SelectedCellAccountingIds;
}
@end
#pragma mark - 实现自定义的ZLTSelectCollectionViewCell

@interface QTSelectCollectionViewCell ()

@end

@implementation QTSelectCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self prepareUI];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

#pragma mark - 准备UI
- (void)prepareUI{
    // 1.添加子控件
    [self.contentView addSubview:self.textLabel];
    // 2.设置约束
    self.textLabel.frame = self.contentView.bounds;
}

#pragma mark - 懒加载
- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [UILabel labelWithTextColor:[UIColor whiteColor] backgroundColor:kUIColorFromRGB(0xffb400) fontSize:16];
        _textLabel.text = @"订";
        _textLabel.hidden = YES;
    }
    return _textLabel;
}

@end




