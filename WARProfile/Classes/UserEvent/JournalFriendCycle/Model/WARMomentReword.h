//
//  WARMomentReword.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/26.
//

//金币、经验值、耐力值、卡
#define WARMomentReword_JINBI          @"JINBI" //金币
#define WARMomentReword_EXP            @"EXP" //经验值
#define WARMomentReword_HP             @"HP" //耐力值
#define WARMomentReword_KAPIAN         @"KAPIAN" //卡

typedef NS_ENUM(NSUInteger, WARMomentRewordType) {
    WARMomentRewordTypeJinBi = 1,
    WARMomentRewordTypeExp,
    WARMomentRewordTypeHp,
    WARMomentRewordTypeKaPian,
};

#import <Foundation/Foundation.h>

@interface WARMomentReword : NSObject
/** 唯一标记 */
@property (nonatomic, copy) NSString *rewordId;
/** 分类:金币、经验值、耐力值、卡 */
@property (nonatomic, copy) NSString *rewordTp;
/** 奖励值 */
@property (nonatomic, copy) NSString *rewordVal;

/** 辅助字段 */
/** 分类:金币、经验值、耐力值、卡 */
@property (nonatomic, assign) WARMomentRewordType rewordTypeEnum;
@end
