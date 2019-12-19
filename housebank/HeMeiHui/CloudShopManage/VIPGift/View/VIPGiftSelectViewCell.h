//
//  VIPGiftSelectViewCell.h
//  HeMeiHui
//
//  Created by Tracy on 2019/9/23.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipGiftShopModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^CallScrolleBlock)(NSInteger index,NSInteger section);
typedef void(^PopNextBlock)(VipGiftShopModel *itemModel);
typedef void(^ScrolleBlock)(NSInteger page);
@interface VIPGiftSelectViewCell : UICollectionViewCell
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, copy) CallScrolleBlock scrolleBlock;
@property (nonatomic, copy) PopNextBlock popNextBlock;
@property (nonatomic, copy) ScrolleBlock pageBlcok;
- (void)setUpDataSouce:(NSArray *)dataSource withSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
