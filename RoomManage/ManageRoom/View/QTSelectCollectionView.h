//
//  QTSelectCollectionView.h
//  RoomManageDemo
//
//  Created by 赵群涛 on 16/8/18.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QTSelectCollectionView,QTSelectCollectionViewCell;

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

@end

#pragma mark - 自定义QTSelectCollectionViewCell

@interface QTSelectCollectionViewCell : UICollectionViewCell

/**
 *  显示文字的标签
 */
@property (nonatomic,strong) UILabel *textLabel;
@end