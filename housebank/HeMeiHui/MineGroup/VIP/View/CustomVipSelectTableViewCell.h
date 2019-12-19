//
//  CustomVipSelectTableViewCell.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
//批发
@interface CustomVipSelectTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) PriceInfos *priceInfosModel;

@end

//返利
@interface CustomVipTreturnoOnProfittTableViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) RebateInfo *rebateInfoModel;
@end

NS_ASSUME_NONNULL_END
