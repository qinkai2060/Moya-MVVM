//
//  WARFavriteMineView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/15.
//

#import <UIKit/UIKit.h>
#import "WARFavoriteModel.h"
@interface WARFavriteMineView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UILabel *headerlb;
@property (nonatomic,strong) NSArray *favdataSource;
@property (nonatomic,strong) WARFavoriteModel *model;
@end
