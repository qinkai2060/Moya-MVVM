//
//  HFCarSectionHeaderView.h
//  housebank
//
//  Created by usermac on 2018/10/29.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFShopingModel.h"
#import "HFPaymentBaseModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef  NS_ENUM(NSInteger,HFCarSectionHeaderViewType) {
    HFCarSectionHeaderViewTypeDefualt = 1,
    HFCarSectionHeaderViewTypePayMent = 2
};
@interface HFCarSectionHeaderView : HFView
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, copy) HFOrderShopModel *ordermodel;
@property (nonatomic,assign)HFCarSectionHeaderViewType type;
@property (nonatomic, strong) HFShopingModel *storeingModel;

- (void)setShoppingModel:(HFShopingModel*)shoppingModel;
- (void)setShoppingModelStr:(NSString*)countStr;
@end

NS_ASSUME_NONNULL_END
