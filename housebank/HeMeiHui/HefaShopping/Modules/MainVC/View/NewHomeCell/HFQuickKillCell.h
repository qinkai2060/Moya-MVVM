//
//  HFQuickKillCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFTimeLimitModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFQuickKillCell : HFHomeNewBaseCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIImageView *timelimtiKillImageView;
@property(nonatomic,strong)UILabel *distanceTimeTitlelb;
@property(nonatomic,strong)UILabel *hourlb;
@property(nonatomic,strong)UILabel *minlb;
@property(nonatomic,strong)UILabel *secondlb;
@property(nonatomic,strong)UILabel *hourlbAndMinlb;
@property(nonatomic,strong)UILabel *minAndSecondlb;//冒号
@property(nonatomic,strong)HFTimeLimitModel *timeKillModel;

@end

NS_ASSUME_NONNULL_END
