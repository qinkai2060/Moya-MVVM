//
//  WARPhotosCollectionView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/27.
//

#import <UIKit/UIKit.h>
@class WARPhotosCollectionView;
@class WARPhotosCollectionCell;
@protocol WARPhotosCollectionViewDelegate<UICollectionViewDelegate>
- (void)gestureBegan:(WARPhotosCollectionView*)collectionView tempview:(UIView*)tempView ;
- (void)gestureChange:(WARPhotosCollectionView*)collectionView tempview:(UIView*)tempView point:(CGPoint)point;
- (void)gestureEnd:(WARPhotosCollectionView *)collectionView tempview:(UIView *)tempView point:(CGPoint)point atCell:(WARPhotosCollectionCell*)cell;
@end
@interface WARPhotosCollectionView : UICollectionView
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
/**
 *  长按手势最小触发时间，默认1.0，最小0.2
 */
@property (nonatomic, assign) CGFloat gestureMinimumPressDuration;
/**
 *  是否允许拖动到屏幕边缘后，开启边缘滚动，默认YES
 */
@property (nonatomic, assign) BOOL canEdgeScroll;
/**
 *  边缘滚动触发范围，默认150，越靠近边缘速度越快
 */
@property (nonatomic, assign) CGFloat edgeScrollRange;
//
//@property (nonatomic, weak) id<WARTableViewDataSource> dataSource;
@property (nonatomic, weak) id<WARPhotosCollectionViewDelegate> delegate;
/**
 *  自定义可移动cell的截图样式
 */
@property (nonatomic, copy) void(^drawMovalbeCellBlock)(UIView *movableCell);
@end
