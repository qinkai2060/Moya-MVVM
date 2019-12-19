//
//  CollectGlobalModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@interface CollectGlobalItemModel : NSObject  <NSCoding, JXModelProtocol>
@property (nonatomic, copy) NSString * hotelId;       /**酒店id */
@property (nonatomic, copy) NSString * title;         /**房屋标题 */
@property (nonatomic, copy) NSString * star;          /**星级 */
@property (nonatomic, copy) NSString * cityId;        /**省id */
@property (nonatomic, copy) NSString * regionId;      /**城市id */
@property (nonatomic, copy) NSString * blockId;       /**区域id*/
@property (nonatomic, copy) NSString * addressCn;     /**中文地址 */
@property (nonatomic, copy) NSString * renovationDate; /**装修时间 */
@property (nonatomic, copy) NSString * imageUrl;      /**房屋图片路径 */
@property (nonatomic, copy) NSString * cityName;      /**省份名称 */
@property (nonatomic, copy) NSString * regionName;    /**城市名称 */
@property (nonatomic, copy) NSString * blockName;     /**区域名称 */
@property (nonatomic, copy) NSString * starName;      /**星级名称 */
@property (nonatomic, assign) NSInteger commentNum;
@property (nonatomic, copy) NSString * price;
@end


@interface CollectGlobalModel : NSObject <JXModelProtocol, NSCoding>
@property (nonatomic, strong) NSArray <CollectGlobalItemModel *> *dataSource;

@end

NS_ASSUME_NONNULL_END
