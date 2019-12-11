//
//  WARFavriteGenarSegementView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import <UIKit/UIKit.h>
@class WARFavriteGenarSegementView;
@protocol WARFavriteGenarSegementViewDelegate <NSObject>
- (void)favriteGenarSegementView:(WARFavriteGenarSegementView*)view didSelectIndexPath:(NSIndexPath*)indexpath;
@end
@interface WARFavriteGenarSegementView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionVSegment;

@property (nonatomic,strong) NSArray *segementArr;

@property (nonatomic,weak) id<WARFavriteGenarSegementViewDelegate> delegate;
@end
