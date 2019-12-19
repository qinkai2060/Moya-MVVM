//
//  HFFashionNewCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFFashionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFFashionNewCell : HFHomeNewBaseCell
<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)HFFashionModel *fashionModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

NS_ASSUME_NONNULL_END
