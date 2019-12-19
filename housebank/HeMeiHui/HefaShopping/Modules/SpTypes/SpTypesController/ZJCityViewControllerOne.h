//
//  ViewController.h
//  ZJIndexContacts
//
//  Created by ZeroJ on 16/10/10.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJCitiesGroup.h"
#import "SpBaseViewController.h"
#import "FindRegionsModel.h"

@interface ZJCityViewControllerOne : SpBaseViewController
typedef void(^ZJCitySelectedHandler)(FindRegionsModel *model);
/**
 *  初始化城市控制器
 *
 *  @param dataArray 城市数组, 数组的格式是有要求的 需要时数组中的元素仍然是ZJCitiesGroup
 *
 *  @return
 */
- (instancetype)initWithDataArray:(NSArray<ZJCitiesGroup *> *)dataArray withType:(NSInteger)type;
- (void)setupCityCellClickHandler:(ZJCitySelectedHandler)citySelectedHandler;

@end

