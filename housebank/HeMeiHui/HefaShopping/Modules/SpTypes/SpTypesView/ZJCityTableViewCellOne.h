//
//  ZJFlowLayoutTableViewCell.h
//  ZJIndexedCitySelect
//
//  Created by ZeroJ on 16/10/12.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindRegionsModel.h"
@class ZJCitiesGroup;

typedef void(^ZJCityCellClickHandler)(FindRegionsModel *model);
@interface ZJCityTableViewCellOne : UITableViewCell
@property (assign, nonatomic) CGFloat cellHeight;
//@property (strong, nonatomic) ZJCitiesGroup *citiesGroup;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCirysArr:(NSMutableArray *)citysArr;

- (void)setupCityCellClickHandler:(ZJCityCellClickHandler)cityCellClickHandler;

@end
