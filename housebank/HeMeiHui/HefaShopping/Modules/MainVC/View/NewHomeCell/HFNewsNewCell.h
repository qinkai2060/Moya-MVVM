//
//  HFNewsNewCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeNewBaseCell.h"
#import "HFNewsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFNewsNewCell : HFHomeNewBaseCell
@property(nonatomic,strong)HFNewsModel *newsModel;
@property(nonatomic,strong)UIImageView *quickImageV;
@property(nonatomic,strong)UILabel *hotTitleLb;
@property(nonatomic,strong)UITableView *titleTableView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIButton *morelb;
@property(nonatomic,strong)UIView *lineView;
@end

NS_ASSUME_NONNULL_END
