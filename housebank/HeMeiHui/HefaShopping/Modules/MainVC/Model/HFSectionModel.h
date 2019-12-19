//
//  HFSectionModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HFSegementModel;
@class HFPopupModel;
@class HFHomeBaseModel;
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    HFSectionModelBrowserBannerType =1,
    HFSectionModelGlobalInterfaceType=2 ,
    HFSectionModelNewsType=3,
    HFSectionModelTimeLimitKillType=4,
    HFSectionModelAdType=5,
    HFSectionModelSpecialPriceType=6,
    HFSectionModelFashionType=7,
    HFSectionModelZuberType=8 ,
    HFSectionModelModuleFourType=9,
    HFSectionModelFiveOneType=10,
    HFSectionModelFiveTwoType=11,
    HFSectionModelFiveThreeType=12,
    HFSectionModelModuleSixType=13,
    HFSectionModelModuleClass=14,
    HFSectionModelModuleGoodsVideo=15,
    HFSectionModelModuleHotKey=16,
    HFSectionModelModulePopUp=17
} HFSectionModelDataType;
@class HFSectionHeaderRect;
@interface HFSectionModel : NSObject
//@property(nonatomic,strong)HFCellBaseViewModel *viewmodel;
@property(nonatomic,strong)NSArray<HFHomeBaseModel*> *dataModelSource;
@property(nonatomic,assign)HFSectionModelDataType contentMode;
@property(nonatomic,assign)NSInteger type;

@property(nonatomic,assign)BOOL isVip;
@property(nonatomic,assign)BOOL isModuleShow;
@property(nonatomic,assign)BOOL isModuleTitleShow;
@property(nonatomic,copy)NSString *moduleTitle;
//@property(nonatomic,assign)CGFloat headerVHeight;
@property(nonatomic,assign)CGFloat sectionHeight;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)HFSectionHeaderRect *rectFrame;

+ (NSArray*)jsonSerialize:(NSArray*)dataArray isVip:(BOOL)isVip;
+ (CGFloat)headerVIPHeight:(NSArray*)array ;
+ (NSDictionary *)readLocalFileWithName:(NSString *)name;
//+ (HFSegementModel*)segementMode:(NSArray*)array;

/**
 广告

 @param array 所有数据数组
 @return 返回广告
 */
+ (HFPopupModel*)popupModel:(NSArray*)array;
@end
@interface HFSectionHeaderRect:NSObject
@property(nonatomic,assign)CGFloat itemx;
@property(nonatomic,assign)CGFloat itemy;
@property(nonatomic,assign)CGFloat itemW;
@property(nonatomic,assign)CGFloat itemH;
@end
NS_ASSUME_NONNULL_END
