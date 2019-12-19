//
//  FeatureViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/17.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"
#import "ProductFeatureModel.h"
#import "PropertyCell.h"
#import "PropertyHeader.h"
#import "GoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol FeatureViewDelegate <NSObject>
- (void)selectedItemType:(NSString*)type dic:(NSDictionary*)dic;
- (void)featureViewdismissVC;

@end


@interface FeatureViewController : UIViewController
@property(nonatomic,weak)id<FeatureViewDelegate> Delegate;
@property (nonatomic, strong)  ProductFeatureModel *featureModel;

//header
@property (nonatomic, strong) UIImageView *imageView ;
@property (nonatomic, strong) UILabel *priceL ;
@property (nonatomic, strong) UILabel *storeL ;
@property (nonatomic, strong) UILabel *selectedLable ;
@property (nonatomic, strong) UIButton *closeBtn;

//foot
@property (nonatomic, strong) UILabel *buyCount ;
@property (nonatomic, strong) UILabel *buyLimitCount ;
@property (nonatomic, strong)PPNumberButton *changeNumberBtn;
@property (nonatomic, strong)NSString * productId;

/* 上一次选择的数量 */
@property (assign , nonatomic)NSString *lastNum;
@property (assign , nonatomic)GoodsDetailModel *detailModel;
/* type */
@property (nonatomic, strong)NSIndexPath * indexpath;
@property (assign , nonatomic)NSString *type;//选择规格  购物车 立即购买
- (void)loadingProductMap:(NSDictionary *)productMap;
-(void)tapGRAction;

//@property (nonatomic,strong)
//
@end

NS_ASSUME_NONNULL_END
