//
//  STAddressTopView.h
//  housebank
//
//  Created by liqianhong on 2018/10/27.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCitiesGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface STAddressTopView : UIView

typedef void(^ZJCitySelectedHandlerTopView)(NSString *title);
/**
 *  初始化城市控制器
 *
 *  @param dataArray 城市数组, 数组的格式是有要求的 需要时数组中的元素仍然是ZJCitiesGroup
 *
 *  @return
 */



-(void)refreshCollectionHistoryCity;

@end

NS_ASSUME_NONNULL_END
