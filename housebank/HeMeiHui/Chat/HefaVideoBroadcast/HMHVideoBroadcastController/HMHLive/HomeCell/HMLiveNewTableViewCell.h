//
//  HMLiveNewTableViewCell.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HMLiveBaseCell.h"
#import "HMHLiveModules_newsModel.h"
#import "HMHLivieNewsItemsModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^HMLiveNewTableViewCellClickBlcok)(HMHLivieNewsItemsModel *model, NSInteger type);// 0 cell点击 1 更多

@interface HMLiveNewTableViewCell : HMLiveBaseCell
@property (nonatomic, strong) UIImageView *quickImageV;
@property (nonatomic, strong) UILabel *hotTitleLb;
@property (nonatomic, strong) UITableView *titleTableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *morelb;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) HMHLiveModules_newsModel *model;
@property (nonatomic, copy) HMLiveNewTableViewCellClickBlcok newClickBlcok;
- (void)doMessageRendering;
@end

NS_ASSUME_NONNULL_END
