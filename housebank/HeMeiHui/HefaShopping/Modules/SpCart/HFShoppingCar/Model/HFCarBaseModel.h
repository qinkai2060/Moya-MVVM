//
//  HFCarBaseModel.h
//  housebank
//
//  Created by usermac on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <YYKit/YYKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,HFCarshoppCellType) {
    HFCarshoppCellTypeCarGoods = 1,
    HFCarshoppCellTypeCarGoodsLose,
    HFCarshoppCellTypeCarGoodsLike,
    HFCarshoppCellTypeCarEmpty
    
};
@interface HFCarBaseModel : NSObject<NSCoding>
@property (nonatomic, assign)  NSInteger    msgType;
@property (nonatomic, assign)  float        renderHeight;
+ (void)registerRenderCell:(Class)cellClass messageType:(NSInteger)mtype;
- (void)getData:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
