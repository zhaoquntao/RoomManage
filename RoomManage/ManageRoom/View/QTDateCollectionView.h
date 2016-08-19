//
//  QTDateCollectionView.h
//  RoomManage
//
//  Created by 赵群涛 on 16/8/17.
//  Copyright © 2016年 ZQT. All rights reserved.
//

#import <UIKit/UIKit.h>
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

@interface QTDateCollectionViewCell: UICollectionViewCell
/// 日期模型
@property (nonatomic,strong) QTDate *date;

@end
