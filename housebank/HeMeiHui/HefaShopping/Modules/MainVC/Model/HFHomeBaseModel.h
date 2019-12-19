//
//  HFHomeBaseModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HFLinkMappModel;
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    HHFHomeBaseModeBrowserBannerType =1,
    HHFHomeBaseModeGlobalInterfaceType=2 ,
    HHFHomeBaseModelTypeNewsType=3,
    HHFHomeBaseModelTypeTimeLimitKillType=4,
    HHFHomeBaseModelTypeAdType=5,
    HHFHomeBaseModelTypeSpecialPriceType=6,
    HHFHomeBaseModelTypeFashionType=7,
    HHFHomeBaseModelTypeZuberType=8 ,
    HHFHomeBaseModelTypeModuleFourType=9,
    HHFHomeBaseModelTypeFiveOneType=10,
    HHFHomeBaseModelTypeFiveTwoType=11,
    HHFHomeBaseModelTypeThreeType=12,
    HHFHomeBaseModelTypeSixType=13,
    HHFHomeBaseModelTypeClassify=14,
    HHFHomeBaseModelTypeGoodsVideo=15,
    HHFHomeBaseModelTypeHotKey=16,
    HHFHomeBaseModelTypePopup=17
} HHFHomeBaseModelType;
@interface HFHomeBaseModel : NSObject
@property(nonatomic,assign)HHFHomeBaseModelType contenMode;
@property(nonatomic,copy)NSArray *dataArray;
@property(nonatomic,assign)CGFloat rowheight;
@property(nonatomic,assign)CGFloat horsizeW;
@property(nonatomic,assign)BOOL isVipP;
@property(nonatomic,strong)HFLinkMappModel *linkMappingModel;
@property(nonatomic,strong)HFLinkMappModel *linkMappingModel2;
//@property(nonatomic,strong) *dataArray;
//@property(nonatomic,copy)NSString *linkMapingId;
//@property(nonatomic,copy)NSString *linkMapingType;
+ (void)registerRenderCell:(Class)cellClass messageType:(NSInteger)mtype;
- (void)getData:(NSDictionary *)data;
+ (Class)getRenderClassByMessageType:(HHFHomeBaseModelType)mtype;
@end
@interface HFLinkMappModel:NSObject
@property(nonatomic,copy)NSDictionary *level_3;
@property(nonatomic,copy)NSDictionary *level_2;
@property(nonatomic,copy)NSDictionary *level_1;
@property(nonatomic,copy)NSString *linkId;
@property(nonatomic,assign)BOOL isNeedLogin;
@property(nonatomic,copy)NSString *link;
@property(nonatomic,copy)NSString *type;
- (void)getData:(NSDictionary *)data;
+ (instancetype)linkMappingWithDict:(NSDictionary*)dict ;
@end

NS_ASSUME_NONNULL_END
