//
//  WARFavriteCenarContenCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/31.
//

#import <UIKit/UIKit.h>

@interface WARFavriteCenarContenCell : UICollectionViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
/**typeArr*/
@property (nonatomic,strong) NSArray *contentArray;

@property (nonatomic,assign) BOOL canScroll;

@end
