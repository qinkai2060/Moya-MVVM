//
//  HFGlobaInterFaceNewCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFGlobalInterfaceModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFGlobaInterFaceNewCell : HFHomeNewBaseCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)HFGlobalInterfaceModel *InterfaceModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *trackView;
@property(nonatomic,strong)UIView *bgView;

@end

NS_ASSUME_NONNULL_END
