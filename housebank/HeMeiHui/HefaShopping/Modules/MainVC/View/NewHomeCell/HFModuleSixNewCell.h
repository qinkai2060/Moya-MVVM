//
//  HFModuleSixNewCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFModuleSixView.h"
#import "HFModuleSixModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFModuleSixNewCell : HFHomeNewBaseCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)HFModuleSixModel *sixModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)HFModuleSixView *soneV;
@property(nonatomic,strong)HFModuleSixView *soneV1;
@property(nonatomic,strong)HFModuleSixView *soneV2;
@property(nonatomic,strong)HFModuleSixView *soneV3;
@end

NS_ASSUME_NONNULL_END
