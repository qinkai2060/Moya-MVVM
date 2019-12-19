//
//  HFNewsSmallCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/2.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFNewsModel.h"
#import "HMHLivieNewsItemsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFNewsSmallCell : UICollectionViewCell
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)HMHLivieNewsItemsModel *newsLiveModel;
@property(nonatomic,strong)HFNewsModel *newsModel;
- (void)getData;
- (void)getDatalive;
@end

NS_ASSUME_NONNULL_END
