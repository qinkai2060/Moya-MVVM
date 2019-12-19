//
//  VipGiftBagHeadView.h
//  HeMeiHui
//
//  Created by Tracy on 2019/7/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VIPGiftSelectHeadView.h"
NS_ASSUME_NONNULL_BEGIN

@interface VipGiftBagHeadView : UICollectionReusableView
- (void)setHeadDic:(NSDictionary *)headDic withIndexPath:(NSInteger)path;
@property (nonatomic, strong)VIPGiftSelectHeadView * headSelectView;
@end

NS_ASSUME_NONNULL_END
