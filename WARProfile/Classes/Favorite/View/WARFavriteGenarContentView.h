//
//  WARFavriteGenarContentView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import <UIKit/UIKit.h>
@class WARFavriteGenarContentView;
@protocol WARFavriteGenarContentViewDelegate <NSObject>
- (void)favriteGenarContentView:(WARFavriteGenarContentView*)view moveEndAtIndex:(NSInteger)index;
@end
@interface WARFavriteGenarContentView : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
/**typeArr*/
@property (nonatomic,strong) NSArray *typeContenArray;

@property (nonatomic,weak) id<WARFavriteGenarContentViewDelegate> delegate;

- (void)selectIndex:(NSInteger)index;
@end
