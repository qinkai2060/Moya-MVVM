//
//  HFStarFilterCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFilterPriceModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HFStarFilterCell;
@protocol HFStarFilterCellDelegate <NSObject>

- (void)starFilterCell:(HFStarFilterCell*)cell selectArray:(NSArray*)selectArray;

@end
@interface HFStarFilterCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)HFFilterPriceModel *starfilterModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,weak)id<HFStarFilterCellDelegate> delegate;
- (void)doSomthing;
@end

NS_ASSUME_NONNULL_END
