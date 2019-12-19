//
//  ShopListViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/16.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "GoodsDetailModel.h"
#import "ShopDetailModel.h"
#import "GetProductListByConditionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopListViewController : SpBaseViewController

@property (nonatomic, strong) NSNumber *shopId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *headerView ;
@property (nonatomic, strong) UIView *headerBagView ;
@property (nonatomic, strong)UIImageView *bagImage;
/**店铺图标 */
@property (nonatomic,strong) UIImageView *iconImg;
/* 店铺标记 */
@property (strong , nonatomic)UILabel *shopMarkLabel;
/** 店铺名字 */
@property (nonatomic,strong) UILabel *nameLab;
/**关注数 */
@property (nonatomic,strong) UILabel *followCountLab;
/** 关注按钮 */
@property (nonatomic,strong) UIButton *tfollowBtn;
@property (nonatomic, strong)GoodsDetailModel*detailModel;
@property (nonatomic, strong) ShopDetailModel *ShopdetailModel;

// 从搜索列表页传入的model
@property (nonatomic, strong) GetProductListByConditionModel *productModel;
@end

NS_ASSUME_NONNULL_END
